<?php

declare(strict_types=1);

namespace App\Services\Gateway;

use App\Models\Paylist;
use App\Models\Config;
use App\Services\Auth;
use App\Services\Exchange;
use App\Services\View;
use App\Utils\Tools;
use DateTime;
use Exception;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;
use Psr\Http\Message\ResponseInterface;
use RedisException;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

use voku\helper\AntiXSS;

final class NowPayments extends Base
{
    protected array $nowpayments = [];
    protected array $headers = [];
    private Client $client;

    public function __construct()
    {
        $this->nowpayments['apiurl'] = Config::obtain('nowpayments_url');
        $this->nowpayments['ipn_secret'] = Config::obtain('nowpayments_ipn_secret');
        $this->nowpayments['price_currency'] = Config::obtain('nowpayments_price_currency');
        $this->nowpayments['pay_currency'] = Config::obtain('nowpayments_pay_currency');

        $this->client = new Client();
        $this->headers = [
            'x-api-key' => Config::obtain('nowpayments_api_key'),
            'Content-Type' => 'application/json'
        ];
    }

    public static function _name(): string
    {
        return 'nowpayments';
    }

    public static function _enable(): bool
    {
        return self::getActiveGateway('nowpayments');
    }

    public static function _readableName(): string
    {
        return 'NowPayments';
    }

    /**
     * @throws GuzzleException
     * @throws RedisException
     */
    public function purchase(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $antiXss = new AntiXSS();
        $user = Auth::getUser();
        $configs = Config::getClass('billing');
        $price = $antiXss->xss_clean($request->getParam('price'));
        $invoice_id = $antiXss->xss_clean($request->getParam('invoice_id'));
        $qr = $antiXss->xss_clean($request->getParam('qr'));
        $trade_no = self::generateGuid();

        $pl = new Paylist();
        $pl->userid = $user->id;
        $pl->total = $price;
        $pl->invoice_id = $invoice_id;
        $pl->gateway = self::_readableName();
        $pl->tradeno = $trade_no;
        $pl->save();

        $exchange_amount = (new Exchange())->exchange((float) $price, 'IRR', Config::obtain('nowpayments_price_currency'));

        if (isset($qr)) {
            $body = [
                'price_amount' => $exchange_amount,
                'price_currency' => $this->nowpayments['price_currency'],
                'pay_currency' => $this->nowpayments['pay_currency'],
                'ipn_callback_url' => $_ENV['baseUrl'] . '/payment/notify/nowpayments',
                'order_id' => $pl->tradeno,
                'order_description' => $_ENV['appName'] . "-Invoice # " . $invoice_id,
            ];

            $data = json_decode($this->client->post($this->nowpayments['apiurl'] . 'payment', [
                'headers' => $this->headers,
                'json' => $body,
                'timeout' => 10,
            ])->getBody()->getContents());

            $dateTimeObject = new DateTime($data->expiration_estimate_date);

            return $response->withJson([
                'ret' => 1,
                'qrcode' => $data->pay_address,
                'amount' => $exchange_amount,
                'currency' => $data->pay_currency,
                'expire' => Tools::toDateTime($dateTimeObject->getTimestamp()),
                'pid' => $data->order_id,
            ]);
        }

        $body = [
            'price_amount' => $exchange_amount,
            'price_currency' => $this->nowpayments['price_currency'],
            'pay_currency' => $this->nowpayments['pay_currency'],
            'ipn_callback_url' => $_ENV['baseUrl'] . '/payment/notify/nowpayments',
            'order_id' => $pl->tradeno,
            'order_description' => $_ENV['appName'] . "-Invoice # " . $invoice_id,
            "success_url" => $_ENV['baseUrl'] . '/user/payment/return/nowpayments',
            "cancel_url" => $_ENV['baseUrl'] . '/user/payment/return/nowpayments'
        ];

        $data = json_decode($this->client->post($this->nowpayments['apiurl'] . 'invoice', [
            'headers' => $this->headers,
            'json' => $body,
            'timeout' => 10,
        ])->getBody()->getContents());

        return $response->withRedirect($data->invoice_url);
    }

    public function notify($request, $response, $args): ResponseInterface
    {
        if (isset($_SERVER['HTTP_X_NOWPAYMENTS_SIG']) && !empty($_SERVER['HTTP_X_NOWPAYMENTS_SIG'])) {
            $recived_hmac = $_SERVER['HTTP_X_NOWPAYMENTS_SIG'];
            $request_json = file_get_contents('php://input');
            $request_data = json_decode($request_json, true);
            ksort($request_data);
            $sorted_request_json = json_encode($request_data, JSON_UNESCAPED_SLASHES);
            if ($request_json !== false && !empty($request_json)) {
                $hmac = hash_hmac("sha512", $sorted_request_json, trim($this->nowpayments['ipn_secret']));
                if ($hmac == $recived_hmac) {
                    if ($request_data['payment_status'] == 'confirmed' || $request_data['payment_status'] == 'finished') {
                        if ($request_data['actually_paid'] == $request_data['pay_amount']) {
                            $out_trade_no = $request_data['order_id'];
                            $this->postPayment($out_trade_no);
                            return $response->withJson(['state' => 'success', 'msg' => 'پرداخت موفق']);
                        }
                    }
                } else {
                    $response->write('درخواست غیر مجاز, HMAC signature does not match');
                }
            } else {
                return $response->write('خطا: Error reading POST data');
            }
        } else {
            return $response->write('No HMAC signature sent. ,درخواست غیر مجاز');
        }

        return $response->write('درخواست غیر مجاز');
    }

    /**
     * @throws Exception
     */
    public static function getPurchaseHTML(): string
    {
        return View::getSmarty()->fetch('gateway/nowpayments.tpl');
    }

    public function getReturnHTML($request, $response, $args): ResponseInterface
    {
        $html = '';

        $html = <<<HTML
                <script>
                    setTimeout(function() {
                        location.href="/user/invoice";
                    },500)
                </script>
            HTML;

        return $response->write($html);
    }

}
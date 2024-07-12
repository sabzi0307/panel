<?php

declare(strict_types=1);

/**
 * Copyright (c) 2019.
 * Author:Alone88
 * Github:https://github.com/anhao
 */

namespace App\Services\Gateway;

use App\Models\Paylist;
use App\Models\Config;
use App\Services\Auth;
use App\Services\Exchange;
use App\Services\Gateway\PerfectMoney\PerfectMoneyNotify;
use App\Services\Gateway\PerfectMoney\PerfectMoneySubmit;
use App\Services\View;
use App\Utils\ResponseHelper;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use voku\helper\AntiXSS;

final class PerfectMoney extends Base
{
    protected array $perfectmoney = [];

    public function __construct()
    {
        $this->perfectmoney['apiurl'] = Config::obtain('perfectmoney_url');
        $this->perfectmoney['alter_pass_Phrase'] = Config::obtain('perfectmoney_alter_pass_phrase');
        $this->perfectmoney['payer_Account'] = Config::obtain('perfectmoney_payee_account');
        $this->perfectmoney['currency'] = Config::obtain('perfectmoney_currency');
        $this->perfectmoney['sign_type'] = strtoupper('MD5');
    }

    public static function _name(): string
    {
        return 'perfectmoney';
    }

    public static function _enable(): bool
    {
        return self::getActiveGateway('perfectmoney');
    }

    public static function _readableName(): string
    {
        return 'PerfectMoney';
    }

    public function purchase(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $antiXss = new AntiXSS();

        $price = $antiXss->xss_clean($request->getParam('price'));
        $invoice_id = $antiXss->xss_clean($request->getParam('invoice_id'));
        // EPay 特定参数
        $type = $antiXss->xss_clean($request->getParam('type'));

        if ($price <= 0) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'مقدار غیر مجاز',
            ]);
        }

        $user = Auth::getUser();
        $pl = new Paylist();

        $pl->userid = $user->id;
        $pl->total = $price;
        $pl->invoice_id = $invoice_id;
        $pl->gateway = self::_readableName();
        $pl->tradeno = self::generateGuid();
        $pl->gateway = self::_readableName();

        $pl->save();

        $exchange_amount = (new Exchange())->exchange((float) $price, 'IRR', Config::obtain('perfectmoney_currency'));
        $data = [
            'PAYEE_ACCOUNT' => Config::obtain('perfectmoney_payee_account'),
            'PAYEE_NAME' => $_ENV['appName'],
            'PAYMENT_AMOUNT' => $exchange_amount,
            'PAYMENT_UNITS' => Config::obtain('perfectmoney_currency'),
            'PAYMENT_ID' => $invoice_id,
            'STATUS_URL' => $_ENV['baseUrl'] . '/payment/notify/perfectmoney',
            'PAYMENT_URL' => $_ENV['baseUrl'] . '/user/payment/return/perfectmoney',
            'PAYMENT_URL_METHOD' => 'GET',
            'NOPAYMENT_URL' => $_ENV['baseUrl'] . '/user/payment/return/perfectmoney',
            'NOPAYMENT_URL_METHOD' => 'GET',
            'BAGGAGE_FIELDS' => 'TRADE_NO',
            'TRADE_NO' => $pl->tradeno,
            'SUGGESTED_MEMO' => "Invoice" . ' #' . $invoice_id,
            'SUGGESTED_MEMO_NOCHANGE' => 0,
        ];

        $alipaySubmit = new PerfectMoneySubmit($this->perfectmoney);
        $html_text = $alipaySubmit->buildRequestForm($data);

        return $response->write($html_text);
    }

    public function notify($request, $response, $args): ResponseInterface
    {
        $perfectmoneyNotify = new PerfectMoneyNotify($this->perfectmoney);
        $verify_result = $perfectmoneyNotify->verifyNotify();

        if ($verify_result) {
            $out_trade_no = $_GET['TRADE_NO'];

            $this->postPayment($out_trade_no);
            return $response->withJson(['state' => 'success', 'msg' => 'پرداخت موفق']);
        }

        return $response->write('درخواست غیر مجاز');
    }

    /**
     * @throws Exception
     */
    public static function getPurchaseHTML(): string
    {
        return View::getSmarty()->fetch('gateway/perfectmoney.tpl');
    }

    public function getReturnHTML($request, $response, $args): ResponseInterface
    {
        $batch = $_GET['PAYMENT_BATCH_NUM'];
        $money = $_GET['PAYMENT_AMOUNT'];
        $unit = $_GET['PAYMENT_UNITS'];
        $exchange_amount = (new Exchange())->exchange((float) $money, Config::obtain('perfectmoney_currency'), 'IRR');

        $html = '';
        $currency=ResponseHelper::translateCurrency(Config::obtain('system_currency'));
        if ($batch == 0) {
            $html = <<<HTML
                پرداخت موفقیت آمیز نبود.
                <script>
                    setTimeout(function() {
                        location.href="/user/invoice";
                    },500)
                </script>
            HTML;
        } else {
            $html = <<<HTML
                شما با موفقیت دوباره {$exchange_amount} {$currency} حساب خود را شارژ کردید.
                <script>
                    setTimeout(function() {
                        location.href="/user/invoice";
                    },500)
                </script>
            HTML;
        }

        return $response->write($html);
    }
}
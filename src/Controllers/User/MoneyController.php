<?php

declare(strict_types=1);

namespace App\Controllers\User;

use App\Controllers\BaseController;
use App\Models\GiftCard;
use App\Models\Paylist;
use App\Models\Config;
use App\Models\UserMoneyLog;
use App\Utils\Tools;
use DOMDocument;
use Exception;
use Http;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use voku\helper\AntiXSS;
use function time;

final class MoneyController extends BaseController
{
    /**
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $user = $this->user;
        $moneylogs = (new UserMoneyLog())->where('user_id', $user->id)->orderBy('id', 'desc')->get();

        foreach ($moneylogs as $moneylog) {
            $moneylog->create_time = Tools::toDateTime($moneylog->create_time);
        }

        $moneylog_count = $moneylogs->count();

        $configs = Config::getClass('billing');
        $perfectMoney = $configs['perfectmoney'];

        return $response->write(
            $this->view()
                ->assign('perfectMoney', $perfectMoney)
                ->assign('moneylogs', $moneylogs)
                ->assign('moneylog_count', $moneylog_count)
                ->fetch('user/money.tpl')
        );
    }

    public function applyGiftCard(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $giftcard_raw = $this->antiXss->xss_clean($request->getParam('giftcard'));
        $giftcard = (new GiftCard())->where('card', $giftcard_raw)->first();

        if ($giftcard === null || $giftcard->status !== 0) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'کارت هدیه نامعتبر است',
            ]);
        }

        $user = $this->user;

        if ($user->is_shadow_banned) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'کارت هدیه نامعتبر است',
            ]);
        }

        $giftcard->status = 1;
        $giftcard->use_time = time();
        $giftcard->use_user = $user->id;
        $giftcard->save();

        $money_before = $user->money;
        $user->money += $giftcard->balance;
        $user->save();

        (new UserMoneyLog())->add(
            $user->id,
            $money_before,
            (float) $user->money,
            $giftcard->balance,
            'شارژ کارت هدیه ' . $giftcard->card
        );

        return $response->withJson([
            'ret' => 1,
            'msg' => 'شارژ مجدد با موفقیت انجام شد',
        ]);
    }
    public function activatePerfectMoneyVoucher(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $antiXss = new AntiXSS();
        $ev_number = $antiXss->xss_clean($request->getParam('ev_number'));
        $ev_code = $antiXss->xss_clean($request->getParam('ev_code'));

        if(strlen($ev_number) !== 10){
            return $response->withJson([
                'ret' => 0,
                'msg' => 'کد وچر میبایست ۱۰ رقم باشد',
            ]);
        }
        if(strlen($ev_code) !== 16){
            return $response->withJson([
                'ret' => 0,
                'msg' => 'کد فعال ساز میبایست ۱۶ رقم باشد',
            ]);
        }

        $configs = Config::getClass('billing');
        $account_Id = $configs['perfectmoney_account_id'];
        $payer_Account = $configs['perfectmoney_payee_account'];
        $pass_Phrase = urlencode($configs['perfectmoney_pass_phrase']);

        $opts = array(
            'socket' => array(
                'bindto' => '0.0.0.0:0',
            )
        );

        $context = stream_context_create($opts);

        $voucher = Http::get("https://perfectmoney.is/acct/ev_activate.asp?AccountID=" . $account_Id . "&PassPhrase=" . $pass_Phrase . "&Payee_Account=" . $payer_Account . "&ev_number=" . $ev_number . "&ev_code=" . $ev_code)->body();

        if (strpos($voucher, 'Error') !== false){
            return $response->withJson([
                'ret' => 0,
                'msg' => 'کارت نامعتبر است',
            ]);
        }

        $dom = new DOMDocument();
        $dom->loadHTML($voucher);
        $element = $dom->getElementsByTagName("input");
        $amount = $element->item(1)->getAttribute('value');

        $user = $this->user;

        // if ($user->is_shadow_banned) {
        //     return $response->withJson([
        //         'ret' => 0,
        //         'msg' => 'کارت نامعتبر است',
        //     ]);
        // }

        $money_before = $user->money;
        $user->money += $amount;
        $user->save();

        $pl = new Paylist();
        $trade_no = Tools::genRandomChar();

        $pl->userid = $user->id;
        $pl->total = $amount;
        $pl->invoice_id = 0;
        $pl->tradeno = $trade_no;
        $pl->gateway = 'PerfectMoney';
        $pl->datetime = time();
        $pl->status = 1;

        $pl->save();

        (new UserMoneyLog())->add(
            $user->id,
            (float) $money_before,
            (float) $user->money,
            (float) $amount,
            ' شارژ وچر پرفکت مانی ' . $ev_number
        );

        return $response->withJson([
            'ret' => 1,
            'msg' => 'شارژ مجدد با موفقیت انجام شد',
        ]);
    }
}
<?php

declare(strict_types=1);

namespace App\Controllers\User;

use App\Controllers\BaseController;
use App\Models\Invoice;
use App\Models\Paylist;
use App\Models\UserMoneyLog;
use App\Services\Payment;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use voku\helper\AntiXSS;
use function json_decode;
use function time;

final class InvoiceController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'اقدام',
            'id' => 'شناسه صورتحساب',
            'order_id' => 'شماره سفارش',
            'price' => 'مبلغ صورتحساب',
            'status' => 'وضعیت صورتحساب',
            'create_time' => 'زمان ایجاد',
            'update_time' => 'زمان به روز رسانی',
            'pay_time' => 'زمان پرداخت',
        ],
    ];

    /**
     * @throws Exception
     */
    public function invoice(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('user/invoice/index.tpl')
        );
    }

    /**
     * @throws Exception
     */
    public function detail(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $antiXss = new AntiXSS();
        $id = $antiXss->xss_clean($args['id']);

        $invoice = Invoice::where('user_id', $this->user->id)->where('id', $id)->first();

        if ($invoice === null) {
            return $response->withRedirect('/user/invoice');
        }

        $paylist = [];

        if ($invoice->status === 'paid_gateway') {
            $paylist = Paylist::where('invoice_id', $invoice->id)->where('status', 1)->first();
        }

        $invoice->status_text = $invoice->status();
        $invoice->create_time = Tools::toDateTime($invoice->create_time);
        $invoice->update_time = Tools::toDateTime($invoice->update_time);
        $invoice->pay_time = Tools::toDateTime($invoice->pay_time);
        $invoice_content = json_decode($invoice->content);

        return $response->write(
            $this->view()
                ->assign('invoice', $invoice)
                ->assign('invoice_content', $invoice_content)
                ->assign('paylist', $paylist)
                ->assign('payments', Payment::getPaymentsEnabled())
                ->fetch('user/invoice/view.tpl')
        );
    }

    public function payBalance(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $antiXss = new AntiXSS();
        $invoice_id = $antiXss->xss_clean($request->getParam('invoice_id'));

        $invoice = Invoice::where("user_id", $this->user->id)->where("id", $invoice_id)->first();

        if ($invoice === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'هیچ صورت حسابی وجود ندارد',
            ]);
        }

        $user = $this->user;

        if ($user->money < $invoice->price) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'موجودی حساب کافی نیست',
            ]);
        }

        if ($user->money < $invoice->price) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'موجودی حساب کافی نیست',
            ]);
        }

        $money_before = $user->money;
        $user->money -= $invoice->price;
        $user->save();

        (new UserMoneyLog())->add(
            $user->id,
            (float) $money_before,
            (float) $user->money,
            -$invoice->price,
            'پرداخت صورت حساب #' . $invoice->id
        );

        $invoice->status = 'paid_balance';
        $invoice->update_time = time();
        $invoice->pay_time = time();
        $invoice->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'پرداخت موفق',
        ]);
    }

    public function ajax(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $invoices = Invoice::orderBy('id', 'desc')->where('user_id', $this->user->id)->get();

        foreach ($invoices as $invoice) {
            $invoice->op = '<a class="btn btn-blue" href="/user/invoice/' . $invoice->id . '/view">بررسی</a>';
            $invoice->status = $invoice->status();
            $invoice->create_time = Tools::toDateTime($invoice->create_time);
            $invoice->update_time = Tools::toDateTime($invoice->update_time);
            $invoice->pay_time = Tools::toDateTime($invoice->pay_time);
        }

        return $response->withJson([
            'invoices' => $invoices,
        ]);
    }
}

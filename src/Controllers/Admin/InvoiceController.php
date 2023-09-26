<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Invoice;
use App\Models\Order;
use App\Models\Paylist;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function in_array;
use function json_decode;
use function time;

final class InvoiceController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'اقدام',
            'id' => 'شناسه صورتحساب',
            'user_id' => 'کاربر منتسب',
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
    public function index(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('admin/invoice/index.tpl')
        );
    }

    /**
     * @throws Exception
     */
    public function detail(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $id = $args['id'];
        $invoice = Invoice::find($id);
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
                ->fetch('admin/invoice/view.tpl')
        );
    }

    public function markPaid(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $invoice_id = $args['id'];
        $invoice = Invoice::find($invoice_id);

        if (in_array($invoice->status, ['paid_gateway', 'paid_balance', 'paid_admin'])) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'نمی توان صورتحساب هایی را که قبلا پرداخت شده اند علامت گذاری کرد',
            ]);
        }

        $order = Order::find($invoice->order_id);

        if ($order->status === 'cancelled') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'سفارش مرتبط لغو شده است، علامت‌گذاری انجام نشد',
            ]);
        }

        $order->update_time = time();
        $order->status = 'pending_activation';
        $order->save();

        $invoice->update_time = time();
        $invoice->pay_time = time();
        $invoice->status = 'paid_admin';
        $invoice->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'صورتحساب با موفقیت به عنوان پرداخت شده علامت‌گذاری شد (مدیر) ',
        ]);
    }

    public function ajax(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $invoices = Invoice::orderBy('id', 'desc')->get();

        foreach ($invoices as $invoice) {
            $invoice->op = '<a class="btn btn-blue" href="/admin/invoice/' . $invoice->id . '/view">بررسی</a>';
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

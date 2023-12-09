<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Invoice;
use App\Models\Order;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function in_array;
use function json_decode;
use function time;

final class OrderController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'شرح',
            'id' => 'شماره سفارش',
            'user_id' => 'کاربر',
            'product_id' => 'شناسه سرویس',
            'product_type' => 'نوع سرویس',
            'product_name' => 'نام سرویس',
            'coupon' => 'کد تخفیف',
            'price' => 'قیمت',
            'status' => 'وضعیت',
            'create_time' => 'زمان ایجاد',
            'update_time' => 'زمان به روز رسانی',
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
                ->fetch('admin/order/index.tpl')
        );
    }

    /**
     * @throws Exception
     */
    public function detail(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $id = $args['id'];

        $order = (new Order())->find($id);
        $order->product_type_text = $order->productType();
        $order->status_text = $order->status();
        $order->create_time = Tools::toDateTime($order->create_time);
        $order->update_time = Tools::toDateTime($order->update_time);
        $order->content = json_decode($order->product_content);

        $invoice = (new Invoice())->where('order_id', $id)->first();
        $invoice->status = $invoice->status();
        $invoice->create_time = Tools::toDateTime($invoice->create_time);
        $invoice->update_time = Tools::toDateTime($invoice->update_time);
        $invoice->pay_time = Tools::toDateTime($invoice->pay_time);
        $invoice->content = json_decode($invoice->content);

        return $response->write(
            $this->view()
                ->assign('order', $order)
                ->assign('invoice', $invoice)
                ->fetch('admin/order/view.tpl')
        );
    }

    public function cancel(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $order_id = $args['id'];
        $order = (new Order())->find($order_id);

        if ($order->status === 'activated') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'سرویس فعال شده را نمی توان لغو کرد',
            ]);
        }

        $order->update_time = time();
        $order->status = 'cancelled';
        $order->save();

        $invoice = (new Invoice())->where('order_id', $order_id)->first();

        if ($invoice === null) {
            return $response->withJson([
                'ret' => 1,
                'msg' => 'سفارش با موفقیت لغو شد، اما وضعیت صورت‌حساب مرتبط غیرعادی است',
            ]);
        }

        $invoice->update_time = time();

        if (in_array($invoice->status, ['paid_gateway', 'paid_balance', 'paid_admin'])) {
            $invoice->status = 'cancelled';
            $invoice->save();

            return $response->withJson([
                'ret' => 1,
                'msg' => 'سفارش با موفقیت لغو شد، اما صورت‌حساب مربوطه قبلاً پرداخت شده است',
            ]);
        }

        $invoice->status = 'cancelled';
        $invoice->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'سفارش با موفقیت لغو شد',
        ]);
    }

    public function delete(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $order_id = $args['id'];
        (new Order())->find($order_id)->delete();
        (new Invoice())->where('order_id', $order_id)->first()->delete();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت حذف شد',
        ]);
    }

    public function ajax(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $orders = (new Order())->orderBy('id', 'desc')->get();

        foreach ($orders as $order) {
            $order->op = '<button type="button" class="btn btn-red" id="delete-order-' . $order->id . '"
             onclick="deleteOrder(' . $order->id . ')">حذف</button>';

            if ($order->status === 'pending_payment') {
                $order->op .= '
                <button type="button" class="btn btn-orange" id="cancel-order-' . $order->id . '"
                 onclick="cancelOrder(' . $order->id . ')">لغو</button>';
            }

            $order->op .= '
            <a class="btn btn-blue" href="/admin/order/' . $order->id . '/view">بررسی</a>';
            $order->product_type = $order->productType();
            $order->status = $order->status();
            $order->create_time = Tools::toDateTime($order->create_time);
            $order->update_time = Tools::toDateTime($order->update_time);
        }

        return $response->withJson([
            'orders' => $orders,
        ]);
    }
}

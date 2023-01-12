<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Invoice;
use App\Models\Order;
use App\Utils\Tools;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Request;
use Slim\Http\Response;

final class OrderController extends BaseController
{
    public static array $details = [
        'field' => [
            'op' => 'شرح',
            'id' => 'شماره سفارش',
            'user_id' => 'کاربر',
            'product_id' => 'شناسه سرویس',
            'product_type' => 'نوع سرویس',
            'product_name' => 'نام سرویس',
            'coupon' => 'کد تبلیغاتی',
            'price' => 'قیمت',
            'status' => 'وضعیت',
            'create_time' => 'زمان ایجاد',
            'update_time' => 'زمان به روز رسانی',
        ],
    ];

    public function index(Request $request, Response $response, array $args): ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->display('admin/order/index.tpl')
        );
    }

    public function detail(Request $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];

        $order = Order::find($id);
        $order->product_type = Tools::getOrderProductType($order);
        $order->status = Tools::getOrderStatus($order);
        $order->create_time = Tools::toDateTime($order->create_time);
        $order->update_time = Tools::toDateTime($order->update_time);

        $product_content = \json_decode($order->product_content, true);

        $invoice = Invoice::where('order_id', $id)->first();
        $invoice->status = Tools::getInvoiceStatus($invoice);
        $invoice->create_time = Tools::toDateTime($invoice->create_time);
        $invoice->update_time = Tools::toDateTime($invoice->update_time);
        $invoice->pay_time = Tools::toDateTime($invoice->pay_time);
        $invoice_content = \json_decode($invoice->content, true);

        return $response->write(
            $this->view()
                ->assign('order', $order)
                ->assign('invoice', $invoice)
                ->assign('product_content', $product_content)
                ->assign('invoice_content', $invoice_content)
                ->display('admin/order/view.tpl')
        );
    }

    public function cancel(Request $request, Response $response, array $args): ResponseInterface
    {
        $order_id = $args['id'];
        $order = Order::find($order_id);

        if ($order->status === 'activated') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'سرویس فعال شده را نمی توان لغو کرد',
            ]);
        }

        $order->update_time = \time();
        $order->status = 'cancelled';
        $order->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'یا موفقیت لغو شد',
        ]);
    }

    public function delete(Request $request, Response $response, array $args): ResponseInterface
    {
        $order_id = $args['id'];
        Order::find($order_id)->delete();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت حذف شد',
        ]);
    }

    public function ajax(Request $request, Response $response, array $args): ResponseInterface
    {
        $orders = Order::orderBy('id', 'desc')->get();

        foreach ($orders as $order) {
            $order->op = '<button type="button" class="btn btn-red" id="delete-order-' . $order->id . '" 
            onclick="deleteOrder(' . $order->id . ')">حذف</button>
            <button type="button" class="btn btn-orange" id="cancel-order-' . $order->id . '" 
            onclick="cancelOrder(' . $order->id . ')">کپی</button>
            <a class="btn btn-blue" href="/admin/order/' . $order->id . '/view">بررسی</a>';
            $order->product_type = Tools::getOrderProductType($order);
            $order->status = Tools::getOrderStatus($order);
            $order->create_time = Tools::toDateTime($order->create_time);
            $order->update_time = Tools::toDateTime($order->update_time);
        }

        return $response->withJson([
            'orders' => $orders,
        ]);
    }
}

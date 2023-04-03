<?php

declare(strict_types=1);

namespace App\Command;

use App\Models\Invoice;
use App\Models\Order;
use App\Models\User;
use App\Utils\Tools;
use DateTime;
use function count;
use function in_array;
use function json_decode;
use function time;

final class Cron extends Command
{
    public string $description = <<<EOL
├─=: php xcat Cron - Site timed task, every 5 minutes
EOL;

    public function boot(): void
    {
        ini_set('memory_limit', '-1');
        // 新商店系统相关
        // 获取等待支付的订单，检查账单支付状态
        $pending_payment_orders = Order::where('status', 'pending_payment')->get();

        foreach ($pending_payment_orders as $order) {
            // 检查账单支付状态
            $invoice = Invoice::where('order_id', $order->id)->first();

            if ($invoice === null) {
                continue;
            }
            // 标记订单为等待激活
            if (in_array($invoice->status, ['paid_gateway', 'paid_balance', 'paid_admin'])) {
                $order->status = 'pending_activation';
                $order->update_time = time();
                $order->save();
                echo "Flagged order #{$order->id} is waiting to be activated.\n";
                continue;
            }
            // Cancellation of unpaid orders and associated bills
            if ($order->create_time + 86400 < time()) {
                $order->status = 'cancelled';
                $order->update_time = time();
                $order->save();
                echo "unpaid order has been canceled #{$order->id}。\n";
                $invoice->status = 'cancelled';
                $invoice->update_time = time();
                $invoice->save();
                echo "Canceled unpaid bill #{$invoice->id}。\n";
            }
        }
        // Get users who use the new store system, and only update this part of users to avoid conflicts with the old system
        $users_new_shop = User::where('use_new_shop', 1)->get();

        foreach ($users_new_shop as $user) {
            $user_id = $user->id;
            // 获取用户账户等待激活的订单
            $pending_activation_orders = Order::where('user_id', $user_id)->where('status', 'pending_activation')->orderBy('id', 'asc')->get();
            // 获取用户账户已激活的订单，一个用户同时只能有一个已激活的订单
            $activated_order = Order::where('user_id', $user_id)->where('status', 'activated')->orderBy('id', 'asc')->first();
            // 如果用户账户中没有已激活的订单，且有等待激活的订单，则激活最早的等待激活订单
            if ($activated_order === null && count($pending_activation_orders) > 0) {
                $order = $pending_activation_orders[0];
                // 获取订单内容准备激活
                $content = json_decode($order->product_content);
                // 激活商品
                $user->u = 0;
                $user->d = 0;
                $user->last_day_t = 0;
                $user->transfer_enable = Tools::toGB($content->bandwidth);
                $user->class = $content->class;
                $old_expire_in = new DateTime();
                $old_class_expire = new DateTime();
                $user->expire_in = $old_expire_in->modify('+' . $content->time . ' days')->format('Y-m-d H:i:s');
                $user->class_expire = $old_class_expire->modify('+' . $content->class_time . ' days')->format('Y-m-d H:i:s');
                $user->node_group = $content->node_group;
                $user->node_speedlimit = $content->speed_limit;
                $user->node_iplimit = $content->ip_limit;
                $user->save();
                $order->status = 'activated';
                $order->update_time = time();
                $order->save();
                echo "Order #{$order->id} activated.\n";
                continue;
            }
            // If there is an activated order in the user's account, check whether it has expired
            if ($activated_order !== null) {
                $content = json_decode($activated_order->product_content);
                if ($activated_order->update_time + $content->time * 86400 < time()) {
                    $activated_order->status = 'expired';
                    $activated_order->update_time = time();
                    $activated_order->save();
                    echo "Order #{$activated_order->id} expired.\n";
                }
            }
        }
    }
}

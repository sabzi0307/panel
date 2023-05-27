<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\Ann;
use App\Models\DetectLog;
use App\Models\EmailQueue;
use App\Models\Invoice;
use App\Models\Node;
use App\Models\OnlineLog;
use App\Models\Order;
use App\Models\PasswordReset;
use App\Models\Paylist;
use App\Models\Setting;
use App\Models\StreamMedia;
use App\Models\TelegramSession;
use App\Models\User;
use App\Models\UserHourlyUsage;
use App\Models\UserSubscribeLog;
use App\Utils\Telegram;
use App\Utils\Tools;
use DateTime;
use Exception;
use Psr\Http\Client\ClientExceptionInterface;
use Telegram\Bot\Exceptions\TelegramSDKException;
use function array_map;
use function date;
use function in_array;
use function json_decode;
use function max;
use function str_replace;
use function strtotime;
use function time;
use const PHP_EOL;

final class CronJob
{
    public static function addTrafficLog(): void
    {
        $users = User::all();

        foreach ($users as $user) {
            $transfer_total = $user->transfer_total;
            $transfer_total_last = UserHourlyUsage::where('user_id', $user->id)->orderBy('id', 'desc')->first();

            if ($transfer_total_last === null) {
                $transfer_total_last = 0;
            } else {
                $transfer_total_last = $transfer_total_last->traffic;
            }

            $trafficlog = new UserHourlyUsage();
            $trafficlog->user_id = $user->id;
            $trafficlog->traffic = $transfer_total;
            $trafficlog->hourly_usage = $transfer_total - $transfer_total_last;
            $trafficlog->datetime = time();
            $trafficlog->save();
        }
    }

    public static function cleanDb(): void
    {
        UserSubscribeLog::where('request_time', '<', date('Y-m-d H:i:s', time() - 86400 * (int) $_ENV['subscribeLog_keep_days']))->delete();
        UserHourlyUsage::where('datetime', '<', time() - 86400 * (int) $_ENV['trafficLog_keep_days'])->delete();
        DetectLog::where('datetime', '<', time() - 86400 * 3)->delete();
        EmailQueue::where('time', '<', time() - 86400)->delete();
        PasswordReset::where('expire_time', '<', time() - 86400)->delete();
        OnlineLog::where('last_time', '<', time() - 86400)->delete();
        StreamMedia::where('created_at', '<', time() - 86400)->delete();
        TelegramSession::where('datetime', '<', time() - 900)->delete();

        echo date('Y-m-d H:i:s') . ' پاکسازی دیتابیس کامل شد' . PHP_EOL;
    }

    public static function cleanUser(): void
    {
        $freeUsers = User::where('class', 0)->get();

        foreach ($freeUsers as $user) {
            if (
                $_ENV['account_expire_delete_days'] >= 0 &&
                strtotime($user->expire_in) + $_ENV['account_expire_delete_days'] * 86400 < time() &&
                $user->money <= $_ENV['auto_clean_min_money']
            ) {
                $user->sendMail(
                    $_ENV['appName'] . '- حساب کاربری شما به دلیل انقضا حذف شده است',
                    'warn.tpl',
                    [
                        'text' => 'سلام، سیستم متوجه شد که اکانت شما منقضی شده است ' . $_ENV['account_expire_delete_days'] . ' اوه، حساب حذف شده است.',
                    ],
                    [],
                    true
                );
                $user->killUser();
                continue;
            }

            if (
                $_ENV['auto_clean_uncheck_days'] > 0 &&
                max(
                    $user->last_check_in_time,
                    strtotime($user->reg_date)
                ) + ($_ENV['auto_clean_uncheck_days'] * 86400) < time() &&
                $user->class === 0 &&
                $user->money <= $_ENV['auto_clean_min_money']
            ) {
                $user->sendMail(
                    $_ENV['appName'] . '-اکانت شما به دلیل عدم حضور حذف شده است',
                    'warn.tpl',
                    [
                        'text' => 'سلام، سیستم متوجه شد که اکانت شما  ' . $_ENV['auto_clean_uncheck_days'] . ' من چند روزی است که وارد سیستم نشده ام و اکانت حذف شده است.',
                    ],
                    [],
                    true
                );
                $user->killUser();
                continue;
            }

            if (
                $_ENV['auto_clean_unused_days'] > 0 &&
                max($user->t, strtotime($user->reg_date)) + ($_ENV['auto_clean_unused_days'] * 86400) < time() &&
                $user->class === 0 &&
                $user->money <= $_ENV['auto_clean_min_money']
            ) {
                $user->sendMail(
                    $_ENV['appName'] . '- حساب کاربری شما به دلیل عدم فعالیت حذف شده است',
                    'warn.tpl',
                    [
                        'text' => 'سلام، سیستم متوجه شد که اکانت شما  ' . $_ENV['auto_clean_unused_days'] . ' چند روزی است که استفاده نشده و اکانت حذف شده است.',
                    ],
                    [],
                    true
                );
                $user->killUser();
            }
        }

        echo date('Y-m-d H:i:s') . ' کاربران رایگان پاک شدند' . PHP_EOL;
    }

    /**
     * @throws TelegramSDKException
     */
    public static function detectNodeOffline(): void
    {
        $nodes = Node::where('type', 1)->get();
        $adminUsers = User::where('is_admin', '=', '1')->get();

        foreach ($nodes as $node) {
            if ($node->getNodeOnlineStatus() >= 0 && $node->online === 1) {
                continue;
            }

            if ($node->getNodeOnlineStatus() === -1 && $node->online === 1) {
                foreach ($adminUsers as $user) {
                    echo 'Send Node Offline Email to admin user: ' . $user->id . PHP_EOL;
                    $user->sendMail(
                        $_ENV['appName'] . '- هشدار سیستم',
                        'warn.tpl',
                        [
                            'text' => 'سلام مدیر، سیستم گره را کشف می کند ' . $node->name . ' خط قطع شده است، لطفا به موقع با آن برخورد کنید.',
                        ],
                        [],
                        false
                    );
                    $notice_text = str_replace(
                        '%node_name%',
                        $node->name,
                        Setting::obtain('telegram_node_offline_text')
                    );
                }

                if (Setting::obtain('telegram_node_offline')) {
                    Telegram::send($notice_text);
                }

                $node->online = 0;
                $node->save();

                continue;
            }

            if ($node->getNodeOnlineStatus() === 1 && $node->online === 0) {
                foreach ($adminUsers as $user) {
                    echo 'Send Node Online Email to admin user: ' . $user->id . PHP_EOL;
                    $user->sendMail(
                        $_ENV['appName'] . '-راهنمای سیستم',
                        'warn.tpl',
                        [
                            'text' => 'سلام مدیر، سیستم گره را کشف می کند ' . $node->name . ' بازگشت آنلاین',
                        ],
                        [],
                        false
                    );
                    $notice_text = str_replace(
                        '%node_name%',
                        $node->name,
                        Setting::obtain('telegram_node_online_text')
                    );
                }

                if (Setting::obtain('telegram_node_online')) {
                    Telegram::send($notice_text);
                }

                $node->online = 1;
                $node->save();
            }
        }
        echo date('Y-m-d H:i:s') . ' تشخیص آفلاین گره کامل شد' . PHP_EOL;
    }

    public static function expirePaidUserAccount(): void
    {
        $paidUsers = User::where('class', '>', 0)->get();

        foreach ($paidUsers as $user) {
            if (strtotime($user->class_expire) < time()) {
                $text = 'سلام، سیستم متوجه شد که سطح حساب شما منقضی شده است.';
                $reset_traffic = $_ENV['class_expire_reset_traffic'];

                if ($reset_traffic >= 0) {
                    $user->transfer_enable = Tools::toGB($reset_traffic);
                    $text .= 'ترافیک مجدد تنظیم شد' . $reset_traffic . 'GB';
                }

                $user->sendMail(
                    $_ENV['appName'] . '- سطح حساب شما منقضی شده است',
                    'warn.tpl',
                    [
                        'text' => $text,
                    ],
                    [],
                    true
                );

                $user->u = 0;
                $user->d = 0;
                $user->transfer_today = 0;
                $user->class = 0;
                $user->save();
            }
        }

        echo date('Y-m-d H:i:s') . ' شناسایی انقضای کاربر پرداخت شده تکمیل شد' . PHP_EOL;
    }

    // This shit should be removed but kept for compatibility reason, for now. User account should never expire.
    public static function expireFreeUserAccount(): void
    {
        $freeUsers = User::where('class', 0)->get();

        foreach ($freeUsers as $user) {
            if (strtotime($user->expire_in) < time() && ! $user->expire_notified) {
                $user->transfer_enable = 0;
                $user->u = 0;
                $user->d = 0;
                $user->transfer_today = 0;

                $user->sendMail(
                    $_ENV['appName'] . '- حساب شما منقضی شده است',
                    'warn.tpl',
                    [
                        'text' => 'سلام، سیستم متوجه شد که اکانت شما منقضی شده است.',
                    ],
                    [],
                    true
                );

                $user->expire_notified = true;
                $user->save();
            } elseif (strtotime($user->expire_in) > time() && $user->expire_notified) {
                $user->expire_notified = false;
                $user->save();
            }
        }

        echo date('Y-m-d H:i:s') . ' تشخیص انقضای کاربر رایگان تکمیل شد' . PHP_EOL;
    }

    public static function processEmailQueue(): void
    {
        //记录当前时间戳
        $timestamp = time();
        //邮件队列处理
        while (true) {
            if (time() - $timestamp > 299) {
                echo date('Y-m-d H:i:s') . 'زمان پردازش صف پیام به پایان رسیده است، نادیده گرفته شد' . PHP_EOL;
                break;
            }
            DB::beginTransaction();
            $email_queues_raw = DB::select('SELECT * FROM email_queue LIMIT 1 FOR UPDATE SKIP LOCKED');
            if (count($email_queues_raw) === 0) {
                DB::commit();
                break;
            }
            $email_queues = array_map(static function ($value) {
                return (array) $value;
            }, $email_queues_raw);
            $email_queue = $email_queues[0];
            echo 'ارسال ایمیل به ' . $email_queue['to_email'] . PHP_EOL;
            DB::delete('DELETE FROM email_queue WHERE id = ?', [$email_queue['id']]);
            if (Tools::isEmail($email_queue['to_email'])) {
                try {
                    Mail::send($email_queue['to_email'], $email_queue['subject'], $email_queue['template'], json_decode($email_queue['array']));
                } catch (Exception|ClientExceptionInterface $e) {
                    echo $e->getMessage();
                }
            } else {
                echo $email_queue['to_email'] . ' خطای قالب ایمیل، نادیده گرفته شد' . PHP_EOL;
            }
            DB::commit();
        }

        echo date('Y-m-d H:i:s') . ' پردازش صف ایمیل کامل شد' . PHP_EOL;
    }

    public static function processOrderActivation(): void
    {
        $users = User::all();

        foreach ($users as $user) {
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
                $user->transfer_today = 0;
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
                echo "سفارش #{$order->id} فعال شده است.\n";
                continue;
            }
            // 如果用户账户中有已激活的订单，则判断是否过期
            if ($activated_order !== null) {
                $content = json_decode($activated_order->product_content);
                if ($activated_order->update_time + $content->time * 86400 < time()) {
                    $activated_order->status = 'expired';
                    $activated_order->update_time = time();
                    $activated_order->save();
                    echo "سفارش #{$activated_order->id} منقضی شده است.\n";
                }
            }
        }

        echo date('Y-m-d H:i:s') . ' پردازش فعال سازی سفارش به پایان رسید' . PHP_EOL;
    }

    public static function processPendingOrder(): void
    {
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
                echo "سفارش #{$order->id} باعنوان در انتظار فعال‌سازی علامت‌گذاری شد.\n";
                continue;
            }
            // 取消超时未支付的订单和关联账单
            if ($order->create_time + 86400 < time()) {
                $order->status = 'cancelled';
                $order->update_time = time();
                $order->save();
                echo "سفارش #{$order->id} به دلیل وقفه لغو شد.\n";
                $invoice->status = 'cancelled';
                $invoice->update_time = time();
                $invoice->save();
                echo "صورتحساب اضافه کاری لغو شده #{$invoice->id}.\n";
            }
        }

        echo date('Y-m-d H:i:s') . ' منتظر پردازش سفارش هستیم' . PHP_EOL;
    }

    public static function resetNodeBandwidth(): void
    {
        Node::where('bandwidthlimit_resetday', date('d'))->update(['node_bandwidth' => 0]);

        echo date('Y-m-d H:i:s') . ' تنظیم مجدد ترافیک گره کامل شد' . PHP_EOL;
    }

    public static function resetTodayTraffic(): void
    {
        User::query()->update(['transfer_today' => 0]);

        echo date('Y-m-d H:i:s') . ' بازنشانی ترافیک روزانه کاربر تکمیل شد' . PHP_EOL;
    }

    public static function resetFreeUserTraffic(): void
    {
        $freeUsers = User::where('class', 0)->where('auto_reset_day', date('d'))->get();

        foreach ($freeUsers as $user) {
            $user->u = 0;
            $user->d = 0;
            $user->transfer_enable = $user->auto_reset_bandwidth * 1024 * 1024 * 1024;
            $user->save();

            $user->sendMail(
                $_ENV['appName'] . '-ترافیک رایگان شما مجدد تنظیم شده است',
                'warn.tpl',
                [
                    'text' => 'سلام، ترافیک رایگان شما به حالت اولیه بازنشانی شد' . $user->auto_reset_bandwidth . 'GB',
                ],
                [],
                true
            );
        }

        echo date('Y-m-d H:i:s') . ' بازنشانی جریان کاربر رایگان کامل شد' . PHP_EOL;
    }

    public static function sendDailyFinanceMail(): void
    {
        $today = strtotime('00:00:00');
        $paylists = Paylist::where('status', 1)->whereBetween('datetime', [strtotime('-1 day', $today), $today])->get();
        $text_html = '<table border=1><tr><td>مبلغ</td><td>شناسه کاربر</td><td>نام کاربری</td><td>زمان شارژ مجدد</td>';

        foreach ($paylists as $paylist) {
            $text_html .= '<tr>';
            $text_html .= '<td>' . $paylist->total . '</td>';
            $text_html .= '<td>' . $paylist->userid . '</td>';
            $text_html .= '<td>' . User::find($paylist->userid)->user_name . '</td>';
            $text_html .= '<td>' . Tools::toDateTime((int) $paylist->datetime) . '</td>';
            $text_html .= '</tr>';
        }

        $text_html .= '</table>';
        $text_html .= '<br>کل درآمد دیروز: ' . count($paylists) . '<br>کل درآمد دیروز: ' . $paylists->sum('total');
        $adminUser = User::where('is_admin', '=', '1')->get();

        foreach ($adminUser as $user) {
            echo 'Sending daily finance email to admin user: ' . $user->id . PHP_EOL;
            $user->sendMail(
                $_ENV['appName'] . '- مالی روزانه',
                'finance.tpl',
                [
                    'title' => 'مالی روزانه',
                    'text' => $text_html,
                ],
                []
            );
        }

        echo date('Y-m-d H:i:s') . ' مالی روزانه با موفقیت ارسال شد' . PHP_EOL;
    }

    public static function sendWeeklyFinanceMail(): void
    {
        $today = strtotime('00:00:00');
        $paylists = Paylist::where('status', 1)->whereBetween('datetime', [strtotime('-1 week', $today), $today])->get();

        $text_html = '<br>کل درآمد هفته گذشته：' . count($paylists) . '<br>کل درآمد هفته گذشته：' . $paylists->sum('total');
        $adminUser = User::where('is_admin', '=', '1')->get();

        foreach ($adminUser as $user) {
            echo 'Sending weekly finance email to admin user: ' . $user->id . PHP_EOL;
            $user->sendMail(
                $_ENV['appName'] . '- گزارش مالی هفتگی',
                'finance.tpl',
                [
                    'title' => 'هفته نامه مالی',
                    'text' => $text_html,
                ],
                []
            );
        }

        echo date('Y-m-d H:i:s') . ' گزارش مالی هفتگی با موفقیت ارسال شد' . PHP_EOL;
    }

    public static function sendMonthlyFinanceMail(): void
    {
        $today = strtotime('00:00:00');
        $paylists = Paylist::where('status', 1)->whereBetween('datetime', [strtotime('-1 month', $today), $today])->get();

        $text_html = '<br>کل درآمد ماه گذشته：' . count($paylists) . '<br>میزان درآمد ناخالص در ماه گذشته：' . $paylists->sum('total');
        $adminUser = User::where('is_admin', '=', '1')->get();

        foreach ($adminUser as $user) {
            echo 'Sending monthly finance email to admin user: ' . $user->id . PHP_EOL;
            $user->sendMail(
                $_ENV['appName'] . '- گزارش مالی ماهانه',
                'finance.tpl',
                [
                    'title' => 'گزارش مالی ماهانه',
                    'text' => $text_html,
                ],
                []
            );
        }

        echo date('Y-m-d H:i:s') . ' گزارش مالی ماهانه با موفقیت ارسال شد' . PHP_EOL;
    }

    public static function sendPaidUserUsageLimitNotification(): void
    {
        $paidUsers = User::where('class', '>', 0)->get();

        foreach ($paidUsers as $user) {
            $user_traffic_left = $user->transfer_enable - $user->u - $user->d;
            $under_limit = false;
            $unit_text = '';

            if (
                $_ENV['notify_limit_mode'] === 'per' &&
                $user_traffic_left / $user->transfer_enable * 100 < $_ENV['notify_limit_value']
            ) {
                $under_limit = true;
                $unit_text = '%';
            } elseif (
                $_ENV['notify_limit_mode'] === 'mb' &&
                Tools::flowToMB($user_traffic_left) < $_ENV['notify_limit_value']
            ) {
                $under_limit = true;
                $unit_text = 'MB';
            }

            if ($under_limit && ! $user->traffic_notified) {
                $result = $user->sendMail(
                    $_ENV['appName'] . '- ترافیک باقیمانده شما خیلی کم است',
                    'warn.tpl',
                    [
                        'text' => 'سلام، سیستم متوجه شد که ترافیک باقیمانده شما کمتر از ' . $_ENV['notify_limit_value'] . $unit_text . ' . ',
                    ],
                    [],
                    true
                );
                if ($result) {
                    $user->traffic_notified = true;
                    $user->save();
                }
            } elseif (! $under_limit && $user->traffic_notified) {
                $user->traffic_notified = false;
                $user->save();
            }
        }

        echo date('Y-m-d H:i:s') . ' یادآوری محدودیت استفاده از کاربر پرداخت شده تکمیل شد' . PHP_EOL;
    }

    public static function sendDailyTrafficReport(): void
    {
        $users = User::where('sendDailyMail', 1)->get();

        $ann_latest_raw = Ann::orderBy('date', 'desc')->first();

        if ($ann_latest_raw === null) {
            $ann_latest = '<br><br>';
        } else {
            $ann_latest = $ann_latest_raw->content . '<br><br>';
        }

        foreach ($users as $user) {
            $user->sendDailyNotification($ann_latest);
        }

        echo date('Y-m-d H:i:s') . ' ایمیل روزانه با موفقیت ارسال شد' . PHP_EOL;
    }

    /**
     * @throws TelegramSDKException
     */
    public static function sendTelegramDailyJob(): void
    {
        Telegram::send(Setting::obtain('telegram_daily_job_text'));

        echo date('Y-m-d H:i:s') . ' یادآوری روزانه تلگرام با موفقیت ارسال شد' . PHP_EOL;
    }

    /**
     * @throws TelegramSDKException
     */
    public static function sendTelegramDiary(): void
    {
        $analytics = new Analytics();

        Telegram::send(
            str_replace(
                [
                    '%getTodayCheckinUser%',
                    '%lastday_total%',
                ],
                [
                    $analytics->getTodayCheckinUser(),
                    $analytics->getTodayTrafficUsage(),
                ],
                Setting::obtain('telegram_diary_text')
            )
        );

        echo date('Y-m-d H:i:s') . ' گزارش عملکرد سامانه تلگرام با موفقیت ارسال شد' . PHP_EOL;
    }

    public static function updateNodeIp(): void
    {
        $nodes = Node::where('type', 1)->get();

        foreach ($nodes as $node) {
            $server = $node->server;
            if (! Tools::isIPv4($server) && ! Tools::isIPv6($server)) {
                $node->changeNodeIp($server);
                $node->save();
            }
        }

        echo date('Y-m-d H:i:s') . ' به روز رسانی IP گره تکمیل شد' . PHP_EOL;
    }
}

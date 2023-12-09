<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\Ann;
use App\Models\Config;
use App\Models\DetectLog;
use App\Models\EmailQueue;
use App\Models\Invoice;
use App\Models\Node;
use App\Models\OnlineLog;
use App\Models\Order;
use App\Models\Paylist;
use App\Models\SharedAccount;
use App\Models\SubscribeLog;
use App\Models\User;
use App\Models\UserHourlyUsage;
use App\Services\IM\Telegram;
use App\Utils\Tools;
use DateTime;
use Exception;
use GuzzleHttp\Exception\GuzzleException;
use Psr\Http\Client\ClientExceptionInterface;
use Telegram\Bot\Exceptions\TelegramSDKException;
use function array_map;
use function date;
use function in_array;
use function json_decode;
use function str_replace;
use function strtotime;
use function time;
use const PHP_EOL;

final class Cron
{
    public static function addTrafficLog(): void
    {
        $users = User::all();

        foreach ($users as $user) {
            $transfer_total = $user->transfer_total;
            $transfer_total_last = (new UserHourlyUsage())->where('user_id', $user->id)->orderBy('id', 'desc')->first();

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

        echo Tools::toDateTime(time()) . ' پردازش رکورد ترافیک به پایان رسید' . PHP_EOL;
    }

    public static function cleanDb(): void
    {
        (new SubscribeLog())->where(
            'request_time',
            '<',
            time() - 86400 * Config::obtain('subscribe_log_retention_days')
        )->delete();
        (new UserHourlyUsage())->where('datetime', '<', time() - 86400 * Config::obtain('traffic_log_retention_days'))->delete();
        (new DetectLog())->where('datetime', '<', time() - 86400 * 3)->delete();
        (new EmailQueue())->where('time', '<', time() - 86400)->delete();
        (new OnlineLog())->where('last_time', '<', time() - 86400)->delete();
        (new SharedAccount())->where('update_time', '<', time() - 1200)->delete();

        echo Tools::toDateTime(time()) . ' پاکسازی دیتابیس کامل شد' . PHP_EOL;
    }

    public static function detectInactiveUser(): void
    {
        $checkin_days = Config::obtain('detect_inactive_user_checkin_days');
        $login_days = Config::obtain('detect_inactive_user_login_days');
        $use_days = Config::obtain('detect_inactive_user_use_days');

        (new User())->where('is_admin', 0)
            ->where('is_inactive', 0)
            ->where('last_check_in_time', '<', time() - 86400 * $checkin_days)
            ->where('last_login_time', '<', time() - 86400 * $login_days)
            ->where('last_use_time', '<', time() - 86400 * $use_days)
            ->update(['is_inactive' => 1]);

        (new User())->where('is_admin', 0)
            ->where('is_inactive', 1)
            ->where('last_check_in_time', '>', time() - 86400 * $checkin_days)
            ->where('last_login_time', '>', time() - 86400 * $login_days)
            ->where('last_use_time', '>', time() - 86400 * $use_days)
            ->update(['is_inactive' => 0]);

        echo Tools::toDateTime(time()) .
            ' شناسایی شد ' . (new User())->where('is_inactive', 1)->count() . ' اکانت ها غیرفعال هستند' . PHP_EOL;
    }

    public static function detectNodeOffline(): void
    {
        $nodes = (new Node())->where('type', 1)->get();

        foreach ($nodes as $node) {
            if ($node->getNodeOnlineStatus() >= 0 && $node->online === 1) {
                continue;
            }

            if ($node->getNodeOnlineStatus() === -1 && $node->online === 1) {
                echo 'Send Node Offline Email to admin users' . PHP_EOL;

                try {
                    Notification::notifyAdmin(
                        $_ENV['appName'] . '-هشدار سیستم',
                        'هشدار سیستم ' . $node->name . ' خط قطع شده لطفا به موقع با آن برخورد کنید.'
                    );
                } catch (GuzzleException|ClientExceptionInterface|TelegramSDKException $e) {
                    echo $e->getMessage() . PHP_EOL;
                }

                if (Config::obtain('telegram_node_offline')) {
                    $notice_text = str_replace(
                        '%node_name%',
                        $node->name,
                        Config::obtain('telegram_node_offline_text')
                    );

                    try {
                        (new Telegram())->send(0, $notice_text);
                    } catch (TelegramSDKException $e) {
                        echo $e->getMessage();
                    }
                }

                $node->online = 0;
                $node->save();

                continue;
            }

            if ($node->getNodeOnlineStatus() === 1 && $node->online === 0) {
                echo 'Send Node Online Email to admin user' . PHP_EOL;

                try {
                    Notification::notifyAdmin(
                        $_ENV['appName'] . '-راهنمایی سیستم',
                        'سلام مدیر، سیستم گره را کشف می کند ' . $node->name . ' بازگشت آنلاین'
                    );
                } catch (GuzzleException|ClientExceptionInterface|TelegramSDKException $e) {
                    echo $e->getMessage() . PHP_EOL;
                }

                if (Config::obtain('telegram_node_online')) {
                    $notice_text = str_replace(
                        '%node_name%',
                        $node->name,
                        Config::obtain('telegram_node_online_text')
                    );

                    try {
                        (new Telegram())->send(0, $notice_text);
                    } catch (TelegramSDKException $e) {
                        echo $e->getMessage();
                    }
                }

                $node->online = 1;
                $node->save();
            }
        }

        echo Tools::toDateTime(time()) . ' تشخیص آفلاین گره کامل شد' . PHP_EOL;
    }

    public static function expirePaidUserAccount(): void
    {
        $paidUsers = (new User())->where('class', '>', 0)->get();

        foreach ($paidUsers as $user) {
            if (strtotime($user->class_expire) < time()) {
                $text = 'سلام، سطح حساب شما منقضی شده است.';
                $reset_traffic = $_ENV['class_expire_reset_traffic'];

                if ($reset_traffic >= 0) {
                    $user->transfer_enable = Tools::toGB($reset_traffic);
                    $text .= 'ریست مجدد ترافیک به' . $reset_traffic . 'GB。';
                }

                try {
                    Notification::notifyUser($user, $_ENV['appName'] . '-سطح حساب شما منقضی شده است', $text);
                } catch (GuzzleException|ClientExceptionInterface|TelegramSDKException $e) {
                    echo $e->getMessage() . PHP_EOL;
                }

                $user->u = 0;
                $user->d = 0;
                $user->transfer_today = 0;
                $user->class = 0;
                $user->save();
            }
        }

        echo Tools::toDateTime(time()) . ' تشخیص انقضای کاربر پولی تکمیل شد' . PHP_EOL;
    }

    public static function processEmailQueue(): void
    {
        //记录当前时间戳
        $timestamp = time();
        //邮件队列处理
        while (true) {
            if (time() - $timestamp > 299) {
                echo Tools::toDateTime(time()) . 'زمان پردازش صف پیام به پایان رسید، نادیده گرفته شد' . PHP_EOL;
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
                    Mail::send(
                        $email_queue['to_email'],
                        $email_queue['subject'],
                        $email_queue['template'],
                        json_decode($email_queue['array'])
                    );
                } catch (Exception|ClientExceptionInterface $e) {
                    echo $e->getMessage();
                }
            } else {
                echo $email_queue['to_email'] . ' خطای قالب ایمیل، نادیده گرفته شد' . PHP_EOL;
            }

            DB::commit();
        }

        echo Tools::toDateTime(time()) . ' پردازش صف ایمیل کامل شد' . PHP_EOL;
    }

    public static function processTabpOrderActivation(): void
    {
        $users = User::all();

        foreach ($users as $user) {
            $user_id = $user->id;
            // 获取用户账户等待激活的TABP订单
            $pending_activation_orders = (new Order())->where('user_id', $user_id)
                ->where('status', 'pending_activation')
                ->where('product_type', 'tabp')
                ->orderBy('id')
                ->get();
            // 获取用户账户已激活的TABP订单，一个用户同时只能有一个已激活的TABP订单
            $activated_order = (new Order())->where('user_id', $user_id)
                ->where('status', 'activated')
                ->where('product_type', 'tabp')
                ->orderBy('id')
                ->first();
            // 如果用户账户中没有已激活的TABP订单，且有等待激活的TABP订单，则激活最早的等待激活TABP订单
            if ($activated_order === null && count($pending_activation_orders) > 0) {
                $order = $pending_activation_orders[0];
                // 获取TABP订单内容准备激活
                $content = json_decode($order->product_content);
                // 激活TABP
                $user->u = 0;
                $user->d = 0;
                $user->transfer_today = 0;
                $user->transfer_enable = Tools::toGB($content->bandwidth);
                $user->class = $content->class;
                $old_class_expire = new DateTime();
                $user->class_expire = $old_class_expire
                    ->modify('+' . $content->class_time . ' days')->format('Y-m-d H:i:s');
                $user->node_group = $content->node_group;
                $user->node_speedlimit = $content->speed_limit;
                $user->node_iplimit = $content->ip_limit;
                $user->save();
                $order->status = 'activated';
                $order->update_time = time();
                $order->save();
                echo "سفارش TABP #{$order->id} فعال شده است.\n";
                continue;
            }
            // 如果用户账户中有已激活的TABP订单，则判断是否过期
            if ($activated_order !== null) {
                $content = json_decode($activated_order->product_content);

                if ($activated_order->update_time + $content->time * 86400 < time()) {
                    $activated_order->status = 'expired';
                    $activated_order->update_time = time();
                    $activated_order->save();
                    echo "سفارش TABP #{$activated_order->id} منقضی شده است.\n";
                }
            }
        }

        echo Tools::toDateTime(time()) . ' پردازش فعال‌سازی سفارش TABP تکمیل شد' . PHP_EOL;
    }

    public static function processBandwidthOrderActivation(): void
    {
        $users = User::all();

        foreach ($users as $user) {
            $user_id = $user->id;
            // 获取用户账户等待激活的流量包订单
            $order = (new Order())->where('user_id', $user_id)
                ->where('status', 'pending_activation')
                ->where('product_type', 'bandwidth')
                ->orderBy('id')
                ->first();

            if ($order !== null) {
                // 获取流量包订单内容准备激活
                $content = json_decode($order->product_content);
                // 激活流量包
                $user->transfer_enable += Tools::toGB($content->bandwidth);
                $user->save();
                $order->status = 'activated';
                $order->update_time = time();
                $order->save();
                echo "سفارش بسته ترافیکی #{$order->id} فعال شده است.\n";
            }
        }

        echo Tools::toDateTime(time()) . ' پردازش فعال‌سازی سفارش بسته ترافیک تکمیل شد' . PHP_EOL;
    }

    /**
     * @throws Exception
     */
    public static function processTimeOrderActivation(): void
    {
        $users = User::all();

        foreach ($users as $user) {
            $user_id = $user->id;
            // 获取用户账户等待激活的时间包订单
            $order = (new Order())->where('user_id', $user_id)
                ->where('status', 'pending_activation')
                ->where('product_type', 'time')
                ->orderBy('id')
                ->first();

            if ($order !== null) {
                $content = json_decode($order->product_content);
                // 跳过当前账户等级不等于时间包等级的非免费用户订单
                if ($user->class !== (int) $content->class && $user->class > 0) {
                    continue;
                }
                // 激活时间包
                $user->class = $content->class;
                $old_class_expire = new DateTime($user->class_expire);
                $user->class_expire = $old_class_expire
                    ->modify('+' . $content->class_time . ' days')->format('Y-m-d H:i:s');
                $user->node_group = $content->node_group;
                $user->node_speedlimit = $content->speed_limit;
                $user->node_iplimit = $content->ip_limit;
                $user->save();
                $order->status = 'activated';
                $order->update_time = time();
                $order->save();
                echo "سفارش بسته زمانی #{$order->id} فعال شده است.\n";
            }
        }

        echo Tools::toDateTime(time()) . ' پردازش فعال‌سازی سفارش بسته زمانی کامل شد' . PHP_EOL;
    }

    public static function processPendingOrder(): void
    {
        $pending_payment_orders = (new Order())->where('status', 'pending_payment')->get();

        foreach ($pending_payment_orders as $order) {
            // 检查账单支付状态
            $invoice = (new Invoice())->where('order_id', $order->id)->first();

            if ($invoice === null) {
                continue;
            }
            // 标记订单为等待激活
            if (in_array($invoice->status, ['paid_gateway', 'paid_balance', 'paid_admin'])) {
                $order->status = 'pending_activation';
                $order->update_time = time();
                $order->save();
                echo "سفارش #{$order->id} را به عنوان در انتظار فعال سازی علامت گذاری کرد.\n";
                continue;
            }
            // 取消超时未支付的订单和关联账单
            if ($order->create_time + 86400 < time()) {
                $order->status = 'cancelled';
                $order->update_time = time();
                $order->save();
                echo "سفارش #{$order->id}  لغو شد.\n";
                $invoice->status = 'cancelled';
                $invoice->update_time = time();
                $invoice->save();
                echo "صورت حساب #{$invoice->id} لفو شد.\n";
            }
        }

        echo Tools::toDateTime(time()) . ' در انتظار پردازش سفارش' . PHP_EOL;
    }

    public static function resetNodeBandwidth(): void
    {
        (new Node())->where('bandwidthlimit_resetday', date('d'))->update(['node_bandwidth' => 0]);

        echo Tools::toDateTime(time()) . ' بازنشانی ترافیک گره کامل شد' . PHP_EOL;
    }

    public static function resetTodayTraffic(): void
    {
        User::query()->update(['transfer_today' => 0]);

        echo Tools::toDateTime(time()) . ' بازنشانی ترافیک روزانه کاربر تکمیل شد' . PHP_EOL;
    }

    public static function resetFreeUserTraffic(): void
    {
        $freeUsers = (new User())->where('class', 0)->where('auto_reset_day', date('d'))->get();

        foreach ($freeUsers as $user) {
            try {
                Notification::notifyUser(
                    $user,
                    $_ENV['appName'] . '-اعلان بازنشانی ترافیک رایگان',
                    'سلام، ترافیک رایگان شما به حالت اولیه ریست شد' . $user->auto_reset_bandwidth . 'GB。'
                );
            } catch (GuzzleException|ClientExceptionInterface|TelegramSDKException $e) {
                echo $e->getMessage() . PHP_EOL;
            }

            $user->u = 0;
            $user->d = 0;
            $user->transfer_enable = $user->auto_reset_bandwidth * 1024 * 1024 * 1024;
            $user->save();
        }

        echo Tools::toDateTime(time()) . ' ریست ترافیک رایگان کاربر تکمیل شد' . PHP_EOL;
    }

    public static function sendDailyFinanceMail(): void
    {
        $today = strtotime('00:00:00');
        $paylists = (new Paylist())->where('status', 1)->whereBetween('datetime', [strtotime('-1 day', $today), $today])->get();
        $text_html = '<table border=1><tr><td>مقدار</td><td>شناسه کاربر</td><td>نام کاربری</td><td>زمان شارژ مجدد</td>';

        foreach ($paylists as $paylist) {
            $text_html .= '<tr>';
            $text_html .= '<td>' . $paylist->total . '</td>';
            $text_html .= '<td>' . $paylist->userid . '</td>';
            $text_html .= '<td>' . (new User())->find($paylist->userid)->user_name . '</td>';
            $text_html .= '<td>' . Tools::toDateTime((int) $paylist->datetime) . '</td>';
            $text_html .= '</tr>';
        }

        $text_html .= '</table>';
        $text_html .= '<br>کل درآمد دیروز：' . count($paylists) . '<br>کل درآمد دیروز：' . $paylists->sum('total');
        echo 'Sending daily finance email to admin user' . PHP_EOL;

        try {
            Notification::notifyAdmin(
                '财务日报',
                $text_html,
                'finance.tpl'
            );
        } catch (GuzzleException|ClientExceptionInterface|TelegramSDKException $e) {
            echo $e->getMessage() . PHP_EOL;
        }

        echo Tools::toDateTime(time()) . ' مالی روزانه با موفقیت ارسال شد' . PHP_EOL;
    }

    public static function sendWeeklyFinanceMail(): void
    {
        $today = strtotime('00:00:00');
        $paylists = (new Paylist())->where('status', 1)
            ->whereBetween('datetime', [strtotime('-1 week', $today), $today])
            ->get();

        $text_html = '<br>کل درآمد هفته گذشته：' . count($paylists) . '<br>کل درآمد هفته گذشته：' . $paylists->sum('total');
        echo 'Sending weekly finance email to admin user' . PHP_EOL;

        try {
            Notification::notifyAdmin(
                'هفته نامه مالی',
                $text_html,
                'finance.tpl'
            );
        } catch (GuzzleException|ClientExceptionInterface|TelegramSDKException $e) {
            echo $e->getMessage() . PHP_EOL;
        }

        echo Tools::toDateTime(time()) . ' گزارش مالی هفتگی با موفقیت ارسال شد' . PHP_EOL;
    }

    public static function sendMonthlyFinanceMail(): void
    {
        $today = strtotime('00:00:00');
        $paylists = (new Paylist())->where('status', 1)
            ->whereBetween('datetime', [strtotime('-1 month', $today), $today])
            ->get();

        $text_html = '<br>کل درآمد ماه گذشته: ' . count($paylists) . '<br>مقدار کل درآمد در ماه گذشته：' . $paylists->sum('total');
        echo 'Sending monthly finance email to admin user' . PHP_EOL;

        try {
            Notification::notifyAdmin(
                'گزارش مالی ماهانه',
                $text_html,
                'finance.tpl'
            );
        } catch (GuzzleException|ClientExceptionInterface|TelegramSDKException $e) {
            echo $e->getMessage() . PHP_EOL;
        }

        echo Tools::toDateTime(time()) . ' گزارش مالی ماهانه با موفقیت ارسال شد' . PHP_EOL;
    }

    public static function sendPaidUserUsageLimitNotification(): void
    {
        $paidUsers = (new User())->where('class', '>', 0)->get();

        foreach ($paidUsers as $user) {
            $user_traffic_left = $user->transfer_enable - $user->u - $user->d;
            $under_limit = false;
            $unit_text = '';

            if ($_ENV['notify_limit_mode'] === 'per' &&
                $user_traffic_left / $user->transfer_enable * 100 < $_ENV['notify_limit_value']
            ) {
                $under_limit = true;
                $unit_text = '%';
            } elseif ($_ENV['notify_limit_mode'] === 'mb' &&
                Tools::flowToMB($user_traffic_left) < $_ENV['notify_limit_value']
            ) {
                $under_limit = true;
                $unit_text = 'MB';
            }

            if ($under_limit && ! $user->traffic_notified) {
                try {
                    Notification::notifyUser(
                        $user,
                        $_ENV['appName'] . '-ترافیک باقیمانده شما بسیار کم است',
                        'سلام، ترافیک باقیمانده شما کمتر از ' . $_ENV['notify_limit_value'] . $unit_text . ' 。',
                    );

                    $user->traffic_notified = true;
                } catch (GuzzleException|ClientExceptionInterface|TelegramSDKException $e) {
                    $user->traffic_notified = false;
                    echo $e->getMessage() . PHP_EOL;
                }

                $user->save();
            } elseif (! $under_limit && $user->traffic_notified) {
                $user->traffic_notified = false;
                $user->save();
            }
        }

        echo Tools::toDateTime(time()) . ' یادآوری محدودیت استفاده از کاربر پرداخت شده تکمیل شد' . PHP_EOL;
    }

    public static function sendDailyTrafficReport(): void
    {
        $users = (new User())->whereIn('daily_mail_enable', [1, 2])->get();
        $ann_latest_raw = (new Ann())->orderBy('date', 'desc')->first();

        if ($ann_latest_raw === null) {
            $ann_latest = '<br><br>';
        } else {
            $ann_latest = $ann_latest_raw->content . '<br><br>';
        }

        foreach ($users as $user) {
            $user->sendDailyNotification($ann_latest);
        }

        echo Tools::toDateTime(time()) . ' گزارش ترافیک روزانه با موفقیت ارسال شد' . PHP_EOL;
    }

    /**
     * @throws TelegramSDKException
     */
    public static function sendTelegramDailyJob(): void
    {
        (new Telegram())->send(0, Config::obtain('telegram_daily_job_text'));

        echo Tools::toDateTime(time()) . ' یادآوری روزانه تلگرام با موفقیت ارسال شد' . PHP_EOL;
    }

    /**
     * @throws TelegramSDKException
     */
    public static function sendTelegramDiary(): void
    {
        (new Telegram())->send(
            0,
            str_replace(
                [
                    '%getTodayCheckinUser%',
                    '%lastday_total%',
                ],
                [
                    Analytics::getTodayCheckinUser(),
                    Analytics::getTodayTrafficUsage(),
                ],
                Config::obtain('telegram_diary_text')
            )
        );

        echo Tools::toDateTime(time()) . ' گزارش عملکرد سامانه تلگرام با موفقیت ارسال شد' . PHP_EOL;
    }

    public static function updateNodeIp(): void
    {
        $nodes = (new Node())->where('type', 1)->get();

        foreach ($nodes as $node) {
            $node->updateNodeIp();
            $node->save();
        }

        echo Tools::toDateTime(time()) . ' به روز رسانی IP گره تکمیل شد' . PHP_EOL;
    }
}

<?php

declare(strict_types=1);

namespace App\Command;

use App\Models\Ann;
use App\Models\DetectBanLog;
use App\Models\DetectLog;
use App\Models\EmailQueue;
use App\Models\EmailVerify;
use App\Models\Node;
use App\Models\OnlineLog;
use App\Models\PasswordReset;
use App\Models\Setting;
use App\Models\StreamMedia;
use App\Models\TelegramSession;
use App\Models\User;
use App\Models\UserHourlyUsage;
use App\Models\UserSubscribeLog;
use App\Services\Analytics;
use App\Utils\Telegram;
use App\Utils\Tools;
use Exception;
use function count;
use function max;
use function strtotime;
use function time;

final class Job extends Command
{
    public string $description = <<<EOL
├─=: php xcat Job [options]
│ ├─ DailyJob                - daily tasks, daily
│ ├─ UserJob                 - User account-related tasks, per hour
EOL;

    public function boot(): void
    {
        if (count($this->argv) === 2) {
            echo $this->description;
        } else {
            $methodName = $this->argv[2];
            if (method_exists($this, $methodName)) {
                $this->$methodName();
            } else {
                echo 'method does not exist.' . PHP_EOL;
            }
        }
    }

    /**
     * 每日任务
     */
    public function DailyJob(): void
    {
        ini_set('memory_limit', '-1');

        // ------- 重置节点流量
        Node::where('bandwidthlimit_resetday', date('d'))->update(['node_bandwidth' => 0]);
        // ------- 重置节点流量

        // ------- 清理各表记录
        UserSubscribeLog::where('request_time', '<', date('Y-m-d H:i:s', time() - 86400 * (int) $_ENV['subscribeLog_keep_days']))->delete();
        UserHourlyUsage::where('datetime', '<', time() - 86400 * (int) $_ENV['trafficLog_keep_days'])->delete();
        DetectLog::where('datetime', '<', time() - 86400 * 3)->delete();
        EmailVerify::where('expire_in', '<', time() - 86400)->delete();
        EmailQueue::where('time', '<', time() - 86400)->delete();
        PasswordReset::where('expire_time', '<', time() - 86400)->delete();
        OnlineLog::where('last_time', '<', time() - 86400)->delete();
        StreamMedia::where('created_at', '<', time() - 86400)->delete();
        TelegramSession::where('datetime', '<', time() - 900)->delete();
        // ------- 清理各表记录

        // ------- 用户每日流量报告
        $users = User::all();
        $ann_latest_raw = Ann::orderBy('date', 'desc')->first();

        // 判断是否有公告
        if ($ann_latest_raw === null) {
            $ann_latest = '<br><br>';
        } else {
            $ann_latest = $ann_latest_raw->content . '<br><br>';
        }

        $lastday_total = 0;

        foreach ($users as $user) {
            // 将用户日流量加到统计中
            $lastday_total += $user->u + $user->d - $user->last_day_t;
            $user->sendDailyNotification($ann_latest);
            // 覆盖用户 last_day_t 值，为下一个周期的流量重置做准备
            $user->last_day_t = $user->u + $user->d;
            $user->save();
        }
        // ------- 用户每日流量报告

        // ------- 免费用户流量重置
        foreach ($users as $user) {
            if ($user->class > 0) {
                continue;
            }

            if (date('d') === $user->auto_reset_day) {
                $user->u = 0;
                $user->d = 0;
                $user->last_day_t = 0;
                $user->transfer_enable = $user->auto_reset_bandwidth * 1024 * 1024 * 1024;
                $user->save();

                try {
                    $user->sendMail(
                        $_ENV['appName'] . '-ترافیک رایگان شما دوباره تنظیم شد',
                        'news/warn.tpl',
                        [
                            'text' => 'سلام، ترافیک رایگان شما به حجم اولیه ریست شد' . $user->auto_reset_bandwidth . 'GB',
                        ],
                        [],
                        true
                    );
                } catch (Exception $e) {
                    echo $e->getMessage();
                }
            }
        }
        // ------- 免费用户流量重置

        // ------- 发送系统运行状况通知
        $sts = new Analytics();
        if (Setting::obtain('telegram_diary')) {
            try {
                Telegram::send(
                    str_replace(
                        [
                            '%getTodayCheckinUser%',
                            '%lastday_total%',
                        ],
                        [
                            $sts->getTodayCheckinUser(),
                            Tools::flowAutoShow($lastday_total),
                        ],
                        Setting::obtain('telegram_diary_text')
                    )
                );
            } catch (Exception $e) {
                echo $e->getMessage();
            }
        }
        // ------- 发送系统运行状况通知

        // ------- 发送每日任务运行报告
        if (Setting::obtain('telegram_daily_job')) {
            try {
                Telegram::send(Setting::obtain('telegram_daily_job_text'));
            } catch (Exception $e) {
                echo $e->getMessage();
            }
        }
        // ------- 发送每日系统运行报告
    }

    /**
     * 用户账户相关任务，每小时
     */
    public function UserJob(): void
    {
        $users = User::all();
        foreach ($users as $user) {
            //流量记录
            if ($_ENV['trafficLog']) {
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

            if (strtotime($user->expire_in) < time() && ! $user->expire_notified) {
                $user->transfer_enable = 0;
                $user->u = 0;
                $user->d = 0;
                $user->last_day_t = 0;

                $user->sendMail(
                    $_ENV['appName'] . '-حساب کاربری شما منقضی شده است',
                    'news/warn.tpl',
                    [
                        'text' => 'سلام، متاسفانه جساب کاربری شما منقضی شده است.',
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
            //余量不足检测
            if ($_ENV['notify_limit_mode'] !== false) {
                $user_traffic_left = $user->transfer_enable - $user->u - $user->d;
                $under_limit = false;
                $unit_text = '';

                if ($user->transfer_enable !== 0 && $user->class !== 0) {
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
                }

                if ($under_limit && ! $user->traffic_notified) {
                    $result = $user->sendMail(
                        $_ENV['appName'] . '-ترافیک باقیمانده شما بسیار کم است',
                        'news/warn.tpl',
                        [
                            'text' => 'ترافیک باقیمانده شما کمتر از حد مجاز می باشد ' . $_ENV['notify_limit_value'] . $unit_text . ' 。',
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

            if (
                $_ENV['account_expire_delete_days'] >= 0 &&
                strtotime($user->expire_in) + $_ENV['account_expire_delete_days'] * 86400 < time() &&
                $user->money <= $_ENV['auto_clean_min_money']
            ) {
                $user->sendMail(
                    $_ENV['appName'] . '-حساب کاربری شما حذف شده است',
                    'news/warn.tpl',
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
                    $_ENV['appName'] . '-حساب کاربری شما حذف شده است',
                    'news/warn.tpl',
                    [
                        'text' => 'سلام، سیستم متوجه شد که اکانت شما ' . $_ENV['auto_clean_uncheck_days'] . ' چند روزی است که وارد سیستم نشده اید و حساب کاربری حذف شده است.',
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
                    $_ENV['appName'] . '-حساب کاربری شما حذف شده است',
                    'news/warn.tpl',
                    [
                        'text' => 'سلام، سیستم متوجه شد که اکانت شما ' . $_ENV['auto_clean_unused_days'] . ' چند روزی است که استفاده نشده و اکانت حذف شده است.',
                    ],
                    [],
                    true
                );
                $user->killUser();
                continue;
            }

            if (
                $user->class !== 0 &&
                strtotime($user->class_expire) < time() &&
                strtotime($user->class_expire) > 1420041600
            ) {
                $text = 'سلام، سیستم متوجه شد که سطح حساب شما منقضی شده است.';
                $reset_traffic = $_ENV['class_expire_reset_traffic'];
                if ($reset_traffic >= 0) {
                    $user->transfer_enable = Tools::toGB($reset_traffic);
                    $user->u = 0;
                    $user->d = 0;
                    $user->last_day_t = 0;
                    $text .= 'میزان ترافیک تنظیم شده جدید' . $reset_traffic . 'GB';
                }
                $user->sendMail(
                    $_ENV['appName'] . '-سطح حساب شما منقضی شده است',
                    'news/warn.tpl',
                    [
                        'text' => $text,
                    ],
                    [],
                    true
                );
                $user->class = 0;
            }
            // 审计封禁解封
            if ($user->is_banned === 1) {
                $logs = DetectBanLog::where('user_id', $user->id)->orderBy('id', 'desc')->first();
                if ($logs !== null && ($logs->end_time + $logs->ban_time * 60) <= time()) {
                    $user->is_banned = 0;
                }
            }

            $user->save();
        }
    }
}

<?php

declare(strict_types=1);

namespace App\Command;

use App\Models\Ann;
use App\Models\Bought;
use App\Models\DetectBanLog;
use App\Models\DetectLog;
use App\Models\EmailQueue;
use App\Models\EmailVerify;
use App\Models\Node;
use App\Models\OnlineLog;
use App\Models\PasswordReset;
use App\Models\Setting;
use App\Models\Shop;
use App\Models\StreamMedia;
use App\Models\TelegramSession;
use App\Models\User;
use App\Models\UserHourlyUsage;
use App\Models\UserSubscribeLog;
use App\Services\Analytics;
use App\Services\DB;
use App\Services\Mail;
use App\Utils\Telegram;
use App\Utils\Tools;
use Exception;
use Psr\Http\Client\ClientExceptionInterface;
use Telegram\Bot\Exceptions\TelegramSDKException;
use function count;
use function in_array;
use function json_decode;
use function max;
use function strtotime;
use function time;

final class Job extends Command
{
    public string $description = <<<EOL
├─=: php xcat Job [options]
│ ├─ DailyJob                - daily tasks, daily
│ ├─ CheckJob                - Check tasks, every minute
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
        EmailVerify::where('expire_in', '<', time() - 86400 * 3)->delete();
        EmailQueue::where('time', '<', time() - 86400 * 3)->delete();
        PasswordReset::where('expire_time', '<', time() - 86400 * 3)->delete();
        OnlineLog::where('last_time', '<', time() - 86400 * 30)->delete();
        StreamMedia::where('created_at', '<', time() - 86400 * 3)->delete();
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

        // ------- 付费用户流量重置
        // 取消已下架的商品不支持重置的限制，因为目前没有库存限制
        $shopid = Shop::where('content->reset', '<>', 0)->where('content->reset_value', '<>', 0)->where('content->reset_exp', '<>', 0)->pluck('id')->toArray();
        // 用 UserID 分组倒序取最新一条包含周期重置商品的购买记录
        $boughts = Bought::whereIn('shopid', $shopid)->orderBy('id', 'desc')->groupBy('userid')->get();
        $bought_users = [];

        foreach ($boughts as $bought) {
            /** @var Bought $bought */
            $user = $bought->user();

            if ($user === null) {
                continue;
            }
            // 跳过使用新商店系统的用户
            if ($user->use_new_shop === 1) {
                continue;
            }

            $shop = $bought->shop();

            if ($shop === null) {
                $bought->delete();
                continue;
            }

            $bought_users[] = $bought->userid;

            if ($bought->valid() && $bought->usedDays() % $shop->reset() === 0 && $bought->usedDays() !== 0) {
                echo 'traffic reset-' . $user->id . "\n";
                $user->transfer_enable = Tools::toGB($shop->resetValue());
                $user->u = 0;
                $user->d = 0;
                $user->last_day_t = 0;
                $user->save();
                $user->sendMail(
                    $_ENV['appName'] . '- ترافیک شما تنظیم مجدد شده است',
                    'news/warn.tpl',
                    [
                        'text' => 'سلام با توجه درخواست شما به شناسه ::' . $bought->id . '，میزان ترافیک شما تغییر کرد.' . $shop->resetValue() . 'GB',
                    ],
                    [],
                    true
                );
            }
        }
        // ------- 付费用户流量重置

        // ------- 免费用户流量重置
        foreach ($users as $user) {
            if (in_array($user->id, $bought_users)) {
                continue;
            }
            // 跳过使用新商店系统的用户
            if ($user->use_new_shop === 1) {
                continue;
            }

            if (date('d') === $user->auto_reset_day) {
                $user->u = 0;
                $user->d = 0;
                $user->last_day_t = 0;
                $user->transfer_enable = $user->auto_reset_bandwidth * 1024 * 1024 * 1024;
                $user->save();
                $user->sendMail(
                    $_ENV['appName'] . '-ترافیک رایگان شما دوباره تنظیم شد',
                    'news/warn.tpl',
                    [
                        'text' => 'سلام، ترافیک رایگان شما به حجم اولیه ریست شد' . $user->auto_reset_bandwidth . 'GB',
                    ],
                    [],
                    true
                );
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
     * 检查任务，每分钟
     *
     * @throws TelegramSDKException
     * @throws ClientExceptionInterface
     */
    public function CheckJob(): void
    {
        //记录当前时间戳
        $timestatmp = time();
        //邮件队列处理
        while (true) {
            if (time() - $timestatmp > 59) {
                echo 'Message queue processing timed out, skipped' . PHP_EOL;
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
            echo 'send email to ' . $email_queue['to_email'] . PHP_EOL;
            DB::delete('DELETE FROM email_queue WHERE id = ?', [$email_queue['id']]);
            if (Tools::isEmail($email_queue['to_email'])) {
                try {
                    Mail::send($email_queue['to_email'], $email_queue['subject'], $email_queue['template'], json_decode($email_queue['array']));
                } catch (Exception $e) {
                    echo $e->getMessage();
                }
            } else {
                echo $email_queue['to_email'] . ' Email format error, skipped' . PHP_EOL;
            }
            DB::commit();
        }
        //节点掉线检测
        if ($_ENV['enable_detect_offline'] === true) {
            echo 'Node down detection starts' . PHP_EOL;
            $adminUser = User::where('is_admin', '=', '1')->get();
            $nodes = Node::all();
            foreach ($nodes as $node) {
                $notice_text = '';
                if ($node->isNodeOnline() === false && $node->online === true) {
                    if ($_ENV['useScFtqq'] === true) {
                        $ScFtqq_SCKEY = $_ENV['ScFtqq_SCKEY'];
                        $text = 'Hello administrator, the system discovers the node ' . $node->name . ' The line is disconnected, please deal with it in time.';
                        $postdata = http_build_query(
                            [
                                'title' => $_ENV['appName'] . '-Node is down',
                                'desp' => $text,
                            ]
                        );
                        $opts = [
                            'http' => [
                                'method' => 'POST',
                                'header' => 'Content-type: application/x-www-form-urlencoded',
                                'content' => $postdata,
                            ],
                        ];
                        $context = stream_context_create($opts);
                        file_get_contents('https://sctapi.ftqq.com/' . $ScFtqq_SCKEY . '.send', false, $context);
                    }

                    foreach ($adminUser as $user) {
                        echo 'Send offline mail to user: ' . $user->id . PHP_EOL;
                        $user->sendMail(
                            $_ENV['appName'] . '-هشدار سیستم',
                            'news/warn.tpl',
                            [
                                'text' => 'Hello administrator, the system discovers the node ' . $node->name . ' The line is disconnected, please deal with it in time.',
                            ],
                            [],
                            true
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

                    $node->online = false;
                    $node->save();
                } elseif ($node->isNodeOnline() === true && $node->online === false) {
                    if ($_ENV['useScFtqq'] === true) {
                        $ScFtqq_SCKEY = $_ENV['ScFtqq_SCKEY'];
                        $text = 'Hello administrator, the system discovers the node ' . $node->name . ' back online.';
                        $postdata = http_build_query(
                            [
                                'title' => $_ENV['appName'] . '-The node is back online',
                                'desp' => $text,
                            ]
                        );

                        $opts = [
                            'http' => [
                                'method' => 'POST',
                                'header' => 'Content-type: application/x-www-form-urlencoded',
                                'content' => $postdata,
                            ],
                        ];
                        $context = stream_context_create($opts);
                        file_get_contents('https://sctapi.ftqq.com/' . $ScFtqq_SCKEY . '.send', false, $context);
                    }

                    foreach ($adminUser as $user) {
                        echo 'Send offline mail to user: ' . $user->id . PHP_EOL;
                        $user->sendMail(
                            $_ENV['appName'] . '-system hint',
                            'news/warn.tpl',
                            [
                                'text' => 'Hello administrator, the system discovers the node ' . $node->name . ' back online.',
                            ],
                            [],
                            true
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

                    $node->online = true;
                    $node->save();
                }
            }
            echo 'Node disconnection detection ends' . PHP_EOL;
        }

        //更新节点 IP，每分钟
        $nodes = Node::get();
        foreach ($nodes as $node) {
            /** @var Node $node */
            $server = $node->server;
            if (! Tools::isIPv4($server) && $node->changeNodeIp($server)) {
                $node->save();
            }
        }
    }

    /**
     * 用户账户相关任务，每小时
     */
    public function UserJob(): void
    {
        $users = User::all();
        foreach ($users as $user) {
            //流量记录
            if ($_ENV['trafficLog'] === true) {
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

            if (strtotime($user->expire_in) < time() && $user->expire_notified === false) {
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
            } elseif (strtotime($user->expire_in) > time() && $user->expire_notified === true) {
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

                if ($under_limit === true && $user->traffic_notified === false) {
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
                } elseif ($under_limit === false && $user->traffic_notified === true) {
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

        //自动续费
        $boughts = Bought::where('renew', '<', time() + 60)->where('renew', '<>', 0)->get();
        foreach ($boughts as $bought) {
            /** @var Bought $bought */
            $user = $bought->user();

            if ($user === null) {
                continue;
            }
            // 跳过使用新商店系统的用户
            if ($user->use_new_shop === 1) {
                continue;
            }

            $shop = $bought->shop();

            if ($shop === null) {
                $bought->delete();
                $user->sendMail(
                    $_ENV['appName'] . '-تمدید ناموفق بود',
                    'news/warn.tpl',
                    [
                        'text' => 'با سلام وقتی سیستم به صورت خودکار سرویس را برای شما تمدید می کند مشخص می شود که سرویس از چرخه فروش خارج شده است برای ادامه استفاده عادی توصیه می شود برای خرید سرویس جدید وارد پنل کاربری شوید. .',
                    ],
                    [],
                    true
                );
                $bought->is_notified = true;
                $bought->save();
                continue;
            }

            if ($user->money >= $shop->price) {
                $user->money -= $shop->price;
                $user->save();
                $shop->buy($user, 1);
                $bought->renew = 0;
                $bought->save();

                $bought_new = new Bought();
                $bought_new->userid = $user->id;
                $bought_new->shopid = $shop->id;
                $bought_new->datetime = time();
                $bought_new->renew = time() + $shop->auto_renew * 86400;
                $bought_new->price = $shop->price;
                $bought_new->coupon = '';
                $bought_new->save();

                $user->sendMail(
                    $_ENV['appName'] . '-تمدید با موفقیت انجام شد',
                    'news/warn.tpl',
                    [
                        'text' => 'سلام سیستم به صورت خودکار برای شما تمدید شد نام سرویس：' . $shop->name . ',مقدار:' . $shop->price . ' تومان',
                    ],
                    [],
                    true
                );

                $bought->is_notified = true;
                $bought->save();
            } elseif ($bought->is_notified === false) {
                $user->sendMail(
                    $_ENV['appName'] . '-تمدید ناموفق بود',
                    'news/warn.tpl',
                    [
                        'text' => 'سلام سیستم به طور خودکار نام سرویس را برای شما تمدید می کند：' . $shop->name . ',مقدار:' . $shop->price . ' وقتی متوجه شدید که موجودی شما کافی نیست، لطفاً به موقع شارژ کنید. پس از شارژ مجدد، لطفا کمی صبر کنید تا سیستم به طور خودکار برای شما تمدید شود.',
                    ],
                    [],
                    true
                );
                $bought->is_notified = true;
                $bought->save();
            }
        }
    }
}

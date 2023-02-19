<?php

declare(strict_types=1);

namespace App\Utils\Telegram\Callbacks;

use App\Controllers\LinkController;
use App\Controllers\SubController;
use App\Models\InviteCode;
use App\Models\Ip;
use App\Models\LoginIp;
use App\Models\Node;
use App\Models\Payback;
use App\Models\Setting;
use App\Models\UserSubscribeLog;
use App\Services\Config;
use App\Utils\QQWry;
use App\Utils\Telegram\Reply;
use App\Utils\Telegram\TelegramTools;
use App\Utils\Tools;

final class Callback
{
    /**
     * Bot
     */
    private $bot;

    /**
     * 触发用户
     */
    private $User;

    /**
     * 触发用户TG信息
     */
    private $triggerUser;

    /**
     * 回调
     */
    private $Callback;

    /**
     * 回调数据内容
     */
    private $CallbackData;

    /**
     * 消息会话 ID
     */
    private $ChatID;

    /**
     * 触发源信息 ID
     */
    private $MessageID;

    /**
     * 源消息是否可编辑
     */
    private $AllowEditMessage;
    public function __construct(\Telegram\Bot\Api $bot, \Telegram\Bot\Objects\CallbackQuery $Callback)
    {
        $this->bot = $bot;
        $this->triggerUser = [
            'id' => $Callback->getFrom()->getId(),
            'name' => $Callback->getFrom()->getFirstName() . ' ' . $Callback->getFrom()->getLastName(),
            'username' => $Callback->getFrom()->getUsername(),
        ];
        $this->User = TelegramTools::getUser($this->triggerUser['id']);
        $this->ChatID = $Callback->getMessage()->getChat()->getId();
        $this->Callback = $Callback;
        $this->MessageID = $Callback->getMessage()->getMessageId();
        $this->CallbackData = $Callback->getData();
        $this->AllowEditMessage = \time() < $Callback->getMessage()->getDate() + 172800;

        if ($this->ChatID < 0 && Setting::obtain('telegram_group_quiet') === true) {
            // 群组中不回应
            return;
        }
        switch (true) {
            case strpos($this->CallbackData, 'user.') === 0:
                // 用户相关
                $this->userCallback();
                break;
            default:
                //游客回调数据处理
                $this->guestCallback();
                break;
        }
    }

    /**
     * 游客的回复
     *
     * @return array
     */
    public static function getGuestIndexKeyboard()
    {
        $Keyboard = [
            [
                [
                    'text' => 'توضیحات سرویس',
                    'callback_data' => 'general.pricing',
                ],
                [
                    'text' => 'شرایط استفاده از خدمات',
                    'callback_data' => 'general.terms',
                ],
            ],
        ];
        $text = 'سلام ، منوی BOT در زیر آمده است：' . PHP_EOL . PHP_EOL . 'کاربران این سایت لطفا برای انجام عملیات اتصال تلگرام به پنل کاربر مراجعه کنند。';
        return [
            'text' => $text,
            'keyboard' => $Keyboard,
        ];
    }

    /**
     * 响应回调查询 | 默认已添加 chat_id 和 message_id
     *
     * @param array $sendMessage
     */
    public function replyWithMessage(array $sendMessage): void
    {
        $sendMessage = array_merge(
            [
                'chat_id' => $this->ChatID,
                'message_id' => $this->MessageID,
            ],
            $sendMessage
        );
        if ($this->AllowEditMessage) {
            TelegramTools::sendPost('editMessageText', $sendMessage);
        } else {
            $this->bot->sendMessage($sendMessage);
        }
    }

    /**
     * 响应回调查询 | 默认已添加 callback_query_id
     *
     * <code>
     * [
     *  'text'       => '',
     *  'show_alert' => false
     * ]
     * </code>
     *
     * @param array $sendMessage
     */
    public function answerCallbackQuery(array $sendMessage): void
    {
        $sendMessage = array_merge(
            [
                'callback_query_id' => $this->Callback->getId(),
                'show_alert' => false,
            ],
            $sendMessage
        );
        TelegramTools::sendPost('answerCallbackQuery', $sendMessage);
    }

    /**
     * 回调数据处理
     */
    public function guestCallback(): void
    {
        $CallbackDataExplode = explode('|', $this->CallbackData);
        switch ($CallbackDataExplode[0]) {
            case 'general.pricing':
                // 产品介绍
                $sendMessage = [
                    'text' => Setting::obtain('telegram_general_pricing'),
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => self::getGuestIndexKeyboard()['keyboard'],
                        ]
                    ),
                ];
                break;
            case 'general.terms':
                // 服务条款
                $sendMessage = [
                    'text' => Setting::obtain('telegram_general_terms'),
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => self::getGuestIndexKeyboard()['keyboard'],
                        ]
                    ),
                ];
                break;
            default:
                // 主菜单
                $temp = self::getGuestIndexKeyboard();
                $sendMessage = [
                    'text' => $temp['text'],
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => $temp['keyboard'],
                        ]
                    ),
                ];
                break;
        }
        $this->replyWithMessage($sendMessage);
    }

    public static function getUserIndexKeyboard($user)
    {
        $checkin = (! $user->isAbleToCheckin() ? 'وارد شدن' : 'چک کردن');
        $Keyboard = [
            [
                [
                    'text' => 'پنل کاربر',
                    'callback_data' => 'user.center',
                ],
                [
                    'text' => 'ویرایش اطلاعات',
                    'callback_data' => 'user.edit',
                ],
            ],
            [
                [
                    'text' => 'مرکز اشتراک',
                    'callback_data' => 'user.subscribe',
                ],
                [
                    'text' => 'طرح را به اشتراک بگذارید',
                    'callback_data' => 'user.invite',
                ],
            ],
            [
                [
                    'text' => $checkin,
                    'callback_data' => 'user.checkin.' . $user->telegram_id,
                ],
            ],
        ];
        $text = Reply::getUserTitle($user);
        $text .= PHP_EOL . PHP_EOL;
        $text .= Reply::getUserInfo($user);
        $text .= PHP_EOL;
        $text .= 'زمان تنظیم مجدد ترافیک：' . $user->validUseLoop();
        if (Setting::obtain('telegram_show_group_link')) {
            $Keyboard[] = [
                [
                    'text' => 'به گروه کاربری بپیوندید',
                    'url' => Setting::obtain('telegram_group_link'),
                ],
            ];
        }
        return [
            'text' => $text,
            'keyboard' => $Keyboard,
        ];
    }

    /**
     * 用户相关回调数据处理
     */
    public function userCallback()
    {
        if ($this->User === null) {
            if ($this->ChatID < 0) {
                // 群组内提示
                return $this->answerCallbackQuery([
                    'text' => 'سلام، شما حسابی را متصل نکرده اید و نمی توانید عملیات انجام دهید。',
                    'show_alert' => true,
                ]);
            }
            return $this->guestCallback();
        }
        $CallbackDataExplode = explode('|', $this->CallbackData);
        $Operate = explode('.', $CallbackDataExplode[0]);
        $op_1 = $Operate[1];
        switch ($op_1) {
            case 'edit':
                // 资料编辑
                $this->userEdit();
                break;
            case 'subscribe':
                // 订阅中心
                $this->userSubscribe();
                break;
            case 'invite':
                // 分享计划
                $this->userInvite();
                break;
            case 'checkin':
                // 签到
                if ((int) $Operate[2] !== $this->triggerUser['id']) {
                    $this->answerCallbackQuery([
                        'text' => 'سلام، شما نمی توانید حساب های دیگران را اداره کنید.',
                        'show_alert' => true,
                    ]);
                    return;
                }
                $this->userCheckin();
                break;
            case 'center':
                // 用户中心
                $this->userCenter();
                break;
            default:
                // 用户首页
                $temp = self::getUserIndexKeyboard($this->User);
                $this->replyWithMessage([
                    'text' => $temp['text'],
                    'parse_mode' => 'HTML',
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => $temp['keyboard'],
                        ]
                    ),
                ]);
                return;
        }
    }

    public function getUserCenterKeyboard()
    {
        $text = Reply::getUserTitle($this->User);
        $text .= PHP_EOL . PHP_EOL;
        $text .= Reply::getUserTrafficInfo($this->User);
        $keyboard = [
            [
                [
                    'text' => 'سابقه ثبت نام',
                    'callback_data' => 'user.center.login_log',
                ],
                [
                    'text' => 'سابقه استفاده',
                    'callback_data' => 'user.center.usage_log',
                ],
            ],
            [
                [
                    'text' => 'سابقه تخفیف',
                    'callback_data' => 'user.center.rebate_log',
                ],
                [
                    'text' => 'سابقه اشتراک',
                    'callback_data' => 'user.center.subscribe_log',
                ],
            ],
            [
                [
                    'text' => 'بازگشت به منوی اصلی',
                    'callback_data' => 'user.index',
                ],
            ],
        ];
        return [
            'text' => $text,
            'keyboard' => $keyboard,
        ];
    }

    /**
     * 用户中心
     */
    public function userCenter(): void
    {
        $back = [
            [
                [
                    'text' => 'بازگشت به منوی اصلی',
                    'callback_data' => 'user.index',
                ],
                [
                    'text' => 'بازگشت به صفحه قبل',
                    'callback_data' => 'user.center',
                ],
            ],
        ];
        $CallbackDataExplode = explode('|', $this->CallbackData);
        $Operate = explode('.', $CallbackDataExplode[0]);
        $OpEnd = end($Operate);
        switch ($OpEnd) {
            case 'login_log':
                // سابقه ثبت نام
                $iplocation = new QQWry();
                $total = LoginIp::where('userid', '=', $this->User->id)->where('type', '=', 0)->orderBy('datetime', 'desc')->take(10)->get();
                $text = '<strong>موارد زیر 10 آخرین IP ورود به سیستم و مکان های جغرافیایی شما هستند：</strong>' . PHP_EOL;
                $text .= PHP_EOL;

                foreach ($total as $single) {
                    $location = $iplocation->getlocation($single->ip);
                    $text .= $single->ip . ' - ' . iconv('gbk', 'utf-8//IGNORE', $location['country'] . $location['area']) . PHP_EOL;
                }

                $text .= PHP_EOL . '<strong>توجه: موقعیت جغرافیایی بر اساس پایگاه داده IP تخمین زده می شود که ممکن است با مکان واقعی مطابقت نداشته باشد و فقط برای مرجع است.</strong>' . PHP_EOL;

                $sendMessage = [
                    'text' => $text,
                    'disable_web_page_preview' => false,
                    'parse_mode' => 'HTML',
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => $back,
                        ]
                    ),
                ];
                break;
            case 'usage_log':
                // 使用记录
                $iplocation = new QQWry();
                $total = Ip::where('datetime', '>=', \time() - 300)->where('userid', '=', $this->User->id)->get();
                $text = '<strong>در زیر IP و موقعیت جغرافیایی استفاده از 5 دقیقه آخر شما آمده است：</strong>' . PHP_EOL;
                $text .= PHP_EOL;

                foreach ($total as $single) {
                    $single->ip = Tools::getRealIp($single->ip);
                    $is_node = Node::where('node_ip', $single->ip)->first();
                    if ($is_node) {
                        continue;
                    }
                    $location = $iplocation->getlocation($single->ip);
                    $text .= $single->ip . ' - ' . iconv('gbk', 'utf-8//IGNORE', $location['country'] . $location['area']) . PHP_EOL;
                }

                $text .= PHP_EOL . '<strong>توجه: موقعیت جغرافیایی بر اساس پایگاه داده IP تخمین زده می شود که ممکن است با مکان واقعی مطابقت نداشته باشد و فقط برای مرجع است.</strong>' . PHP_EOL;

                $sendMessage = [
                    'text' => $text,
                    'disable_web_page_preview' => false,
                    'parse_mode' => 'HTML',
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => $back,
                        ]
                    ),
                ];
                break;
            case 'rebate_log':
                // 返利记录
                $paybacks = Payback::where('ref_by', $this->User->id)->orderBy('datetime', 'desc')->take(10)->get();
                $temp = [];
                foreach ($paybacks as $payback) {
                    $temp[] = '<code>#' . $payback->id . '：' . ($payback->user() !== null ? $payback->user()->user_name : 'از سیستم خارج شده است') . '：' . $payback->ref_get . ' 元</code>';
                }
                $text = '<strong>موارد زیر آخرین 10 سابقه تخفیف شما هستند：</strong>';
                $text .= PHP_EOL . PHP_EOL;
                $text .= implode(PHP_EOL, $temp);
                $sendMessage = [
                    'text' => $text,
                    'disable_web_page_preview' => false,
                    'parse_mode' => 'HTML',
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => $back,
                        ]
                    ),
                ];
                break;
            case 'subscribe_log':
                // 订阅记录
                $iplocation = new QQWry();
                $logs = UserSubscribeLog::orderBy('id', 'desc')->where('user_id', $this->User->id)->take(10)->get();
                $temp = [];
                foreach ($logs as $log) {
                    $location = $iplocation->getlocation($log->request_ip);
                    $temp[] = '<code>' . $log->request_time . ' وجود دارد [' . $log->request_ip . '] ' . iconv('gbk', 'utf-8//IGNORE', $location['country'] . $location['area']) . ' بازدید کرده است ' . $log->subscribe_type . ' اشتراک، ابونمان</code>';
                }
                $text = '<strong>در اینجا 10 سابقه آخرین اشتراک شما آمده است：</strong>';
                $text .= PHP_EOL . PHP_EOL;
                $text .= implode(PHP_EOL . PHP_EOL, $temp);
                $sendMessage = [
                    'text' => $text,
                    'disable_web_page_preview' => false,
                    'parse_mode' => 'HTML',
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => $back,
                        ]
                    ),
                ];
                break;
            default:
                $temp = $this->getUserCenterKeyboard();
                $sendMessage = [
                    'text' => $temp['text'],
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => $temp['keyboard'],
                        ]
                    ),
                ];
                break;
        }
        $this->replyWithMessage($sendMessage);
        return;
    }

    public function getUserEditKeyboard()
    {
        $text = Reply::getUserTitle($this->User);
        $keyboard = [
            [
                [
                    'text' => 'بازنشانی لینک اشتراک',
                    'callback_data' => 'user.edit.update_link',
                ],
                [
                    'text' => 'رمز عبور پیوند را بازنشانی کنید',
                    'callback_data' => 'user.edit.update_passwd',
                ],
            ],
            [
                [
                    'text' => 'تغییر روش رمزگذاری',
                    'callback_data' => 'user.edit.encrypt',
                ],
                [
                    'text' => 'دریافت پستی روزانه',
                    'callback_data' => 'user.edit.sendemail',
                ],
            ],
            [
                [
                    'text' => 'حساب لغو پیوند',
                    'callback_data' => 'user.edit.unbind',
                ],
                [
                    'text' => 'رفع انسداد گروه',
                    'callback_data' => 'user.edit.unban',
                ],
            ],
            [
                [
                    'text' => 'بازگشت به منوی اصلی',
                    'callback_data' => 'user.index',
                ],
            ],
        ];
        return [
            'text' => $text,
            'keyboard' => $keyboard,
        ];
    }

    /**
     * 用户编辑
     */
    public function userEdit()
    {
        if ($this->ChatID < 0) {
            return $this->answerCallbackQuery([
                'text' => 'این عمل را نمی توان در یک گروه انجام داد.',
                'show_alert' => true,
            ]);
        }
        $back = [
            [
                [
                    'text' => 'بازگشت به منوی اصلی',
                    'callback_data' => 'user.index',
                ],
                [
                    'text' => 'بازگشت به صفحه قبل',
                    'callback_data' => 'user.edit',
                ],
            ],
        ];
        $CallbackDataExplode = explode('|', $this->CallbackData);
        $Operate = explode('.', $CallbackDataExplode[0]);
        $OpEnd = end($Operate);
        switch ($OpEnd) {
            case 'update_link':
                // 重置订阅链接
                $this->User->cleanLink();
                $this->answerCallbackQuery([
                    'text' => 'پیوند اشتراک با موفقیت بازنشانی شد، لطفا اشتراک زیر را تمدید کنید.',
                    'show_alert' => true,
                ]);
                $temp = $this->getUserSubscribeKeyboard();
                $sendMessage = [
                    'text' => $temp['text'],
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => $temp['keyboard'],
                        ]
                    ),
                ];
                break;
            case 'update_passwd':
                // 重置链接密码
                $this->User->passwd = Tools::genRandomChar(8);
                if ($this->User->save()) {
                    $answerCallbackQuery = 'رمز عبور اتصال با موفقیت به روز شد، لطفا اشتراک زیر را تمدید کنید.';
                    $temp = $this->getUserSubscribeKeyboard();
                } else {
                    $answerCallbackQuery = 'خطایی روی داد، به‌روزرسانی رمز عبور اتصال ناموفق بود، لطفاً با سرپرست تماس بگیرید.';
                    $temp = $this->getUserEditKeyboard();
                }
                $this->answerCallbackQuery([
                    'text' => $answerCallbackQuery,
                    'show_alert' => true,
                ]);
                $sendMessage = [
                    'text' => $temp['text'],
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => $temp['keyboard'],
                        ]
                    ),
                ];
                break;
            case 'encrypt':
                // 加密方式更改
                $keyboard = $back;
                if (isset($CallbackDataExplode[1])) {
                    if (\in_array($CallbackDataExplode[1], Config::getSupportParam('method'))) {
                        $temp = $this->User->setMethod($CallbackDataExplode[1]);
                        if ($temp['ok'] === true) {
                            $text = 'روش رمزگذاری فعلی شما این است：' . $this->User->method . PHP_EOL . PHP_EOL . $temp['msg'];
                        } else {
                            $text = 'خطایی روی داد، لطفاً دوباره امتحان کنید.' . PHP_EOL . PHP_EOL . $temp['msg'];
                        }
                    } else {
                        $text = 'خطایی روی داد، لطفاً دوباره امتحان کنید.';
                    }
                } else {
                    $Encrypts = [];
                    foreach (Config::getSupportParam('method') as $value) {
                        $Encrypts[] = [
                            'text' => $value,
                            'callback_data' => 'user.edit.encrypt|' . $value,
                        ];
                    }
                    $Encrypts = array_chunk($Encrypts, 2);
                    $keyboard = [];
                    foreach ($Encrypts as $Encrypt) {
                        $keyboard[] = $Encrypt;
                    }
                    $keyboard[] = $back[0];
                    $text = 'روش رمزگذاری فعلی شما این است：' . $this->User->method;
                }
                $sendMessage = [
                    'text' => $text,
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => $keyboard,
                        ]
                    ),
                ];
                break;
            case 'sendemail':
                // 每日邮件设置更改
                $keyboard = [
                    [
                        [
                            'text' => 'تغییر روشن/خاموش',
                            'callback_data' => 'user.edit.sendemail.update',
                        ],
                    ],
                    $back[0],
                ];
                $OpEnd = end($Operate);
                switch ($OpEnd) {
                    case 'update':
                        $this->User->sendDailyMail = ($this->User->sendDailyMail === 0 ? 1 : 0);
                        if ($this->User->save()) {
                            $text = 'تنظیمات با موفقیت تغییر کرد، دریافت روزانه ایمیل در حال حاضر تنظیم شده است：';
                            $text .= '<strong>';
                            $text .= ($this->User->sendDailyMail === 0 ? 'نفرست' : 'ارسال');
                            $text .= '</strong>';
                        } else {
                            $text = 'خطایی رخ داد.';
                        }
                        break;
                    default:
                        $text = 'دریافت روزانه ایمیل در حال حاضر تنظیم شده است：';
                        $text .= '<strong>';
                        $text .= ($this->User->sendDailyMail === 0 ? 'نفرست' : 'ارسال');
                        $text .= '</strong>';
                        break;
                }
                $sendMessage = [
                    'text' => $text,
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => $keyboard,
                        ]
                    ),
                ];
                break;
            case 'unbind':
                // Telegram 账户解绑
                $this->AllowEditMessage = false;
                $text = 'ارسال **/unbind ایمیل** برای لغو پیوند.';
                if (Setting::obtain('telegram_unbind_kick_member') === true) {
                    $text .= PHP_EOL . PHP_EOL . 'طبق تنظیمات مدیر，حساب بدون پیوند شما به طور خودکار از گروه کاربری حذف خواهد شد.';
                }
                $sendMessage = [
                    'text' => $text,
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'parse_mode' => 'Markdown',
                    'reply_markup' => null,
                ];
                break;
            case 'unban':
                // 群组解封
                $sendMessage = [
                    'text' => 'اگر قبلاً در گروه کاربری هستید، لطفاً به دلخواه برای رفع انسداد کلیک نکنید، در غیر این صورت از گروه حذف خواهید شد..',
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => [
                                [
                                    [
                                        'text' => 'برای رفع انسداد روی ارسال کلیک کنید',
                                        'callback_data' => 'user.edit.unban_update',
                                    ],
                                ],
                                $back[0],
                            ],
                        ]
                    ),
                ];
                break;
            case 'unban_update':
                // 提交群组解封
                TelegramTools::sendPost(
                    'unbanChatMember',
                    [
                        'chat_id' => $_ENV['telegram_chatid'],
                        'user_id' => $this->triggerUser['id'],
                    ]
                );
                $this->answerCallbackQuery([
                    'text' => 'برای رفع انسداد ارسال شد، اگر هنوز نمی توانید به گروه بپیوندید، لطفاً با سرپرست تماس بگیرید.',
                    'show_alert' => true,
                ]);
                break;
            default:
                $temp = $this->getUserEditKeyboard();
                $text = 'در اینجا می توانید مشخصات یا اطلاعات اتصال خود را ویرایش کنید：' . PHP_EOL . PHP_EOL;
                $text .= 'پورت：' . $this->User->port . PHP_EOL;
                $text .= 'کلمه عبور：' . $this->User->passwd . PHP_EOL;
                $text .= 'رمزگذاری：' . $this->User->method;
                $sendMessage = [
                    'text' => $text,
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => $temp['keyboard'],
                        ]
                    ),
                ];
                break;
        }
        $this->replyWithMessage(
            array_merge(
                [
                    'parse_mode' => 'HTML',
                ],
                $sendMessage
            )
        );
    }

    public function getUserSubscribeKeyboard()
    {
        $text = 'نوع پیوند اشتراکی که می خواهید استفاده کنید را انتخاب کنید:';
        $keyboard = [
            [
                [
                    'text' => 'Clash',
                    'callback_data' => 'user.subscribe|clash',
                ],
                [
                    'text' => 'Json',
                    'callback_data' => 'user.subscribe|json',
                ],
            ],
            [
                [
                    'text' => 'Shadowsocks',
                    'callback_data' => 'user.subscribe|ss',
                ],
                [
                    'text' => 'Shadowsocks SIP002',
                    'callback_data' => 'user.subscribe|sip002',
                ],
            ],
            [
                [
                    'text' => 'Vmess/Vless',
                    'callback_data' => 'user.subscribe|v2',
                ],
                [
                    'text' => 'Trojan',
                    'callback_data' => 'user.subscribe|trojan',
                ],
            ],
            [
                [
                    'text' => 'بازگشت به منوی اصلی',
                    'callback_data' => 'user.index',
                ],
            ],
        ];
        return [
            'text' => $text,
            'keyboard' => $keyboard,
        ];
    }

    /**
     * 用户订阅
     */
    public function userSubscribe(): void
    {
        $CallbackDataExplode = explode('|', $this->CallbackData);
        // 订阅中心
        if (isset($CallbackDataExplode[1])) {
            $temp = [];
            $temp['keyboard'] = [
                [
                    [
                        'text' => 'بازگشت به منوی اصلی',
                        'callback_data' => 'user.index',
                    ],
                    [
                        'text' => 'بازگشت به صفحه قبل',
                        'callback_data' => 'user.subscribe',
                    ],
                ],
            ];
            $UniversalSub_Url = SubController::getUniversalSub($this->User);
            $TraditionalSub_Url = LinkController::getTraditionalSub($this->User);
            switch ($CallbackDataExplode[1]) {
                case 'clash':
                    $text = 'Clash آدرس اشتراک جهانی：' . PHP_EOL . PHP_EOL . '<code>' . $UniversalSub_Url . '/clash</code>' . PHP_EOL . PHP_EOL;
                    $sendMessage = [
                        'text' => $text,
                        'disable_web_page_preview' => true,
                        'reply_to_message_id' => null,
                        'reply_markup' => \json_encode(
                            [
                                'inline_keyboard' => $temp['keyboard'],
                            ]
                        ),
                    ];
                    break;
                case 'json':
                    $text = 'Json آدرس اشتراک جهانی：' . PHP_EOL . PHP_EOL . '<code>' . $UniversalSub_Url . '/json</code>' . PHP_EOL . PHP_EOL;
                    $sendMessage = [
                        'text' => $text,
                        'disable_web_page_preview' => true,
                        'reply_to_message_id' => null,
                        'reply_markup' => \json_encode(
                            [
                                'inline_keyboard' => $temp['keyboard'],
                            ]
                        ),
                    ];
                    break;
                case 'ss':
                    $text = 'Shadowsocks آدرس اشتراک جهانی：' . PHP_EOL . PHP_EOL . '<code>' . $TraditionalSub_Url . '?ss=1</code>' . PHP_EOL . PHP_EOL;
                    $sendMessage = [
                        'text' => $text,
                        'disable_web_page_preview' => true,
                        'reply_to_message_id' => null,
                        'reply_markup' => \json_encode(
                            [
                                'inline_keyboard' => $temp['keyboard'],
                            ]
                        ),
                    ];
                    break;
                case 'sip002':
                    $text = 'Shadowsocks SIP002 آدرس اشتراک جهانی：' . PHP_EOL . PHP_EOL . '<code>' . $TraditionalSub_Url . '?sip002=1</code>' . PHP_EOL . PHP_EOL;
                    $sendMessage = [
                        'text' => $text,
                        'disable_web_page_preview' => true,
                        'reply_to_message_id' => null,
                        'reply_markup' => \json_encode(
                            [
                                'inline_keyboard' => $temp['keyboard'],
                            ]
                        ),
                    ];
                    break;
                case 'v2':
                    $text = 'V2Ray آدرس اشتراک جهانی：' . PHP_EOL . PHP_EOL . '<code>' . $TraditionalSub_Url . '?v2ray=1</code>' . PHP_EOL . PHP_EOL;
                    $sendMessage = [
                        'text' => $text,
                        'disable_web_page_preview' => true,
                        'reply_to_message_id' => null,
                        'reply_markup' => \json_encode(
                            [
                                'inline_keyboard' => $temp['keyboard'],
                            ]
                        ),
                    ];
                    break;
                case 'trojan':
                    $text = 'Trojan آدرس اشتراک جهانی：' . PHP_EOL . PHP_EOL . '<code>' . $TraditionalSub_Url . '?trojan=1</code>' . PHP_EOL . PHP_EOL;
                    $sendMessage = [
                        'text' => $text,
                        'disable_web_page_preview' => true,
                        'reply_to_message_id' => null,
                        'reply_markup' => \json_encode(
                            [
                                'inline_keyboard' => $temp['keyboard'],
                            ]
                        ),
                    ];
                    break;
            }
        } else {
            $temp = $this->getUserSubscribeKeyboard();
            $sendMessage = [
                'text' => $temp['text'],
                'disable_web_page_preview' => false,
                'reply_to_message_id' => null,
                'reply_markup' => \json_encode(
                    [
                        'inline_keyboard' => $temp['keyboard'],
                    ]
                ),
            ];
        }
        $this->replyWithMessage(
            array_merge(
                [
                    'parse_mode' => 'HTML',
                ],
                $sendMessage
            )
        );
    }

    public function getUserInviteKeyboard()
    {
        $paybacks_sum = Payback::where('ref_by', $this->User->id)->sum('ref_get');

        if (! is_null($paybacks_sum)) {
            $paybacks_sum = 0;
        }
        $invitation = Setting::getClass('invite');
        $text = [
            '<strong>طرح اشتراک گذاری، به ازای هر 1 کاربری که برای ثبت نام دعوت می کنید：</strong>',
            '',
            '- دریافت خواهید کرد <strong>' . $invitation['invitation_to_register_traffic_reward'] . 'G</strong> پاداش ترافیک.',
            '- طرف مقابل خواهد گرفت <strong>' . $invitation['invitation_to_register_balance_reward'] . ' تومان</strong> پاداش به عنوان بودجه اولیه.',
            '- هنگامی که طرف مقابل شارژ می شود، مبلغ شارژ طرف مقابل را نیز دریافت خواهید کرد <strong>' . $invitation['rebate_ratio'] . '%</strong> تخفیف.',
            '',
            'تخفیف دریافت کرد：' . $paybacks_sum . ' تومان.',
        ];
        $keyboard = [
            [
                [
                    'text' => 'لینک دعوت من را دریافت کنید',
                    'callback_data' => 'user.invite.get',
                ],
            ],
            [
                [
                    'text' => 'بازگشت به منوی اصلی',
                    'callback_data' => 'user.index',
                ],
            ],
        ];
        return [
            'text' => implode(PHP_EOL, $text),
            'keyboard' => $keyboard,
        ];
    }

    /**
     * 分享计划
     */
    public function userInvite(): void
    {
        $CallbackDataExplode = explode('|', $this->CallbackData);
        $Operate = explode('.', $CallbackDataExplode[0]);
        $OpEnd = end($Operate);
        switch ($OpEnd) {
            case 'get':
                $this->AllowEditMessage = false;
                $code = InviteCode::where('user_id', $this->User->id)->first();
                if ($code === null) {
                    $this->User->addInviteCode();
                    $code = InviteCode::where('user_id', $this->User->id)->first();
                }
                $inviteUrl = $_ENV['baseUrl'] . '/auth/register?code=' . $code->code;
                $text = '<a href="' . $inviteUrl . '">' . $inviteUrl . '</a>';
                $sendMessage = [
                    'text' => $text,
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => null,
                ];
                break;
            default:
                $temp = $this->getUserInviteKeyboard();
                $sendMessage = [
                    'text' => $temp['text'],
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => \json_encode(
                        [
                            'inline_keyboard' => $temp['keyboard'],
                        ]
                    ),
                ];
                break;
        }
        $this->replyWithMessage(
            array_merge(
                [
                    'parse_mode' => 'HTML',
                ],
                $sendMessage
            )
        );
    }

    /**
     * 每日签到
     */
    public function userCheckin(): void
    {
        $checkin = $this->User->checkin();
        $this->answerCallbackQuery([
            'text' => $checkin['msg'],
            'show_alert' => true,
        ]);
        // 回送信息
        if ($this->ChatID > 0) {
            $temp = self::getUserIndexKeyboard($this->User);
        } else {
            $temp['text'] = Reply::getUserTitle($this->User);
            $temp['text'] .= PHP_EOL . PHP_EOL;
            $temp['text'] .= Reply::getUserTrafficInfo($this->User);
            $temp['text'] .= PHP_EOL;
            $temp['text'] .= 'زمان تنظیم مجدد ترافیک：' . $this->User->validUseLoop();
            $temp['keyboard'] = [
                [
                    [
                        'text' => (! $this->User->isAbleToCheckin() ? 'وارد شدن' : 'چک کردن'),
                        'callback_data' => 'user.checkin.' . $this->triggerUser['id'],
                    ],
                ],
            ];
        }
        $this->replyWithMessage([
            'text' => $temp['text'] . PHP_EOL . PHP_EOL . $checkin['msg'],
            'reply_to_message_id' => $this->MessageID,
            'parse_mode' => 'Markdown',
            'reply_markup' => \json_encode(
                [
                    'inline_keyboard' => $temp['keyboard'],
                ]
            ),
        ]);
    }
}

<?php

declare(strict_types=1);

namespace App\Services\Bot\Telegram;

use App\Models\Config;
use App\Models\InviteCode;
use App\Models\LoginIp;
use App\Models\OnlineLog;
use App\Models\Payback;
use App\Models\SubscribeLog;
use App\Models\User;
use App\Services\Bot\Telegram\Commands\ProductCommand;
use App\Services\Reward;
use App\Services\Subscribe;
use App\Utils\ResponseHelper;
use App\Utils\Tools;
use GuzzleHttp\Exception\GuzzleException;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Collection;
use MaxMind\Db\Reader\InvalidDatabaseException;
use Telegram\Bot\Api;
use Telegram\Bot\Exceptions\TelegramSDKException;
use Telegram\Bot\Keyboard\Keyboard;

use function array_chunk;
use function array_merge;
use function end;
use function explode;
use function implode;
use function in_array;
use function is_null;
use function json_encode;
use function time;
use const PHP_EOL;

final class Callback
{
    /**
     * Bot
     */
    private Api $bot;

    /**
     * 触发用户
     */
    private null|Model|User $user;

    /**
     * 触发用户TG信息
     */
    private array $trigger_user;

    /**
     * 回调
     */
    private Collection $callback;

    /**
     * 回调数据内容
     */
    private $callback_data;

    /**
     * 消息会话 ID
     */
    private $chat_id;

    /**
     * 触发源信息 ID
     */
    private $message_id;

    /**
     * 源消息是否可编辑
     */
    private bool $allow_edit_message;

    /**
     * @throws InvalidDatabaseException
     * @throws TelegramSDKException|GuzzleException
     */
    public function __construct(Api $bot, Collection $callback)
    {
        $this->bot = $bot;

        $this->trigger_user = [
            'id' => $callback->getFrom()->getId(),
            'name' => $callback->getFrom()->getFirstName() . ' Callback.php' . $callback->getFrom()->getLastName(),
            'username' => $callback->getFrom()->getUsername(),
        ];

        $this->user = PersistedInfo::getUser($this->trigger_user['id']);
        $this->chat_id = $callback->getMessage()->getChat()->getId();
        $this->callback = $callback;
        $this->message_id = $callback->getMessage()->getMessageId();
        $this->callback_data = $callback->getData();
        $this->allow_edit_message = time() < $callback->getMessage()->getDate() + 172800;

        if ($this->chat_id < 0 && Config::obtain('telegram_group_quiet')) {
            // 群组中不回应
            return;
        }

        if (str_starts_with($this->callback_data, 'user.')) {
            // 用户相关
            $this->userCallback();
        } else if (str_starts_with($this->callback_data, 'product')) {
            // 用户相关
            $this->productsCallback();
        } else if (str_starts_with($this->callback_data, 'back')) {
            // 用户相关
            $this->backCallback();
        } else if (str_starts_with($this->callback_data, 'buy')) {
            // 用户相关
            $this->buyCallback();
        } else if (str_starts_with($this->callback_data, 'charge.account')) {
            // 用户相关
            $this->chargeCallback();
        } else if (str_starts_with($this->callback_data, 'giftcard')) {
            // 用户相关
            $this->giftcardCallback();
        } else if (str_starts_with($this->callback_data, 'tether')) {
            // 用户相关
            $this->tetherCallback();
        } else if (str_starts_with($this->callback_data, 'perfectmoney')) {
            // 用户相关
            $this->perfectmoneyCallback();
        } else if (str_starts_with($this->callback_data, 'tran_tether')) {
            // 用户相关
            $this->tetherTranCallback();
        } else if (str_starts_with($this->callback_data, 'software')) {
            // 用户相关
            $this->softwareCallback();
        }
    }


    /**
     * 响应回调查询 | 默认已添加 chat_id 和 message_id
     *
     * @param array $send_message
     *
     * @throws TelegramSDKException
     * @throws GuzzleException
     */
    public function replyWithMessage(array $send_message): void
    {
        $send_message = array_merge(
            [
                'chat_id' => $this->chat_id,
                'message_id' => $this->message_id,
            ],
            $send_message
        );

        if ($this->allow_edit_message) {
            Message::sendPost('editMessageText', $send_message);
        } else {
            $this->bot->sendMessage($send_message);
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
     * @param array $send_message
     *
     * @throws GuzzleException
     */
    public function answerCallbackQuery(array $send_message): void
    {
        $send_message = array_merge(
            [
                'callback_query_id' => $this->callback->getId(),
                'show_alert' => false,
            ],
            $send_message
        );

        Message::sendPost('answerCallbackQuery', $send_message);
    }

    public static function getUserIndexKeyboard($user): array
    {
        $checkin =  [
            [[
                'text' => 'دریافت هدیه روزانه',
                'callback_data' => 'user.checkin.' . $user->im_value,
            ]],
            [
                [
                    'text' => 'بازگشت به منوی اصلی',
                    'callback_data' => 'back',
                ],
            ]

        ];

        $keyboard = [
            [
                [
                    'text' => 'پروفایل من',
                    'callback_data' => 'user.center',
                ],
                [
                    'text' => 'ویرایش اطلاعات من',
                    'callback_data' => 'user.edit',
                ],
            ],
            [
                [
                    'text' => 'لینک کانفیگ',
                    'callback_data' => 'user.subscribe',
                ],
                [
                    'text' => 'دعوت از دوستان',
                    'callback_data' => 'user.invite',
                ],
            ],

        ];
        if ($user->isAbleToCheckin()) {
            $keyboard = array_merge($keyboard, $checkin);
        }

        $text = Message::getUserTitle($user);
        $text .= PHP_EOL . PHP_EOL;
        $text .= Message::getUserInfo($user);

        return [
            'text' => $text,
            'keyboard' => $keyboard,
        ];
    }

    /**
     * 用户相关回调数据处理
     *
     * @throws InvalidDatabaseException
     * @throws TelegramSDKException|GuzzleException
     */
    public function userCallback(): void
    {
        if ($this->user === null && $this->chat_id < 0) {
            // 群组内提示
            $this->answerCallbackQuery([
                'text' => 'سلام، شما حسابی را باند نکرده اید و نمی توانید عملیات انجام دهید.',
                'show_alert' => true,
            ]);
        }

        $CallbackDataExplode = explode('|', $this->callback_data);
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
                if ((int) $Operate[2] !== $this->trigger_user['id']) {
                    $this->answerCallbackQuery([
                        'text' => 'سلام، شما نمی توانید حساب های دیگران را اداره کنید.',
                        'show_alert' => true,
                    ]);
                }
                $this->userCheckin();
                break;
            case 'center':
                // 用户中心
                $this->userCenter();
                break;
            default:
                // 用户首页
                $temp = self::getUserIndexKeyboard($this->user);

                $this->replyWithMessage([
                    'text' => $temp['text'],
                    'parse_mode' => 'HTML',
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => json_encode(
                        [
                            'inline_keyboard' => $temp['keyboard'],
                        ]
                    ),
                ]);
        }
    }
    public function productsCallback(): void
    {

        $reply = self::productsReply($this->user);

        $this->replyWithMessage([
            'text' => $reply['text'],
            'parse_mode' => 'HTML',
            'disable_web_page_preview' => false,
            'reply_to_message_id' => null,
            'reply_markup' => json_encode(
                [
                    'inline_keyboard' => $reply['keyboard'],
                ]
            ),
        ]);
    }
    public static function productsReply($user)
    {
        $product = PersistedInfo::getProducts();
        $keyBoard = [
            [
                [
                    'text' => 'بازگشت به منوی اصلی',
                    'callback_data' => 'back',
                ],
            ]

        ];
        foreach ($product as $p) {
            $keyBoard = array_merge(
                [
                    [
                        [
                            'text' => $p->name . ': ' . $p->price . '$',
                            'callback_data' => 'buy.' . $p->id,
                        ]
                    ]
                ],
                $keyBoard
            );
        }
        if ($user != null) {
            $text = " کاربرگرامی، موجودی حساب شما" . $user->money . " است";
            $text .= PHP_EOL . PHP_EOL;
            $text .= "در صورتی که موجودی حساب شما برای خرید کافی نباشد به منو افزایش موجودی متصل میشوید";
            $text .= PHP_EOL . PHP_EOL;
            $text .= $_ENV['baseUrl'];
        }

        if ($user === null) {
            $text = "کاربر گرامی.";
            $text .= PHP_EOL;
            $text = "شناسه تلگرام شما برای ما ناشناس است.";
            $text .= PHP_EOL;
            $text = "لطفا از طریق منوی استارت لاگین کنید یا عضو شوید";
            
        }
        return [
            'text' => $text,
            'keyboard' => $keyBoard
        ];
    }
    public function backCallback(): void
    {
        $this->replyWithMessage($this->getStartCommandReply($this->user));
    }
    public function giftcardCallback(): void
    {
        $text = "کد کارت هدیه خود را وارد کنید";
        $this->replyWithMessage([
            'text' => $text,
            'parse_mode' => 'Markdown',
            'disable_web_page_preview' => false,
            'reply_to_message_id' => null,

        ]);
    }
     public function perfectmoneyCallback(): void
    {


        if ($this->user == null) {
            $this->replyWithMessage(Callback::getUserNotFoundReply());
        } else {
            $CallbackDataExplode = explode('|', $this->callback_data);
            $Operate = explode('.', $CallbackDataExplode[0]);
            if($Operate[1]="1"){
                $text = "شماره وچر که یک کد 10 رقمی است را وراد کنید";
            }
            else if($Operate[1]="2")
            {

            }
           
            $this->replyWithMessage([
                'text' => $text,
                'parse_mode' => 'Markdown',
                'disable_web_page_preview' => false,
                'reply_to_message_id' => null,
    
            ]);
        }

       
    }
    public function tetherTranCallback(): void
    {
        $text = "شماره تراکنش خود را وراد کنید";
        $this->replyWithMessage([
            'text' => $text,
            'parse_mode' => 'Markdown',
            'disable_web_page_preview' => false,
            'reply_to_message_id' => null,

        ]);
    }
    public function tetherCallback(): void
    {

        $text  = $_ENV['baseUrl'] . "/images/BTether-Address.jpg";
        $text .= PHP_EOL;
        $text .= $this->user->user_name . " عزیز**";
        $text .= PHP_EOL;
        $text .= "موجودی حساب شما" . $this->user->money . "است.";
        $text .= PHP_EOL . PHP_EOL;
        $text .= "شماره تراکنش را برای ما ارسال کنید.لطفا مبلغ مورد نظر خود را به ادرس زیر منتقل کنید.";
        $text .= PHP_EOL;
        $text .= "0xEB1FE7b959034efFFA16a503F2eF7d3000597507";
        $text .= PHP_EOL;
        $text .= "در زمان انتقال از انتخاب شیکه بایننس اطمینان حاصل کنید. شبکه باینسس کمترین مقدار کارمزد انتقال را دارد.";
        $text .= PHP_EOL . PHP_EOL;
        $text .= "برای سهولت کار پیشنهاد ما استفاده از سایت ایرانیکارت و پرداخت ریالی برای انتقال است.";
        $text .= PHP_EOL;
        $text .= "https://www.iranicard.ir/";
        $text .= PHP_EOL . PHP_EOL;
        $text  .= "اسکن کنید:";


        $reply = [
            'text' => $text,
            'keyboard' => [
                [
                    [
                        'text' => 'ارسال شماره تراکنش',
                        'callback_data' => 'tran_tether',
                    ]

                ],
                [
                    [
                        'text' => 'راهتمای انتقال تتر با کارت بانکی',
                        'callback_data' => 'tran_tether_help',
                    ]

                ]
            ]
        ];
        $this->replyWithMessage([
            'text' => $reply['text'],
            'parse_mode' => 'Markdown',
            'disable_web_page_preview' => false,
            'reply_to_message_id' => null,
            'reply_markup' => json_encode(
                [
                    'inline_keyboard' => $reply['keyboard'] ?? [],
                ]
            ),

        ]);
    }
    public static function getChargeReply($user)
    {
        $text = "موجودی شما " . $user->money . ' است.';
        $text .= PHP_EOL . PHP_EOL;
        $text .= "پشتیبانی : https://t.me/Magix\_admin";//. $_ENV['adminLink'];
        $reply = [
            'text' => $text,
            'keyboard' => [
                [
                    [
                        'text' => 'کارت هدیه دارم',
                        'callback_data' => 'giftcard',
                    ],
                    [
                        'text' => 'انتقال تتر',
                        'callback_data' => 'tether',
                    ],
                ],
                [
                    [
                        'text' => 'وچر پرفکت مانی',
                        'callback_data' => 'perfectmoney',
                    ],
                ],
                [
                    [
                        'text' => 'بازگشت به منوی اصلی',
                        'callback_data' => 'back',
                    ],
                ]
            ]
        ];



        return  [
            'text' => $reply['text'] ?? 'Hi!',
            'parse_mode' => 'Markdown',
            'disable_web_page_preview' => false,
            'reply_to_message_id' => null,
            'reply_markup' => json_encode(
                [
                    'inline_keyboard' => $reply['keyboard'] ?? [],
                ]
            ),
        ];
    }
    public function chargeCallback(): void
    {
        $this->replyWithMessage($this->getChargeReply($this->user));
    }
    public function buyCallback()
    {
        if ($this->user == null) {
            $this->replyWithMessage(Callback::getUserNotFoundReply());
        } else {
            $CallbackDataExplode = explode('|', $this->callback_data);
            $Operate = explode('.', $CallbackDataExplode[0]);
            $product = PersistedInfo::getProduct(intval($Operate[1]));
            if ($product != null) {
                if ($this->user->money < $product->price) {
                    $this->replyWithMessage($this->getChargeReply($this->user));
                } else {
                    //do buying prosses
                    PersistedInfo::processInvoice($product, '', $this->user);
                    $text = 'خرید شما موفقیت امیز بود.';
                    $text .= PHP_EOL;
                    $text = 'موجودی حساب شما برابر: ' . $this->user->money;
                    $text .= PHP_EOL;
                    $text = 'برای دریافت کانفیگ و نرم افزار مناسب اقدام کنید';
                    

                    $reply = [
                        'text' => $text,
                        'keyboard' => [
                            [
                                [
                                    'text' => 'لینک کانفیگ',
                                    'callback_data' => 'user.subscribe',
                                ],
                                [
                                    'text' => ' نرافزار ها ',
                                    'callback_data' => 'software',
                                ],
                            ],
                            [

                                [
                                    'text' => 'بازگشت به منوی اصلی',
                                    'callback_data' => 'back',
                                ],
                            ]
                        ]
                    ];


                    $this->replyWithMessage([
                        'text' => $reply['text'] ?? 'Hi!',
                        'parse_mode' => 'Markdown',
                        'disable_web_page_preview' => false,
                        'reply_to_message_id' => null,
                        'reply_markup' => json_encode(
                            [
                                'inline_keyboard' => $reply['keyboard'] ?? [],
                            ]
                        ),
                    ]);
                }
            }
        }
    }

    public function softwareCallback()
    {
        $CallbackDataExplode = explode('|', $this->callback_data);
        $Operate = explode('.', $CallbackDataExplode[0]);
        $size = count($Operate);
        $reply = [];
        if ($size == 1) {
            $reply = $this->osReply();
        } else if ($size == 2) {
            $reply = $this->softwareReply($Operate[1]);
        } else if ($size == 3) {
            //return download reply
            $url = $_ENV['baseUrl'];
            if ($Operate[1] == 'windows') {
                if ($Operate[2] == 'clash') {
                    $url .= '/clients/Clash.Verge.exe';
                } else if ($Operate[2] == 'hiddify') {
                    $url .= '/clients/hiddify-windows-x64-setup.zip';
                } else if ($Operate[2] == 'sinxbox') {
                    $url .= ' ';
                }
            } else if ($Operate[1] == 'ios') {
                if ($Operate[2] == 'clash') {
                    $url .= '/clients/Clash.Verge_aarch64.dmg';
                } else if ($Operate[2] == 'hiddify') {
                    $url .= '/clients/hiddify-macos-universal.zip';
                } else if ($Operate[2] == 'sinxbox') {
                    $url .= ' ';
                }
            } else if ($Operate[1] == 'android') {
                if ($Operate[2] == 'clash') {
                    $url .= '/clients/CMFA.apk';
                } else if ($Operate[2] == 'hiddify') {
                    $url .= '/clients/hiddify-android-universal.apk';
                } else if ($Operate[2] == 'sinxbox') {
                    $url .= ' ';
                }
            } else if ($Operate[1] == 'mac') {
                if ($Operate[2] == 'clash') {
                    $url .= ' ';
                } else if ($Operate[2] == 'hiddify') {
                    $url .= ' ';
                } else if ($Operate[2] == 'sinxbox') {
                    $url .= ' ';
                }
            } else if ($Operate[1] == 'linux') {
                if ($Operate[2] == 'clash') {
                    $url .= '/clients/Clash.Verge.AppImage.tar.gz';
                } else if ($Operate[2] == 'hiddify') {
                    $url .= '/clients/hiddify-linux-x64.zip';
                } else if ($Operate[2] == 'sinxbox') {
                    $url .= ' ';
                }
            }
            $reply = [
                'text' => $url,
                'keyboard' => [[]]
            ];
        }

        $this->replyWithMessage([
            'text' => $reply['text'] ?? 'Hi!',
            'parse_mode' => 'Markdown',
            'disable_web_page_preview' => false,
            'reply_to_message_id' => null,
            'reply_markup' => json_encode(
                [
                    'inline_keyboard' => $reply['keyboard'] ?? [],
                ]
            ),
        ]);
    }
    public function osReply()
    {

        $text = "سیستم عامل مورد نظر که قصد نصب نرم افزار بر روی آن را دارید";
        $text .= "را انتخاب کنبد:";

        $keyboard = [
            [
                [
                    'text' => ' ویندوز',
                    'callback_data' => 'software.windows',
                ],
                [
                    'text' => 'مکینتاش',
                    'callback_data' => 'software.mac',
                ],
            ],
            [
                [
                    'text' => ' اندروید',
                    'callback_data' => 'software.android',
                ],
                /* [
                    'text' => ' ای او اس',
                    'callback_data' => 'software.ios',
                ], */
            ],
            [
                [
                    'text' => 'لینوکس',
                    'callback_data' => 'software.linux',
                ]
            ],

            [
                [
                    'text' => 'بازگشت به منوی اصلی',
                    'callback_data' => 'back',
                ],
            ],
        ];

        return [
            'text' => $text,
            'keyboard' => $keyboard,
        ];
    }
    public function softwareReply($os)
    {

        $text = "نرم افزار مورد نظر خود را انتخاب کنید";
        

        $keyboard = [
            [
                [
                    'text' => ' هیدیفای',
                    'callback_data' => 'software.' . $os . '.hiddify',
                ],
                [
                    'text' => 'کلش',
                    'callback_data' => 'software.' . $os . '.clash',
                ],
            ],

            [
                [
                    'text' => 'بازگشت به منوی قبل',
                    'callback_data' => 'software',
                ],
            ],
        ];

        return [
            'text' => $text,
            'keyboard' => $keyboard,
        ];
    }
    public function getUserCenterKeyboard(): array
    {
        $text = Message::getUserTitle($this->user);
        $text .= PHP_EOL . PHP_EOL;
        $text .= Message::getUserTrafficInfo($this->user);

        $keyboard = [
            [
                [
                    'text' => 'ورود های پیشین',
                    'callback_data' => 'user.center.login_log',
                ],
                [
                    'text' => 'آی پی آنلاین',
                    'callback_data' => 'user.center.usage_log',
                ],
            ],
            [
                [
                    'text' => 'تخفیفات پیشین',
                    'callback_data' => 'user.center.rebate_log',
                ],
                [
                    'text' => 'اشتراک های پیشین',
                    'callback_data' => 'user.center.subscribe_log',
                ],
            ],
            [
                [
                    'text' => 'بازگشت به منوی اصلی',
                    'callback_data' => 'back',
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
     *
     * @throws TelegramSDKException
     * @throws InvalidDatabaseException|GuzzleException
     */
    public function userCenter(): void
    {
        $back = [
            [
                [
                    'text' => 'بازگشت به منوی اصلی',
                    'callback_data' => 'back',
                ],
                [
                    'text' => 'بازگشت به صفحه قبل',
                    'callback_data' => 'user.center',
                ],
            ],
        ];

        $CallbackDataExplode = explode('|', $this->callback_data);
        $Operate = explode('.', $CallbackDataExplode[0]);
        $OpEnd = end($Operate);

        switch ($OpEnd) {
            case 'login_log':
                // 登录记录
                $total = (new LoginIp())->where('userid', $this->user->id)
                    ->where('type', '=', 0)
                    ->orderBy('datetime', 'desc')
                    ->take(10)
                    ->get();
                $text = '<strong>موارد زیر 10 آخرین IP ورود به سیستم و مکان های جغرافیایی شما هستند：</strong>' . PHP_EOL . PHP_EOL;

                foreach ($total as $single) {
                    $text .= $single->ip . ' - ' . Tools::getIpLocation($single->ip) . PHP_EOL;
                }

                $text .= PHP_EOL . '<strong>توجه: موقعیت جغرافیایی بر اساس پایگاه داده MaxMind GeoIP2 تخمین زده شده است و ممکن است با مکان واقعی مطابقت نداشته باشد. این فقط برای مرجع است.</strong>' . PHP_EOL;

                $sendMessage = [
                    'text' => $text,
                    'disable_web_page_preview' => false,
                    'parse_mode' => 'HTML',
                    'reply_to_message_id' => null,
                    'reply_markup' => json_encode(
                        [
                            'inline_keyboard' => $back,
                        ]
                    ),
                ];

                break;
            case 'usage_log':
                // 使用记录
                $logs = (new OnlineLog())->where('user_id', $this->user->id)
                    ->where('last_time', '>', time() - 90)->orderByDesc('last_time')->get('ip');
                $text = '<strong>آدرس زیر IP آنلاین و موقعیت جغرافیایی شما است：</strong>' . PHP_EOL . PHP_EOL;

                foreach ($logs as $log) {
                    $ip = $log->ip();
                    $text .= $ip . ' - ' . Tools::getIpLocation($ip) . PHP_EOL;
                }

                $text .= PHP_EOL . '<strong>توجه: موقعیت جغرافیایی بر اساس پایگاه داده IP تخمین زده می شود که ممکن است با مکان واقعی مطابقت نداشته باشد و فقط برای مرجع است.</strong>' . PHP_EOL;

                $sendMessage = [
                    'text' => $text,
                    'disable_web_page_preview' => false,
                    'parse_mode' => 'HTML',
                    'reply_to_message_id' => null,
                    'reply_markup' => json_encode(
                        [
                            'inline_keyboard' => $back,
                        ]
                    ),
                ];

                break;
            case 'rebate_log':
                // 返利记录
                $paybacks = (new Payback())->where('ref_by', $this->user->id)->orderBy('datetime', 'desc')->take(10)->get();
                $text = '<strong>موارد زیر 10 رکورد آخر تخفیف شما هستند：</strong>' . PHP_EOL . PHP_EOL;
                $currency = ResponseHelper::translateCurrency(Config::obtain('system_currency'));
                foreach ($paybacks as $payback) {
                    $text .= '<code>#' . $payback->id .
                        '：' . ($payback->user() !== null ? $payback->user()->user_name : 'از سیستم خارج شد') . '：' .
                        $payback->ref_get . ' {$currency}</code>' . PHP_EOL;
                }

                $sendMessage = [
                    'text' => $text,
                    'disable_web_page_preview' => false,
                    'parse_mode' => 'HTML',
                    'reply_to_message_id' => null,
                    'reply_markup' => json_encode(
                        [
                            'inline_keyboard' => $back,
                        ]
                    ),
                ];

                break;
            case 'subscribe_log':
                // 订阅记录
                if (Config::obtain('subscribe_log')) {
                    $logs = (new SubscribeLog())->orderBy('id', 'desc')->where('user_id', $this->user->id)->take(10)->get();
                    $text = '<strong>موارد زیر 10 آخرین سابقه اشتراک شما هستند：</strong>' . PHP_EOL . PHP_EOL;

                    foreach ($logs as $log) {
                        $text .= '<code>' . Tools::toDateTime($log->request_time) .
                            ' وجود دارد [' . $log->request_ip . '] ' . Tools::getIpLocation($log->request_ip) .
                            ' بازدید کرده است ' . $log->type . ' اشتراک، ابونمان</code>' . PHP_EOL;
                    }

                    $text .= PHP_EOL . '<strong>توجه: موقعیت جغرافیایی بر اساس پایگاه داده MaxMind GeoIP2 تخمین زده شده است و ممکن است با مکان واقعی مطابقت نداشته باشد. این فقط برای مرجع است.</strong>' . PHP_EOL;
                } else {
                    $text = 'سایت عملکرد ضبط اشتراک را فعال نمی کند';
                }

                $sendMessage = [
                    'text' => $text,
                    'disable_web_page_preview' => false,
                    'parse_mode' => 'HTML',
                    'reply_to_message_id' => null,
                    'reply_markup' => json_encode(
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
                    'reply_markup' => json_encode(
                        [
                            'inline_keyboard' => $temp['keyboard'],
                        ]
                    ),
                ];

                break;
        }

        $this->replyWithMessage($sendMessage);
    }

    public function getUserEditKeyboard(): array
    {
        $text = Message::getUserTitle($this->user);
        $keyboard = [
            [
                [
                    'text' => 'آپدیت لینک اشتراک',
                    'callback_data' => 'user.edit.update_link',
                ],
                [
                    'text' => 'آپدیت رمز عبور لینک',
                    'callback_data' => 'user.edit.update_passwd',
                ],
            ],
            [
                [
                    'text' => 'تغییر روش رمزگذاری',
                    'callback_data' => 'user.edit.encrypt',
                ],
                [
                    'text' => 'لغو لینک حساب',
                    'callback_data' => 'user.edit.unbind',
                ],
            ],
            [
                [
                    'text' => 'رفع انسداد گروه',
                    'callback_data' => 'user.edit.unban',
                ],
            ],
            [
                [
                    'text' => 'بازگشت به منوی اصلی',
                    'callback_data' => 'back',
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
     *
     * @throws TelegramSDKException
     * @throws GuzzleException
     */
    public function userEdit(): void
    {
        if ($this->chat_id < 0) {
            $this->answerCallbackQuery([
                'text' => 'این عملیات را نمی توان در یک گروه انجام داد.',
                'show_alert' => true,
            ]);
        }

        $back = [
            [
                [
                    'text' => 'بازگشت به منوی اصلی',
                    'callback_data' => 'back',
                ],
                [
                    'text' => 'بازگشت به صفحه قبل',
                    'callback_data' => 'user.edit',
                ],
            ],
        ];

        $sendMessage = [];
        $CallbackDataExplode = explode('|', $this->callback_data);
        $Operate = explode('.', $CallbackDataExplode[0]);
        $OpEnd = end($Operate);

        switch ($OpEnd) {
            case 'update_link':
                // 重置订阅链接
                $this->user->removeLink();

                $this->answerCallbackQuery([
                    'text' => 'لینک اشتراک با موفقیت آپدیت شد، لطفا اشتراک زیر را تمدید کنید.',
                    'show_alert' => true,
                ]);

                $temp = $this->getUserSubscribeKeyboard();

                $sendMessage = [
                    'text' => $temp['text'],
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => json_encode(
                        [
                            'inline_keyboard' => $temp['keyboard'],
                        ]
                    ),
                ];

                break;
            case 'update_passwd':
                // 重置链接密码
                $this->user->passwd = Tools::genRandomChar();

                if ($this->user->save()) {
                    $answerCallbackQuery = 'رمز عبور اتصال با موفقیت به روز شد، لطفا اشتراک زیر را تمدید کنید.';
                    $temp = $this->getUserSubscribeKeyboard();
                } else {
                    $answerCallbackQuery = 'خطایی روی داد، به‌روزرسانی رمز اتصال ناموفق بود، لطفاً با مدیر تماس بگیرید.';
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
                    'reply_markup' => json_encode(
                        [
                            'inline_keyboard' => $temp['keyboard'],
                        ]
                    ),
                ];

                break;
            case 'encrypt':
                // 加密方式更改
                $keyboard = $back;
                $method = Tools::getSsMethod('method');

                if (isset($CallbackDataExplode[1])) {
                    if (in_array($CallbackDataExplode[1], $method)) {
                        $temp = $this->user->setMethod($CallbackDataExplode[1]);
                        if ($temp['ok']) {
                            $text = 'روش رمزگذاری فعلی شما است：' . $this->user->method . PHP_EOL . PHP_EOL . $temp['msg'];
                        } else {
                            $text = 'خطایی روی داد، لطفا دوباره امتحان کنید.' . PHP_EOL . PHP_EOL . $temp['msg'];
                        }
                    } else {
                        $text = 'خطایی روی داد، لطفا دوباره امتحان کنید.';
                    }
                } else {
                    $Encrypts = [];

                    foreach ($method as $value) {
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
                    $text = 'روش رمزگذاری فعلی شما است：' . $this->user->method;
                }

                $sendMessage = [
                    'text' => $text,
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => json_encode(
                        [
                            'inline_keyboard' => $keyboard,
                        ]
                    ),
                ];
                break;
            case 'unbind':
                // Telegram 账户解绑
                $this->allow_edit_message = false;
                $text = 'ایمیل **/unbind حساب** را برای unbind ارسال کنید.';
                if (Config::obtain('telegram_unbind_kick_member')) {
                    $text .= PHP_EOL . PHP_EOL . 'با توجه به تنظیمات مدیر، حساب بدون لینک شما به طور خودکار از گروه کاربری حذف می شود.';
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
                    'text' => 'اگر قبلاً در گروه کاربری هستید، لطفاً به دلخواه برای رفع انسداد کلیک نکنید، در غیر این صورت از گروه حذف خواهید شد.',
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => json_encode(
                        [
                            'inline_keyboard' => [
                                [
                                    [
                                        'text' => 'برای رفع انسداد روی گزینه ارسال کلیک کنید',
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
                Message::sendPost(
                    'unbanChatMember',
                    [
                        'chat_id' => Config::obtain('telegram_chatid'),
                        'user_id' => $this->trigger_user['id'],
                    ]
                );

                $this->answerCallbackQuery([
                    'text' => 'برای رفع انسداد ارسال شده است، اگر هنوز نمی توانید به گروه بپیوندید، لطفاً با سرپرست تماس بگیرید.',
                    'show_alert' => true,
                ]);

                break;
            default:
                $temp = $this->getUserEditKeyboard();
                $text = 'در اینجا می توانید مشخصات یا اطلاعات اتصال خود را ویرایش کنید：' . PHP_EOL . PHP_EOL;
                $text .= 'پورت：' . $this->user->port . PHP_EOL;
                $text .= 'کلمه عبور：' . $this->user->passwd . PHP_EOL;
                $text .= 'رمزگذاری：' . $this->user->method;

                $sendMessage = [
                    'text' => $text,
                    'disable_web_page_preview' => false,
                    'reply_to_message_id' => null,
                    'reply_markup' => json_encode(
                        [
                            'inline_keyboard' => $temp['keyboard'],
                        ]
                    ),
                ];

                break;
        }

        if (!isset($sendMessage['parse_mode'])) {
            $sendMessage['parse_mode'] = 'HTML';
        }

        $this->replyWithMessage($sendMessage);
    }

    public function getUserSubscribeKeyboard(): array
    {
        $text = 'نوع لینک اشتراکی که می خواهید استفاده کنید را انتخاب کنید:';
        $text .= PHP_EOL . PHP_EOL;
        $text .= "پشتیبانی : ". $_ENV['adminLink'];

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
                [
                    'text' => 'SIP008',
                    'callback_data' => 'user.subscribe|sip008',
                ],
            ],
            [
                [
                    'text' => 'SingBox',
                    'callback_data' => 'user.subscribe|singbox',
                ],
                [
                    'text' => 'V2RayJson',
                    'callback_data' => 'user.subscribe|v2rayjson',
                ],
                [
                    'text' => 'Shadowsocks',
                    'callback_data' => 'user.subscribe|ss',
                ],
            ],
            [
                [
                    'text' => 'SIP002',
                    'callback_data' => 'user.subscribe|sip002',
                ],
                [
                    'text' => 'V2Ray',
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
                    'callback_data' => 'back',
                ],
            ],
        ];

        if (!Config::obtain('enable_ss_sub')) {
            unset($keyboard[0][2]);
            unset($keyboard[1][1]);
            unset($keyboard[1][2]);
        }

        if (!Config::obtain('enable_v2_sub')) {
            unset($keyboard[2][0]);
        }

        if (!Config::obtain('enable_trojan_sub')) {
            unset($keyboard[2][1]);
        }

        return [
            'text' => $text,
            'keyboard' => array_values($keyboard),
        ];
    }

    /**
     * 用户订阅
     *
     * @throws TelegramSDKException|GuzzleException
     */
    public function userSubscribe(): void
    {
        $CallbackDataExplode = explode('|', $this->callback_data);
        // 订阅中心
        if (isset($CallbackDataExplode[1])) {
            $temp = [];

            $temp['keyboard'] = [
                [
                    [
                        'text' => 'بازگشت به منوی اصلی',
                        'callback_data' => 'back',
                    ],
                    [
                        'text' => 'بازگشت به صفحه قبل',
                        'callback_data' => 'user.subscribe',
                    ],
                ],
            ];

            $sendMessage = [];

            $UniversalSub_Url = Subscribe::getUniversalSubLink($this->user);

            $text = match ($CallbackDataExplode[1]) {
                'json' => 'Json آدرس اشتراک:' . PHP_EOL . PHP_EOL .
                    '<code>' . $UniversalSub_Url . '/json</code>' . PHP_EOL . PHP_EOL,
                'clash' => 'Clash آدرس اشتراک:' . PHP_EOL . PHP_EOL .
                    '<code>' . $UniversalSub_Url . '/clash</code>' . PHP_EOL . PHP_EOL,
                'singbox' => 'SingBox آدرس اشتراک:' . PHP_EOL . PHP_EOL .
                    '<code>' . $UniversalSub_Url . '/singbox</code>' . PHP_EOL . PHP_EOL,
                'v2rayjson' => 'V2RayJson آدرس اشتراک:' . PHP_EOL . PHP_EOL .
                    '<code>' . $UniversalSub_Url . '/v2rayjson</code>' . PHP_EOL . PHP_EOL,
                'sip008' => 'SIP008 آدرس اشتراک:' . PHP_EOL . PHP_EOL .
                    '<code>' . $UniversalSub_Url . '/sip008</code>' . PHP_EOL . PHP_EOL,
                'ss' => 'Shadowsocks آدرس های اشتراک :' . PHP_EOL . PHP_EOL .
                    '<code>' . $UniversalSub_Url . '/ss</code>' . PHP_EOL . PHP_EOL,
                'sip002' => 'SIP002 آدرس های اشتراک :' . PHP_EOL . PHP_EOL .
                    '<code>' . $UniversalSub_Url . '/sip002</code>' . PHP_EOL . PHP_EOL,
                'v2' => 'V2Ray آدرس های اشتراک :' . PHP_EOL . PHP_EOL .
                    '<code>' . $UniversalSub_Url . '/v2ray</code>' . PHP_EOL . PHP_EOL,
                'trojan' => 'Trojan آدرس های اشتراک :' . PHP_EOL . PHP_EOL .
                    '<code>' . $UniversalSub_Url . '/trojan</code>' . PHP_EOL . PHP_EOL,
                default => 'پارامتر ناشناخته' . PHP_EOL . PHP_EOL,
            };

            $sendMessage = [
                'text' => $text,
                'disable_web_page_preview' => true,
                'reply_to_message_id' => null,
                'reply_markup' => json_encode(
                    [
                        'inline_keyboard' => $temp['keyboard'],
                    ]
                ),
            ];
        } else {
            $temp = $this->getUserSubscribeKeyboard();

            $sendMessage = [
                'text' => $temp['text'],
                'disable_web_page_preview' => false,
                'reply_to_message_id' => null,
                'reply_markup' => json_encode(
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

    public function getUserInviteKeyboard(): array
    {
        $paybacks_sum = (new Payback())->where('ref_by', $this->user->id)->sum('ref_get');

        if (is_null($paybacks_sum)) {
            $paybacks_sum = 0;
        }

        $invite = Config::getClass('ref');
        $currency = ResponseHelper::translateCurrency(Config::obtain('system_currency'));
        $text = [
            '<strong>برای هر <code>1</code> کاربر که دعوت به ثبت نام می کنید: </strong>',
            '',
            '- دریافت خواهید کرد <code>' . Config::obtain('invite_reg_traffic_reward') . 'G</code> پاداش ترافیک',
            '- طرف مقابل دریافت خواهد کرد <code>' . Config::obtain('invite_reg_money_reward') . '{$currency}</code> موجودی حساب',
            '- وقتی طرف مقابل صورت حساب را پرداخت کرد، مبلغ صورت حساب طرف مقابل را دریافت خواهید کرد. <code>' . Config::obtain('invite_reward_rate') * 100 . '%</code> از تخفیف ها',
            '',
            'تخفیف دریافت کرده است：' . $paybacks_sum . ' تومان。',
        ];

        $keyboard = [
            [
                [
                    'text' => 'لینک دعوت را دریافت کنید',
                    'callback_data' => 'user.invite.get',
                ],
            ],
            [
                [
                    'text' => 'بازگشت به منوی اصلی',
                    'callback_data' => 'back',
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
     *
     * @throws TelegramSDKException|GuzzleException
     */
    public function userInvite(): void
    {
        $CallbackDataExplode = explode('|', $this->callback_data);
        $Operate = explode('.', $CallbackDataExplode[0]);
        $OpEnd = end($Operate);

        if ($OpEnd === 'get') {
            $this->allow_edit_message = false;
            $code = (new InviteCode())->where('user_id', $this->user->id)->first();

            if ($code === null) {
                $code = (new InviteCode())->add($this->user->id);
            }

            $inviteUrl = $_ENV['baseUrl'] . '/auth/register?code=' . $code->code;
            $text = '<a href="' . $inviteUrl . '">' . $inviteUrl . '</a>';

            $sendMessage = [
                'text' => $text,
                'disable_web_page_preview' => false,
                'reply_to_message_id' => null,
                'reply_markup' => null,
            ];
        } else {
            $temp = $this->getUserInviteKeyboard();

            $sendMessage = [
                'text' => $temp['text'],
                'disable_web_page_preview' => false,
                'reply_to_message_id' => null,
                'reply_markup' => json_encode(
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

    /**
     * 每日签到
     *
     * @throws TelegramSDKException|GuzzleException
     */
    public function userCheckin(): void
    {
        if ($this->user->isAbleToCheckin()) {
            $traffic = Reward::issueCheckinReward($this->user->id);

            if (!$traffic) {
                $msg = 'ورود ناموفق بود';
            } else {
                $msg = 'برنده ' . $traffic . 'MB ترافیک.';
            }
        } else {
            $msg = 'شما امروز هدیه خود را دریافت کرده اید';
        }

        $this->answerCallbackQuery([
            'text' => $msg,
            'show_alert' => true,
        ]);
        // 回送信息
        if ($this->chat_id > 0) {
            $temp = self::getUserIndexKeyboard($this->user);
        } else {
            $temp['text'] = Message::getUserTitle($this->user);
            $temp['text'] .= PHP_EOL . PHP_EOL;
            $temp['text'] .= Message::getUserTrafficInfo($this->user);

            $temp['keyboard'] = [
                [
                    [
                        'text' => (!$this->user->isAbleToCheckin() ? 'signed in' : 'to sign in'),
                        'callback_data' => 'user.checkin.' . $this->trigger_user['id'],
                    ],
                ],
                [
                    [
                        'text' => 'بازگشت به منوی اصلی',
                        'callback_data' => 'back',
                    ],
                ]
            ];
        }

        $this->replyWithMessage([
            'text' => $temp['text'] . PHP_EOL . PHP_EOL . $msg,
            'reply_to_message_id' => $this->message_id,
            'parse_mode' => 'Markdown',
            'reply_markup' => json_encode(
                [
                    'inline_keyboard' => $temp['keyboard'],
                ]
            ),
        ]);
    }

    /**
     * return a message for register
     *
     */
    public static function getRegisterMessage()
    {
        return [
            'text' => 'لطفاً از لینک زیر برای ثبت‌نام استفاده کنید:',
            'reply_markup' => json_encode([
                'inline_keyboard' => [
                    [
                        ['text' => 'ثبت‌نام', 'web_app' => ['url' => $_ENV['baseUrl'] . '/auth/register']]
                    ]
                ]
            ])
        ];
    }
    public static function getUserNotFoundReply(): array
    {
        $text = "کاربر گرامی.";
        $text .= PHP_EOL;
        $text .= "شناسه تلگرام شما برای ما ناشناس است.";
        $text .= PHP_EOL;
        $text .= "لطفااز طریق گزینه های زیر یا عضو وب سایت ما شوید یا چنانچه قبلا عضو شده اید اکانت خود را به تلگرام متصل کنید";
        
        $userManage = [
            [
                [
                    'text' => 'ثبت‌نام',
                    'web_app' => ['url' => $_ENV['baseUrl'] . '/auth/register']
                ],
                [
                    'text' => 'لاگین',
                    'web_app' => ['url' => $_ENV['baseUrl'] . '/auth/login']
                ]
            ]
        ];
        return     [
            'text' => $text,
            'parse_mode' => 'Markdown',
            'disable_web_page_preview' => false,
            'reply_to_message_id' => null,
            'reply_markup' => json_encode(
                [
                    'inline_keyboard' =>  $userManage,
                ]
            ),
        ];
    }

    public static function getStartCommandReply($user): array
    {

        if (!$user) {
            $welcome = "کاربرگرامی. چنانچه از طریق وب سایت ثبت نام نموده اید  دکمه بایند ";
            $userManage = [
                [
                    [
                        'text' => 'ثبت‌نام',
                        'web_app' => ['url' => $_ENV['baseUrl'] . '/auth/register']
                    ],
                    [
                        'text' => 'لاگین',
                        'callback_data' => '/bind',
                    ]
                ]
            ];
        } else {
            $userManage = [

                [
                    [
                        'text' => "حساب من🥷🏿",
                        'callback_data' => 'user.index',
                    ],
                    [
                        'text' => '🍀خرید سرویس🍀',
                        'callback_data' => 'products.buy',
                    ]
                ],
                [
                    [
                        'text' =>  'افزایش موجودی💳',
                        'callback_data' => 'charge.account',
                    ]
                ],
                [
                    [
                        'text' =>  'دریافت حجم هدیه روزانه🎁',
                        'callback_data' => 'user.checkin.' . $user->im_value,
                    ]
                ]


            ];
        }

        $keyboard = [
            [
                [
                    'text' => 'نرم افزار ها🖥',
                    'callback_data' => 'software',
                ],
                /* [
                    'text' => 'راهنما ربات💡',
                    'callback_data' => '/help',
                ] */


            ],
           /*  [
                [
                    'text' => 'درباره ما',
                    'callback_data' => 'aboutus',
                ]

            ], */

        ];


        /*    $text = Message::getUserTitle($user);
        $text .= PHP_EOL . PHP_EOL;
        $text .= Message::getUserInfo($user); */

        /*  return [
            'text' => $text,
            'keyboard' => array_merge($keyboard,$userManage),
        ]; */
      
        $text = "دسترسی پرسرعت و بدون محدودیت را با ما تجربه کنید";
        $text .= PHP_EOL . PHP_EOL;
        $text .= "پشتیبانی : https://t.me/Magix\_admin";//. str_replace('_', '\_', $_ENV['adminLink']) ;
      
        $text .= PHP_EOL . PHP_EOL;
        return     [
            'text' => $message ?? $text,
            'parse_mode' => 'Markdown',
            'disable_web_page_preview' => false,
            'reply_to_message_id' => null,
            'reply_markup' => json_encode(
                [
                    'inline_keyboard' =>  array_merge($userManage, $keyboard),
                ]
            ),
        ];
    }
}

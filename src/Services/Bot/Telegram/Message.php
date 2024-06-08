<?php

declare(strict_types=1);

namespace App\Services\Bot\Telegram;

use App\Models\Config;
use App\Models\User;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Collection;
use Telegram\Bot\Api;
use Telegram\Bot\Exceptions\TelegramSDKException;
use function array_merge;
use function implode;
use function in_array;
use function json_decode;
use const PHP_EOL;

final class Message
{
    /**
     * Bot
     */
    private Api $bot;

    /**
     * 消息会话 ID
     */
    private $chat_id;

    /**
     * 触发源信息
     */
    private Collection $message;

    /**
     * 触发源信息 ID
     */
    private $message_id;

    /**
     * @throws TelegramSDKException|GuzzleException
     */
    public function __construct(Api $bot, Collection $message)
    {
        $this->bot = $bot;
        $this->chat_id = $message->getChat()->getId();
        $this->message = $message;
        $this->message_id = $message->getMessageId();

        if ($this->message->getNewChatParticipant() !== null) {
            $this->newChatParticipant();
        }
        $state = PersistedInfo::getTelegramBotState($this->message->getFrom->getId());
        if ($state != null){
        $user = PersistedInfo::getUser($this->message->getFrom->getId());
            
        if ( $state->state == 'waiting_for_giftcard') {
            $this->evaluteGiftCard($user);
        }else if ($state->state == 'waiting_for_tether') {
            $this->evaluteTetherTran();
        }
    }
    }
    public function evaluteGiftCard($user){
        $gift=PersistedInfo::applyGiftCard($this->message->getText(),$user);
        if($gift==null){
            $msg = 'کارت هدیه نامعتبر است';
        }else{
            $msg =  'شارژ مجدد با موفقیت انجام شد'; 
        }
        $keyBoard = [
            [
                [
                    'text' => 'بازگشت به منوی اصلی',
                    'callback_data' => 'back',
                ],
            ]

        ];
        $this->replyWithMessage([
            'text' => $text,
            'parse_mode' => 'HTML',
            'disable_web_page_preview' => false,
            'reply_to_message_id' => null,
            'reply_markup' => json_encode(
                [
                    'inline_keyboard' => $keyBoard,
                ]
            ),
        ])

    }
     public function evaluteTetherTran(){

    }

    /**
     * 回复讯息 | 默认已添加 chat_id 和 message_id
     *
     * @param array $send_message
     *
     * @throws TelegramSDKException
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

        $this->bot->sendMessage($send_message);
    }

    /**
     * 入群检测
     *
     * @throws TelegramSDKException
     * @throws GuzzleException
     */
    public function newChatParticipant(): void
    {
        $new_chat_member = $this->message->getNewChatParticipant();

        $member = [
            'id' => $new_chat_member->getId(),
            'name' => $new_chat_member->getFirstName() . ' Message.php' . $new_chat_member->getLastName(),
        ];

        if ($new_chat_member->getUsername() === Config::obtain('telegram_bot')) {
            // 机器人加入新群组
            if (
                !Config::obtain('allow_to_join_new_groups')
                &&
                !in_array($this->chat_id, json_decode(Config::obtain('group_id_allowed_to_join')))
            ) {
                // 退群

                $this->replyWithMessage(
                    [
                        'text' => 'خطای عجیب',
                    ]
                );

                self::sendPost(
                    'kickChatMember',
                    [
                        'chat_id' => $this->chat_id,
                        'user_id' => $member['id'],
                    ]
                );
            } else {
                $this->replyWithMessage(
                    [
                        'text' => 'خطای عجیب تر',
                    ]
                );
            }
        } else {
            // 新成员加入群组
            $new_user = PersistedInfo::getUser($member['id']);

            if (
                Config::obtain('telegram_group_bound_user')
                &&
                $this->chat_id === Config::obtain('telegram_chatid')
                &&
                $new_user === null
                &&
                !$new_chat_member->isBot()
            ) {
                $this->replyWithMessage(
                    [
                        'text' => 'زیرا ' . $member['name'] . ' حساب های بدون محدودیت حذف خواهند شد.',
                    ]
                );

                self::sendPost(
                    'kickChatMember',
                    [
                        'chat_id' => $this->chat_id,
                        'user_id' => $member['id'],
                    ]
                );

                return;
            }

            if (Config::obtain('enable_welcome_message')) {
                $text = ($new_user->class > 0 ? 'به VIP ها خوش آمدید' . $new_user->class .
                    ' کاربر ' . $member['name'] . 'به گروه ملحق بشید.' : 'خوش آمدی ' . $member['name']);

                $this->replyWithMessage(
                    [
                        'text' => $text,
                    ]
                );
            }
        }
    }

    /**
     * 用户的流量使用讯息
     */
    public static function getUserTrafficInfo(User $user): string
    {
        $text = [
            'وضعیت ترافیک فعلی شما: ',
            '',
            'استفاده امروز ' . $user->todayUsedTrafficPercent() . '% ：' . $user->todayUsedTraffic(),
            'قبلا استفاده شده ' . $user->lastUsedTrafficPercent() . '% ：' . $user->lastUsedTraffic(),
            'ترافیک تقریبی باقیمانده ' . $user->unusedTrafficPercent() . '% ：' . $user->unusedTraffic(),
        ];

        return implode(PHP_EOL, $text);
    }

    /**
     * 用户基本讯息
     */
    public static function getUserInfo(User $user): string
    {
        $text = [
            'موجودی فعلی：' . $user->money,
            'سرعت درگاه：' . ($user->node_speedlimit > 0 ? $user->node_speedlimit . 'Mbps' : 'بدون محدودیت'),
            'آخرین استفاده:' . $user->lastUseTime(),
            'انقضاء:' . $user->class_expire,
        ];

        return implode(PHP_EOL, $text);
    }

    /**
     * 获取用户或管理的尊称
     */
    public static function getUserTitle(User $user): string
    {
        if ($user->class > 0) {
            $text = 'VIP عزیز ' . $user->class . ' سلام：';
        } else {
            $text = 'سلام ' . $user->username . 'عزیز：';
        }

        return $text;
    }

    /**
     * Sends a POST request to Telegram Bot API.
     * 伪异步，无结果返回.
     *
     * @param $method
     * @param $params
     *
     * @throws GuzzleException
     */
    public static function sendPost($method, $params): void
    {
        $client = new Client();

        $telegram_api_url = 'https://api.telegram.org/bot' . Config::obtain('telegram_token') . '/' . $method;

        $headers = [
            'Content-Type' => 'application/json; charset=utf-8',
        ];

        $client->post(
            $telegram_api_url,
            [
                'headers' => $headers,
                'json' => $params,
                'timeout' => 10,
            ]
        );
    }
}

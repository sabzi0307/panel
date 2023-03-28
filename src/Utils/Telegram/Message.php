<?php

declare(strict_types=1);

namespace App\Utils\Telegram;

use App\Models\Setting;
use App\Utils\Telegram;
use Telegram\Bot\Api;
use Telegram\Bot\Exceptions\TelegramSDKException;
use function count;
use function in_array;
use function json_decode;
use function strlen;

final class Message
{
    /**
     * Bot
     */
    private Api $bot;

    /**
     * 触发用户TG信息
     */
    private array $triggerUser;

    /**
     * 消息会话 ID
     */
    private $ChatID;

    /**
     * 触发源信息
     */
    private \Telegram\Bot\Objects\Message $Message;

    /**
     * 触发源信息 ID
     */
    private $MessageID;

    /**
     * @throws TelegramSDKException
     */
    public function __construct(Api $bot, \Telegram\Bot\Objects\Message $Message)
    {
        $this->bot = $bot;
        $this->triggerUser = [
            'id' => $Message->getFrom()->getId(),
            'name' => $Message->getFrom()->getFirstName() . ' ' . $Message->getFrom()->getLastName(),
            'username' => $Message->getFrom()->getUsername(),
        ];
        $this->User = TelegramTools::getUser($this->triggerUser['id']);
        $this->ChatID = $Message->getChat()->getId();
        $this->Message = $Message;
        $this->MessageID = $Message->getMessageId();

        if ($this->Message->getText() !== null) {
            // 消息内容
            $MessageData = trim($this->Message->getText());
            if ($this->ChatID > 0 && strlen($MessageData) === 16) {
                // 私聊
                $Uid = Telegram::verifyBindSession($MessageData);
                if ($Uid === 0) {
                    $text = 'اتصال ناموفق بود، پس از بررسی، مشخص شد که：【' . $MessageData . '】به مدت 10 دقیقه معتبر است، می توانید پس از بازخوانی صفحه **ویرایش نمایه** در وب سایت ما دوباره امتحان کنید.';
                } else {
                    $BinsUser = TelegramTools::getUser($Uid, 'id');
                    $BinsUser->telegram_id = $this->triggerUser['id'];
                    $BinsUser->im_type = 4;
                    $BinsUser->im_value = $this->triggerUser['username'];
                    $BinsUser->save();
                    if ($BinsUser->is_admin >= 1) {
                        $text = '**مدیر محترم** سلام، اتثال موفق را تبریک می گویم.' . PHP_EOL . 'آدرس ایمیل فعلی محدود شده است：' . $BinsUser->email;
                    } else {
                        if ($BinsUser->class >= 1) {
                            $text = '**VIP عزیز' . $BinsUser->class . '** سلام کاربر.' . PHP_EOL . 'اتصال موفقیت آمیز شما را تبریک می گویم، آدرس ایمیل محدود فعلی است：' . $BinsUser->email;
                        } else {
                            $text = 'اتصال موفقیت آمیز است، ایمیل شما درست است：' . $BinsUser->email;
                        }
                    }
                }

                $this->bot->sendMessage(
                    [
                        'chat_id' => $this->ChatID,
                        'text' => $text,
                        'parse_mode' => 'Markdown',
                    ]
                );
            }
            return;
        }

        if ($this->Message->getNewChatParticipant() !== null) {
            $this->newChatParticipant();
        }
    }

    /**
     * 回复讯息 | 默认已添加 chat_id 和 message_id
     *
     * @param array $sendMessage
     *
     * @throws TelegramSDKException
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
        $this->bot->sendMessage($sendMessage);
    }

    /**
     * 入群检测
     *
     * @throws TelegramSDKException
     * @throws TelegramSDKException
     * @throws TelegramSDKException
     * @throws TelegramSDKException
     * @throws TelegramSDKException
     */
    public function newChatParticipant(): void
    {
        $NewChatMember = $this->Message->getNewChatParticipant();
        $Member = [
            'id' => $NewChatMember->getId(),
            'name' => $NewChatMember->getFirstName() . ' ' . $NewChatMember->getLastName(),
        ];
        if ($NewChatMember->getUsername() === $_ENV['telegram_bot']) {
            // 机器人加入新群组
            if (Setting::obtain('allow_to_join_new_groups') !== true && ! in_array($this->ChatID, json_decode(Setting::obtain('group_id_allowed_to_join')))) {
                // 退群

                $this->replyWithMessage(
                    [
                        'text' => 'بدون تاریخ.',
                    ]
                );

                TelegramTools::sendPost(
                    'kickChatMember',
                    [
                        'chat_id' => $this->ChatID,
                        'user_id' => $Member['id'],
                    ]
                );
                if (count(json_decode(Setting::obtain('telegram_admins'))) >= 1) {
                    foreach (json_decode(Setting::obtain('telegram_admins')) as $id) {
                        $this->bot->sendMessage(
                            [
                                'text' => 'ربات یک گروه را بر اساس تنظیمات شما ترک کرد.' . PHP_EOL . PHP_EOL . 'اسم گروه：' . $this->Message->getChat()->getTitle(),
                                'chat_id' => $id,
                            ]
                        );
                    }
                }
            } else {
                $this->replyWithMessage(
                    [
                        'text' => 'میمون',
                    ]
                );
            }
        } else {
            // 新成员加入群组
            $NewUser = TelegramTools::getUser($Member['id']);
            $deNewChatMember = json_decode($NewChatMember, true);
            if (
                Setting::obtain('telegram_group_bound_user') === true
                &&
                $this->ChatID === $_ENV['telegram_chatid']
                &&
                $NewUser === null
                &&
                $deNewChatMember['is_bot'] === false
            ) {
                $this->replyWithMessage(
                    [
                        'text' => 'زیرا ' . $Member['name'] . ' حساب بدون محدودیت حذف خواهد شد。',
                    ]
                );

                TelegramTools::sendPost(
                    'kickChatMember',
                    [
                        'chat_id' => $this->ChatID,
                        'user_id' => $Member['id'],
                    ]
                );
                return;
            }
            if (Setting::obtain('enable_welcome_message') === true) {
                $text = ($NewUser->class >= 1 ? 'به VIP ها خوش آمدید' . $NewUser->class . ' کاربر ' . $Member['name'] . 'به گروه ملحق بشید.' : 'خوش آمدی ' . $Member['name']);

                $this->replyWithMessage(
                    [
                        'text' => $text,
                    ]
                );
            }
        }
    }
}

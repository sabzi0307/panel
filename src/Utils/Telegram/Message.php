<?php

declare(strict_types=1);

namespace App\Utils\Telegram;

use App\Models\Setting;
use App\Utils\TelegramSessionManager;

final class Message
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
     * 消息会话 ID
     */
    private $ChatID;

    /**
     * 触发源信息
     */
    private $Message;

    /**
     * 触发源信息 ID
     */
    private $MessageID;

    public function __construct(\Telegram\Bot\Api $bot, \Telegram\Bot\Objects\Message $Message)
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
            if ($this->ChatID > 0) {
                // 私聊
                if ($this->User !== null) {
                    if (is_numeric($MessageData) && strlen((string) $MessageData) === 6) {
                        $uid = TelegramSessionManager::verifyLoginNumber($MessageData, $this->User->id);
                        if ($uid !== 0) {
                            $text = 'تأیید ورود با موفقیت، ایمیل：' . $this->User->email;
                        } else {
                            $text = 'تأیید ورود ناموفق بود، شماره نامعتبر است';
                        }
                        $bot->sendMessage(
                            [
                                'chat_id' => $this->ChatID,
                                'text' => $text,
                                'parse_mode' => 'Markdown',
                            ]
                        );
                    }
                } else {
                    if (strlen($MessageData) === 16) {
                        $Uid = TelegramSessionManager::verifyBindSession($MessageData);
                        if ($Uid === 0) {
                            $text = 'اتصال شکست خورد، پس از بازرسی، مشخص شد که：【' . $MessageData . '】به مدت 10 دقیقه معتبر است، می توانید پس از تازه کردن صفحه **ویرایش نمایه** در وب سایت ما دوباره امتحان کنید.';
                        } else {
                            $BinsUser = TelegramTools::getUser($Uid, 'id');
                            $BinsUser->telegram_id = $this->triggerUser['id'];
                            $BinsUser->im_type = 4;
                            $BinsUser->im_value = $this->triggerUser['username'];
                            $BinsUser->save();
                            if ($BinsUser->is_admin >= 1) {
                                $text = '**مدیر محترم** سلام، اتصال موفق را تبریک می گویم.' . PHP_EOL . 'آدرس ایمیل محدود فعلی است：' . $BinsUser->email;
                            } else {
                                if ($BinsUser->class >= 1) {
                                    $text = 'عزیز **VIP ' . $BinsUser->class . '** سلام کاربر.' . PHP_EOL . 'اتصال موفقیت آمیز شما را تبریک می گویم، آدرس ایمیل محدود فعلی است：' . $BinsUser->email;
                                } else {
                                    $text = 'اتصال به ایمیل شما با موفقیت انجام شد،：' . $BinsUser->email;
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
                }
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
     */
    public function newChatParticipant(): void
    {
        $NewChatMember = $this->Message->getNewChatParticipant();
        $Member = [
            'id' => $NewChatMember->getId(),
            'name' => $NewChatMember->getFirstName() . ' ' . $NewChatMember->getLastName(),
            'username' => $NewChatMember->getUsername(),
        ];
        if ($NewChatMember->getUsername() === $_ENV['telegram_bot']) {
            // 机器人加入新群组
            if (Setting::obtain('allow_to_join_new_groups') !== true && ! \in_array($this->ChatID, \json_decode(Setting::obtain('group_id_allowed_to_join')))) {
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
                if (count(\json_decode(Setting::obtain('telegram_admins'))) >= 1) {
                    foreach (\json_decode(Setting::obtain('telegram_admins')) as $id) {
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
            $deNewChatMember = \json_decode($NewChatMember, true);
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

<?php

declare(strict_types=1);

namespace App\Services\Bot\Telegram\Commands;

use App\Models\Config;
use App\Models\User;
use App\Services\Bot\Telegram\Callback;
use App\Services\Bot\Telegram\Message;
use App\Services\Bot\Telegram\PersistedInfo;
use Telegram\Bot\Actions;
use Telegram\Bot\Commands\Command;
use function json_encode;
use const PHP_EOL;

/**
 * Class MyCommand.
 */
final class MyCommand extends Command
{
    /**
     * @var string Command Name
     */
    protected string $name = 'my';

    /**
     * @var string Command Description
     */
    //protected string $description = '[چت گروهی/خصوصی] اطلاعات شخصی من.';
    protected string $description = '';

    /**
     * {@inheritdoc}
     */
    public function handle()
    {
        $update = $this->getUpdate();
        $message = $update->getMessage();
        // 消息 ID
        $message_id = $message->getMessageId();
        // 消息会话 ID
        $chat_id = $message->getChat()->getId();

        if ($chat_id < 0) {
            if (Config::obtain('telegram_group_quiet')) {
                // 群组中不回应
                return null;
            }
            if ($chat_id !== Config::obtain('telegram_chatid')) {
                // 非我方群组
                return null;
            }
        }

        // 发送 '输入中' 会话状态
        $this->replyWithChatAction(['action' => Actions::TYPING]);

        // 触发用户
        $send_user = [
            'id' => $message->getFrom()->getId(),
            'name' => $message->getFrom()->getFirstName() . ' MyCommand.php' . $message->getFrom()->getLastName(),
            'username' => $message->getFrom()->getUsername(),
        ];
        $user = PersistedInfo::getUser($send_user['id']);
        if ($user === null) {
            
           return $this->replyWithMessage(Callback::getUserNotFoundReply());
        } else {
            $reply = Callback::getUserIndexKeyboard($user);
        }

        // 回送信息
        return $this->replyWithMessage(
            [
                'text' => $reply['text'] ?? 'Hi!',
                'parse_mode' => 'Markdown',
                'disable_web_page_preview' => false,
                'reply_to_message_id' => null,
                'reply_markup' => json_encode(
                    [
                        'inline_keyboard' => $reply['keyboard'] ?? [],
                    ]
                ),
            ]
        );

    
    }

    public function group($user, $send_user, $chat_id, $message, $message_id)
    {
        $text = Message::getUserTitle($user);
        $text .= PHP_EOL . PHP_EOL;
        $text .= Message::getUserTrafficInfo($user);
        // 回送信息
        return $this->replyWithMessage(
            [
                'text' => $text,
                'parse_mode' => 'Markdown',
                'reply_to_message_id' => $message_id,
                'reply_markup' => json_encode(
                    [
                        'inline_keyboard' => [
                            [
                                [
                                    'text' => (!$user->isAbleToCheckin() ? 'وارد شده است' : 'بررسی کنید'),
                                    'callback_data' => 'user.checkin.' . $send_user['id'],
                                ],
                            ],
                        ],
                    ]
                ),
            ]
        );
    }
}

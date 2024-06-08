<?php

declare(strict_types=1);

namespace App\Services\Bot\Telegram\Commands;

use App\Models\User;
use App\Models\Config;
use App\Services\Bot\Telegram\Callback;
use Telegram\Bot\Actions;
use Telegram\Bot\Commands\Command;
use App\Services\Bot\Telegram\PersistedInfo;

/**
 * Class StratCommand.
 */
final class StartCommand extends Command
{
    /**
     * @var string Command Name
     */
    protected string $name = 'start';

    /**
     * @var string Command Description
     */
    protected string $description = '[چت گروهی/خصوصی] دستور اولیه ربات.';

    public function handle(): void
    {
        $update = $this->getUpdate();
        $message = $update->getMessage();
        // 消息会话 ID
        $chat_id = $message->getChat()->getId();

        if ($chat_id > 0) {
            // 发送 '输入中' 会话状态
            $this->replyWithChatAction(['action' => Actions::TYPING]);
            // 回送信息
            $send_user = [
                'id' => $message->getFrom()->getId(),
                'name' => $message->getFrom()->getFirstName() . ' StartCommand.php' . $message->getFrom()->getLastName(),
                'username' => $message->getFrom()->getUsername(),
            ];
            $user = PersistedInfo::getUser($send_user['id']);
            $this->replyWithMessage( Callback::getStartCommandReply($user));
        } else {
            if (!Config::obtain('telegram_group_quiet')) {
                // 发送 '输入中' 会话状态
                $this->replyWithChatAction(['action' => Actions::TYPING]);
                // 回送信息
                $this->replyWithMessage(
                    [
                        'text' => 'میو میو میو.',
                        'parse_mode' => 'Markdown',
                        'reply_to_message_id' => $message->getMessageId(),
                    ]
                );
            }
        }
    }

}

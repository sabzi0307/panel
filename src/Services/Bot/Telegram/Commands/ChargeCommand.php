<?php

declare(strict_types=1);

namespace App\Services\Bot\Telegram\Commands;

use App\Services\Bot\Telegram\Callback;
use App\Services\Bot\Telegram\Message;
use App\Services\Bot\Telegram\PersistedInfo;
use Telegram\Bot\Actions;
use Telegram\Bot\Commands\Command;
use function json_encode;

/**
 * Class MenuCommand.
 */
final class ChargeCommand extends Command
{
    /**
     * @var string Command Name
     */
    protected string $name = 'charge';

    /**
     * @var string Command Description
     */
    protected string $description = 'امکان افزایش موجودی از طریق پرداخت رمز ارز تتر در شبکه بایننس';

    /**
     * {@inheritdoc}
     */
    public function handle()
    {
        $update = $this->getUpdate();
        $message = $update->getMessage();

        // 消息会话 ID
        $chat_id = $message->getChat()->getId();

        if ($chat_id > 0) {
            // 私人会话

            // 发送 '输入中' 会话状态
            $this->replyWithChatAction(['action' => Actions::TYPING]);

            // 触发用户
            $send_user = [
                'id' => $message->getFrom()->getId(),
            ];
            $reply = [];
            $user = PersistedInfo::getUser($send_user['id']);
            if ($user != null) {
                $reply = Callback::getChargeReply($user);
            }

            // 回送信息
            return $this->replyWithMessage($reply);
        }
    }
}

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
final class ProductCommand extends Command
{
    /**
     * @var string Command Name
     */
    protected string $name = 'product';

    /**
     * @var string Command Description
     */
    protected string $description = 'لیست پلن های فیلترشکن برای فروش';

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


            $user = PersistedInfo::getUser($send_user['id']);
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
                            'text' => $p->name,
                            'callback_data' => 'buy.' . $p->id,
                        ]
                    ],
                    $keyBoard
                );
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

        return null;
    }
}

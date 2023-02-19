<?php

declare(strict_types=1);

namespace App\Utils\Telegram\Commands;

use App\Models\Setting;
use Telegram\Bot\Actions;
use Telegram\Bot\Commands\Command;

/**
 * Class PingCommand.
 */
final class PingCommand extends Command
{
    /**
     * @var string Command Name
     */
    protected $name = 'ping';

    /**
     * @var string Command Description
     */
    protected $description = '[چت گروهی/خصوصی] یک شناسه منحصر به فرد برای من یا یک گروه دریافت کنید.';

    public function handle(): void
    {
        $Update = $this->getUpdate();
        $Message = $Update->getMessage();

        // 消息会话 ID
        $ChatID = $Message->getChat()->getId();

        if ($ChatID > 0) {
            // 私人会话

            // 发送 '输入中' 会话状态
            $this->replyWithChatAction(['action' => Actions::TYPING]);

            $text = [
                'Pong！',
                'شناسنامه شما هست ' . $ChatID . '.',
            ];

            // 回送信息
            $this->replyWithMessage(
                [
                    'text' => implode(PHP_EOL, $text),
                    'parse_mode' => 'Markdown',
                ]
            );
        } else {
            if (Setting::obtain('telegram_group_quiet') === true) {
                // 群组中不回应
                return;
            }

            // 发送 '输入中' 会话状态
            $this->replyWithChatAction(['action' => Actions::TYPING]);

            $text = [
                'Pong！',
                'شناسنامه شما هست ' . $Message->getFrom()->getId() . '.',
                'شناسه این گروه است ' . $ChatID . '.',
            ];

            // 回送信息
            $this->replyWithMessage(
                [
                    'text' => implode(PHP_EOL, $text),
                ]
            );
        }
    }
}

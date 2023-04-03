<?php

declare(strict_types=1);

namespace App\Utils\Telegram\Commands;

use App\Models\Setting;
use Telegram\Bot\Actions;
use Telegram\Bot\Commands\Command;

/**
 * Class HelpCommand.
 */
final class HelpCommand extends Command
{
    /**
     * @var string Command Name
     */
    protected string $name = 'help';

    /**
     * @var string Command Description
     */
    protected string $description = '[چت گروهی/خصوصی] تمامی دستورات موجود در سیستم.';

    public function handle(): void
    {
        $Update = $this->getUpdate();
        $Message = $Update->getMessage();
        if ($Message->getChat()->getId() < 0 && Setting::obtain('telegram_group_quiet') === true) {
            return;
        }
        if (! preg_match('/^\/help\s?(@' . $_ENV['telegram_bot'] . ')?.*/i', $Message->getText()) && Setting::obtain('help_any_command') === false) {
            return;
        }
        $this->replyWithChatAction(['action' => Actions::TYPING]);
        $commands = $this->telegram->getCommands();
        $text = 'تمامی دستورات موجود در سیستم';
        $text .= PHP_EOL . PHP_EOL;
        foreach ($commands as $name => $handler) {
            $text .= '/' . $name . PHP_EOL . '`    - ' . $handler->getDescription() . '`' . PHP_EOL;
        }
        $this->replyWithMessage(
            [
                'text' => $text,
                'parse_mode' => 'Markdown',
                'disable_web_page_preview' => false,
                'reply_to_message_id' => $Message->getMessageId(),
                'reply_markup' => null,
            ]
        );
    }
}

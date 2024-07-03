<?php

declare(strict_types=1);

namespace App\Services\Bot\Telegram;

use App\Models\Config;
use Aws\Command;
use GuzzleHttp\Exception\GuzzleException;
use MaxMind\Db\Reader\InvalidDatabaseException;
use Psr\Http\Message\RequestInterface;
use Telegram\Bot\Api;
use Telegram\Bot\Exceptions\TelegramSDKException;

final class Telegram
{
    /**
     * @throws InvalidDatabaseException
     * @throws TelegramSDKException
     * @throws GuzzleException
     */
    public static function process(RequestInterface $request): void
    {
        $bot = new Api(Config::obtain('telegram_token'));

        $bot->addCommands([
            new Commands\ChargeCommand(),
            new Commands\ProductCommand(),
            new Commands\MyCommand(),
            new Commands\HelpCommand(),
            new Commands\PingCommand(),
            new Commands\StartCommand(),
            new Commands\UnbindCommand(),
            new Commands\CheckinCommand(),
        ]);

        $bot->commandsHandler(true, $request);
        $bot->setConnectTimeOut(10);
        $update = $bot->getWebhookUpdate();
        if ($update->has('callback_query')) {
            $callback=$update->getCallbackQuery();
            PersistedInfo::logTelegramBotState($callback->getFrom()->getId(), 'received-C', $callback->getData(), true);         
            new Callback($bot,$callback);           
            PersistedInfo::logTelegramBotState($callback->getFrom()->getId(), 'responed-C', $callback->getData());
         
        } elseif ($update->has('message')) {
            $message=$update->getMessage();
            PersistedInfo::logTelegramBotState($message->getFrom()->getId(), 'received-M', $message->getText(), true); 
            new Message($bot,$message );
            PersistedInfo::logTelegramBotState($message->getFrom()->getId(), 'responed-M', $message->getText());
        }
    }
}

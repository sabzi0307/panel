<?php

declare(strict_types=1);

namespace App\Services\Bot\Telegram\Commands;

use App\Services\Bot\Telegram\Callback;
use App\Services\Bot\Telegram\Message;
use App\Services\Bot\Telegram\PersistedInfo;
use Exception;
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
            /*   try {
                $reply = Callback::productsReply(PersistedInfo::getUser($send_user['id']));
            } catch (Exception $e) {
                $reply = [];
            } */
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
                            [
                                'text' => $p->name . ': ' . $p->price . '$',
                                'callback_data' => 'buy.' . $p->id,
                            ]
                        ]
                    ],
                    $keyBoard
                );
            }
            if ($user != null) {
                $text = " کاربرگرامی، موجودی حساب شما" . $user->money . " است";
                $text .= PHP_EOL . PHP_EOL;
                $text .= "در صورتی که موجودی حساب شما برای خرید کافی نباشد به منو افزایش موجودی متصل میشوید";
                $text .= PHP_EOL . PHP_EOL;
                $text .= "امکان افزایش موجودی از طریق انتقال تتر در شبکه باینسس از طریق بات فراهم هست.  ";
                $text .= PHP_EOL . PHP_EOL;
                $text .= " چنانچه قصد اقزایش موجودی از طریق پرفکت مانی را دارید از وب سایت ما استفاده کنید  ";
                $text .= PHP_EOL . PHP_EOL;
                $text .= $_ENV['baseUrl'];
            }

            if ($user === null) {
                $text = "کاربر گرامی.";
                $text .= PHP_EOL;
                $text .= "شناسه تلگرام شما برای ما ناشناس است.";
                $text .= PHP_EOL;
                $text .= "لطفا از طریق منوی استارت لاگین کنید یا عضو شوید";
            }
            $reply= [
                'text' => $text,
                'keyboard' => $keyBoard
            ];
            return $this->replyWithMessage([
                'text' => $reply['text'] ?? 'Hi!',
                'parse_mode' => 'Markdown',
                'disable_web_page_preview' => false,
                'reply_to_message_id' => null,
                'reply_markup' => json_encode(
                    [
                        'inline_keyboard' => $reply['keyboard'] ?? [],
                    ]
                ),
            ]);
        }


        // 回送信息

    }
}

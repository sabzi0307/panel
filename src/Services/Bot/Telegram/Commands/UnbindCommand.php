<?php

declare(strict_types=1);

namespace App\Services\Bot\Telegram\Commands;

use App\Models\Config;
use App\Services\Bot\Telegram\PersistedInfo;
use Telegram\Bot\Actions;
use Telegram\Bot\Commands\Command;
use Telegram\Bot\Exceptions\TelegramSDKException;
use function array_splice;
use function explode;
use function trim;
use const PHP_EOL;

/**
 * Class UnbindCommand.
 */
final class UnbindCommand extends Command
{
    /**
     * @var string Command Name
     */
    protected string $name = 'unbind';

    /**
     * @var string Command Description
     */
    protected string $description = '[چت خصوصی] حساب را لغو پیوند کنید.';

    /**
     * @throws TelegramSDKException
     */
    public function handle(): void
    {
        $update = $this->getUpdate();
        $message = $update->getMessage();
        // 消息会话 ID
        $chat_id = $message->getChat()->getId();
        // 触发用户
        $send_user = [
            'id' => $message->getFrom()->getId(),
        ];
        $user = PersistedInfo::getUser($send_user['id']);

        if ($chat_id > 0) {
            // 发送 '输入中' 会话状态
            $this->replyWithChatAction(['action' => Actions::TYPING]);

            if ($user === null) {
                // 回送信息
                $this->replyWithMessage(
                    [
                        'text' => Config::obtain('user_not_bind_reply'),
                        'parse_mode' => 'Markdown',
                    ]
                );
                return;
            }

            // 消息内容
            $message_text = explode(' ', trim($message->getText()));
            $message_key = array_splice($message_text, -1)[0];
            $text = '';

            if ($message_key === $user->email) {
                if ($user->unbindIM()) {
                    $text = 'حساب با موفقیت لغو لینک شد.';
                    if (Config::obtain('telegram_unbind_kick_member')) {
                        $this->telegram->banChatMember(
                            [
                                'chat_id' => Config::obtain('telegram_chatid'),
                                'user_id' => $send_user['id'],
                            ]
                        );
                    }
                } else {
                    $text = 'لغو اتصال حساب انجام نشد.';
                }
                // 回送信息
                $this->replyWithMessage(
                    [
                        'text' => $text,
                        'parse_mode' => 'Markdown',
                    ]
                );

                return;
            }

            if ($message_key !== '') {
                $text = 'آدرس ایمیل وارد شده با حساب شما مطابقت ندارد.';
            }

            if ($message_key === '/unbind') {
                $text = $this->sendText();
            }

            // 回送信息
            $this->replyWithMessage(
                [
                    'text' => $text,
                    'parse_mode' => 'Markdown',
                ]
            );
        }
    }

    public function sendText(): string
    {
        $text = 'آن را به شکل «/unbind example@qq.com» برای لغو پیوند ارسال کنید.';

        if (Config::obtain('telegram_unbind_kick_member')) {
            $text .= PHP_EOL . PHP_EOL . 'طبق تنظیمات مدیر، حساب بدون پیوند شما به طور خودکار از گروه کاربری حذف خواهد شد.';
        }

        return $text;
    }
}

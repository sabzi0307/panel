<?php

declare(strict_types=1);

namespace App\Utils\Telegram\Commands;

use App\Models\User;
use App\Utils\Telegram\TelegramTools;
use App\Utils\TelegramSessionManager;

use Telegram\Bot\Actions;
use Telegram\Bot\Commands\Command;

/**
 * Class StratCommand.
 */
final class StartCommand extends Command
{
    /**
     * @var string Command Name
     */
    protected $name = 'start';

    /**
     * @var string Command Description
     */
    protected $description = '[چت گروهی/خصوصی] دستور اولیه ربات.';

    /**
     * {@inheritdoc}
     */
    public function handle()
    {
        $Update = $this->getUpdate();
        $Message = $Update->getMessage();

        // 消息会话 ID
        $ChatID = $Message->getChat()->getId();

        if ($ChatID > 0) {
            // 私人会话

            // 发送 '输入中' 会话状态
            $this->replyWithChatAction(['action' => Actions::TYPING]);

            // 触发用户
            $SendUser = [
                'id' => $Message->getFrom()->getId(),
                'name' => $Message->getFrom()->getFirstName() . ' ' . $Message->getFrom()->getLastName(),
                'username' => $Message->getFrom()->getUsername(),
            ];
            // 消息内容
            $MessageText = explode(' ', trim($Message->getText()));
            $MessageKey = array_splice($MessageText, -1)[0];
            if (
                $MessageKey !== ''
                && TelegramTools::getUser($SendUser['id']) === null
                && strlen($MessageKey) === 16
            ) {
                // 新用户绑定
                return $this->bindingAccount($SendUser, $MessageKey);
            }
            // 回送信息
            $this->replyWithMessage(
                [
                    'text' => 'ارسال /help برای کمک',
                    'parse_mode' => 'Markdown',
                ]
            );
        } else {
            if ($_ENV['telegram_group_quiet'] === true) {
                // 群组中不回应
                return;
            }
            // 发送 '输入中' 会话状态
            $this->replyWithChatAction(['action' => Actions::TYPING]);
            // 回送信息
            $this->replyWithMessage(
                [
                    'text' => 'میو میو میو.',
                    'parse_mode' => 'Markdown',
                    'reply_to_message_id' => $Message->getMessageId(),
                ]
            );
        }
    }

    public function bindingAccount($SendUser, $MessageText): void
    {
        $Uid = TelegramSessionManager::verifyBindSession($MessageText);
        if ($Uid === 0) {
            $text = 'اتصال شکست خورد، پس از بازرسی، مشخص شد که：【' . $MessageText . '】به مدت 10 دقیقه معتبر است، می توانید پس از تازه کردن صفحه **ویرایش نمایه** در وب سایت ما دوباره امتحان کنید.';
        } else {
            $BinsUser = User::where('id', $Uid)->first();
            $BinsUser->telegram_id = $SendUser['id'];
            $BinsUser->im_type = 4;
            if ($SendUser['username'] === null) {
                $BinsUser->im_value = 'نام کاربری تنظیم نشده است';
            } else {
                $BinsUser->im_value = $SendUser['username'];
            }
            $BinsUser->save();
            if ($BinsUser->is_admin >= 1) {
                $text = '**مدیر محترم** سلام، اتصال موفق را تبریک می گویم.' . PHP_EOL . 'آدرس ایمیل محدود فعلی است： ' . $BinsUser->email;
            } else {
                if ($BinsUser->class >= 1) {
                    $text = 'عزیز **VIP ' . $BinsUser->class . '** سلام کاربر.' . PHP_EOL . 'اتثال موفق شما را تبریک می گویم，آدرس ایمیل محدود فعلی است： ' . $BinsUser->email;
                } else {
                    $text = 'اتثال به ایمیل شما با موفقیت انجام شد، ：' . $BinsUser->email;
                }
            }
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

<?php

declare(strict_types=1);

namespace App\Command;

use App\Models\Config;
use App\Models\Link;
use App\Models\Node;
use App\Models\User as ModelsUser;
use App\Services\MFA;
use App\Utils\Hash;
use App\Utils\Tools;
use Exception;
use Ramsey\Uuid\Uuid;
use Telegram\Bot\Api;
use Telegram\Bot\Exceptions\TelegramSDKException;
use function count;
use function date;
use function fgets;
use function file_get_contents;
use function fwrite;
use function in_array;
use function json_decode;
use function method_exists;
use function strtolower;
use function trim;
use const PHP_EOL;
use const STDIN;
use const STDOUT;

final class Tool extends Command
{
    public string $description = <<<EOL
├─=: php xcat Tool [options]
│ ├─ setTelegram             - Set up a Telegram bot
│ ├─ resetSetting            - Override database configuration with default values
│ ├─ exportSetting           - Export database configuration
│ ├─ importSetting           - import all settings
│ ├─ resetNodePassword       - Reset all node communication keys
│ ├─ resetNodeBandwidth      - Reset all node traffic
│ ├─ resetPort               - Reset individual user ports
│ ├─ resetBandwidth          - Reset all user traffic
│ ├─ resetTodayBandwidth     - Reset Today Bandwidth
│ ├─ resetPassword           - Reset all user login passwords
│ ├─ resetPasswd             - Reset all user connection passwords
│ ├─ clearSubToken           - clear user Sub Token
│ ├─ generateUUID            - Generate new UUIDs for all users
│ ├─ generateGa              - Generate new Ga Secrets for all users
│ ├─ generateApiToken        - Generate a new API Token for all users
│ ├─ setTheme                - Set a new theme for all users
│ ├─ createAdmin             - Create an administrator account

EOL;

    public function boot(): void
    {
        if (count($this->argv) === 2) {
            echo $this->description;
        } else {
            $methodName = $this->argv[2];
            if (method_exists($this, $methodName)) {
                $this->$methodName();
            } else {
                echo 'method does not exist' . PHP_EOL;
            }
        }
    }

    /**
     * @throws TelegramSDKException
     */
    public function setTelegram(): void
    {
        $WebhookUrl = $_ENV['baseUrl'] . '/callback/telegram?token=' . Config::obtain('telegram_request_token');
        $telegram = new Api(Config::obtain('telegram_token'));
        $telegram->removeWebhook();

        if ($telegram->setWebhook(['url' => $WebhookUrl])) {
            echo 'Bot @' . $telegram->getMe()->getUsername() . ' successfully set！' . PHP_EOL;
        } else {
            echo 'Setup failed！' . PHP_EOL;
        }
    }

    public function resetSetting(): void
    {
        $settings = Config::all();

        foreach ($settings as $setting) {
            $setting->value = $setting->default;
            $setting->save();
        }

        echo 'All database settings have been overridden with default values' . PHP_EOL;
    }

    public function exportSetting(): void
    {
        $settings = Config::all();

        foreach ($settings as $setting) {
            // 因为主键自增所以即便设置为 null 也会在导入时自动分配 id
            // 同时避免多位开发者 pull request 时 settings.json 文件 id 重复所可能导致的冲突
            $setting->id = null;
            // 避免开发者调试配置泄露
            $setting->value = $setting->default;
        }

        $json_settings = json_encode($settings, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        file_put_contents('./conf/settings.json', $json_settings);

        echo 'All database settings have been exported' . PHP_EOL;
    }

    public function importSetting(): void
    {
        $json_settings = file_get_contents('./conf/settings.json');
        $settings = json_decode($json_settings, true);
        $config = [];
        $add_counter = 0;
        $update_counter = 0;
        $del_counter = 0;

        // 检查新增
        foreach ($settings as $item) {
            $config[] = $item['item'];
            $item_name = $item['item'];
            $query = (new Config())->where('item', $item['item'])->first();

            if ($query === null) {
                $new_item = new Config();
                $new_item->item = $item['item'];
                $new_item->value = $item['value'];
                $new_item->class = $item['class'];
                $new_item->is_public = $item['is_public'];
                $new_item->type = $item['type'];
                $new_item->default = $item['default'];
                $new_item->mark = $item['mark'];
                $new_item->save();

                echo 'Add new database settings：' . $item_name . PHP_EOL;
                $add_counter += 1;
                continue;
            }

            if ($query->class !== $item['class']) {
                $query->class = $item['class'];
                $query->save();
                echo 'به روز رسانی تنظیمات پایگاه داده :' . $item_name . PHP_EOL;
                $update_counter += 1;
            }
        }
        // 检查移除
        $db_settings = Config::all();

        foreach ($db_settings as $db_setting) {
            if (! in_array($db_setting->item, $config)) {
                $db_setting->delete();
                $del_counter += 1;
            }
        }

        if ($add_counter !== 0) {
            echo 'Total added ' . $add_counter . ' item new database settings' . PHP_EOL;
        }

        if ($update_counter !== 0) {
            echo 'updated ' . $update_counter . ' Item database settings' . PHP_EOL;
        }

        if ($del_counter !== 0) {
            echo "Total removed {$del_counter} Item database settings" . PHP_EOL;
        }
    }

    public function resetNodePassword(): void
    {
        $nodes = Node::all();

        foreach ($nodes as $node) {
            $node->password = Tools::genRandomChar(32);
            $node->save();
        }
        echo 'All node passwords have been reset' . PHP_EOL;
    }

    public function resetNodeBandwidth(): void
    {
        $nodes = Node::all();

        foreach ($nodes as $node) {
            $node->node_bandwidth = 0;
            $node->save();
        }

        echo 'All node traffic has been reset' . PHP_EOL;
    }

    /**
     * 重置所有用户端口
     */
    public function resetPort(): void
    {
        $users = ModelsUser::all();

        if (count($users) === 0 || count($users) >= 65535) {
            echo 'تعداد کاربران نامعتبر است' . PHP_EOL;
            return;
        }

        (new ModelsUser())->update([
            'port' => 0,
        ]);

        foreach ($users as $user) {
            $user->port = Tools::getSsPort();
            $user->save();
        }

        echo 'همه پورت های کاربر ریست شده اند' . PHP_EOL;
    }

    /**
     * 重置所有用户流量
     */
    public function resetBandwidth(): void
    {
        (new ModelsUser())->where('is_banned', 0)->update([
            'd' => 0,
            'u' => 0,
            'transfer_today' => 0,
        ]);

        echo 'تمام ترافیک کاربر آپدیت شده است' . PHP_EOL;
    }

    /**
     * 重置今日流量
     */
    public function resetTodayBandwidth(): void
    {
        (new ModelsUser())->query()->update(['transfer_today' => 0]);

        echo 'ترافیک امروز ریست شده است' . PHP_EOL;
    }

    /**
     * 重置所有用户登录密码
     */
    public function resetPassword(): void
    {
        $users = ModelsUser::all();

        foreach ($users as $user) {
            $user->pass = Hash::passwordHash(Tools::genRandomChar(32));
            $user->save();
        }

        echo 'All user login passwords have been reset' . PHP_EOL;
    }

    /**
     * 重置所有用户连接密码
     */
    public function resetPasswd(): void
    {
        $users = ModelsUser::all();

        foreach ($users as $user) {
            $user->passwd = Tools::genRandomChar(16);
            $user->save();
        }

        echo 'All user connection passwords have been reset' . PHP_EOL;
    }

    /**
     * 清除用户 Sub Token
     */
    public function clearSubToken(): void
    {
        Link::query()->truncate();

        echo 'همه کاربران پاک شدند Sub Token' . PHP_EOL;
    }

    /**
     * 为所有用户生成新的 UUID
     */
    public function generateUUID(): void
    {
        $users = ModelsUser::all();

        foreach ($users as $user) {
            $user->uuid = Uuid::uuid4();
            $user->save();
        }

        echo 'موارد جدید برای همه کاربران ایجاد شده است UUID' . PHP_EOL;
    }

    /**
     * 二次验证
     */
    public function generateGa(): void
    {
        $users = ModelsUser::all();

        foreach ($users as $user) {
            try {
                $user->ga_token = MFA::generateGaToken();
                $user->save();
            } catch (Exception $e) {
                echo $e->getMessage();
            }
        }

        echo 'موارد جدید برای همه کاربران ایجاد شده است Ga Secret' . PHP_EOL;
    }

    /**
     * 为所有用户生成新的 Api Token
     */
    public function generateApiToken(): void
    {
        $users = ModelsUser::all();

        foreach ($users as $user) {
            $user->api_token = Tools::genRandomChar(32);
            $user->save();
        }

        echo 'موارد جدید برای همه کاربران ایجاد شده است Api Token' . PHP_EOL;
    }

    /**
     * 为所有用户设置新的主题
     */
    public function setTheme(): void
    {
        fwrite(STDOUT, 'لطفاً نام تم مورد نظر را وارد کنید: ');
        $theme = trim(fgets(STDIN));
        $users = ModelsUser::all();

        foreach ($users as $user) {
            $user->theme = $theme;
            $user->save();
        }

        echo 'مجموعه تم جدید برای همه کاربران: ' . $theme . PHP_EOL;
    }

    /**
     * 创建 Admin 账户
     *
     * @throws Exception
     */
    public function createAdmin(): void
    {
        $y = '';
        $email = '';
        $passwd = '';

        if (count($this->argv) === 3) {
            // ask for input
            echo '(1/3) Please enter the administrator email：' . PHP_EOL;
            // get input
            $email = trim(fgets(STDIN));

            // write input back
            echo '(2/3) Please enter the administrator account password：' . PHP_EOL;
            $passwd = trim(fgets(STDIN));

            echo '(3/3) press Y or y Confirm creation：';
            $y = trim(fgets(STDIN));
        } elseif (count($this->argv) === 5) {
            [,,, $email, $passwd] = $this->argv;
            $y = 'y';
        }

        if (strtolower($y) === 'y') {
            // do reg user
            $user = new ModelsUser();
            $user->user_name = 'Admin';
            $user->email = $email;
            $user->remark = '';
            $user->pass = Hash::passwordHash($passwd);
            $user->passwd = Tools::genRandomChar(16);
            $user->uuid = Uuid::uuid4();
            $user->api_token = Tools::genRandomChar(32);
            $user->port = Tools::getSsPort();
            $user->u = 0;
            $user->d = 0;
            $user->transfer_enable = 0;
            $user->ref_by = 0;
            $user->is_admin = 1;
            $user->reg_date = date('Y-m-d H:i:s');
            $user->money = 0;
            $user->im_type = 0;
            $user->im_value = '';
            $user->class = 0;
            $user->node_iplimit = 0;
            $user->node_speedlimit = 0;
            $user->theme = $_ENV['theme'];
            $user->locale = $_ENV['locale'];

            $user->ga_token = MFA::generateGaToken();
            $user->ga_enable = 0;

            if ($user->save()) {
                echo 'Created successfully, please log in on the homepage' . PHP_EOL;
            } else {
                echo 'Creation failed, please check the database configuration' . PHP_EOL;
            }
        } else {
            echo 'Canceled' . PHP_EOL;
        }
    }
}

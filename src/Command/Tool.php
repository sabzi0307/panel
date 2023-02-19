<?php

declare(strict_types=1);

namespace App\Command;

use App\Models\Node;
use App\Models\Setting;
use App\Models\User as ModelsUser;
use App\Utils\Hash;
use App\Utils\Tools;
use Exception;
use Ramsey\Uuid\Uuid;
use Vectorface\GoogleAuthenticator;

final class Tool extends Command
{
    public $description = <<<EOL
├─=: php xcat Tool [options]
│ ├─ setTelegram             - Set up a Telegram bot
│ ├─ resetAllSettings        - Override Settings Center settings with default values
│ ├─ exportAllSettings       - export all settings
│ ├─ importAllSettings       - import all settings
│ ├─ resetNodePassword       - Reset all node communication keys
│ ├─ getCookie               - Get the specified user's cookie
│ ├─ resetPort               - Reset individual user ports
│ ├─ createAdmin             - Create an administrator account
│ ├─ resetAllPort            - Reset all user ports
│ ├─ resetTraffic            - Reset all user traffic
│ ├─ generateUUID            - Generate new UUIDs for all users
│ ├─ generateGa              - Generate new Ga Secrets for all users
│ ├─ generateApiToken        - Generate a new API Token for all users
│ ├─ setTheme                - Set a new theme for all users

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

    public function setTelegram(): void
    {
        $WebhookUrl = $_ENV['baseUrl'] . '/telegram_callback?token=' . $_ENV['telegram_request_token'];
        $telegram = new \Telegram\Bot\Api($_ENV['telegram_token']);
        $telegram->removeWebhook();
        if ($telegram->setWebhook(['url' => $WebhookUrl])) {
            echo 'Bot @' . $telegram->getMe()->getUsername() . ' successfully set！' . PHP_EOL;
        } else {
            echo 'Setup failed！' . PHP_EOL;
        }
    }

    public function resetAllSettings(): void
    {
        $settings = Setting::all();

        foreach ($settings as $setting) {
            $setting->value = $setting->default;
            $setting->save();
        }

        echo 'All database settings have been overridden with default values' . PHP_EOL;
    }

    public function exportAllSettings(): void
    {
        $settings = Setting::all();
        foreach ($settings as $setting) {
            // 因为主键自增所以即便设置为 null 也会在导入时自动分配 id
            // 同时避免多位开发者 pull request 时 settings.json 文件 id 重复所可能导致的冲突
            $setting->id = null;
            // 避免开发者调试配置泄露
            $setting->value = $setting->default;
        }

        $json_settings = \json_encode($settings, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        file_put_contents('./config/settings.json', $json_settings);

        echo 'All database settings have been exported' . PHP_EOL;
    }

    public function importAllSettings(): void
    {
        $json_settings = file_get_contents('./config/settings.json');
        $settings = \json_decode($json_settings, true);
        $config = [];
        $add_counter = 0;
        $del_counter = 0;

        // 检查新增
        foreach ($settings as $item) {
            $config[] = $item['item'];
            $item_name = $item['item'];
            $query = Setting::where('item', '=', $item['item'])->first();

            if ($query === null) {
                $new_item = new Setting();
                $new_item->id = null;
                $new_item->item = $item['item'];
                $new_item->value = $item['value'];
                $new_item->class = $item['class'];
                $new_item->is_public = $item['is_public'];
                $new_item->type = $item['type'];
                $new_item->default = $item['default'];
                $new_item->mark = $item['mark'];
                $new_item->save();

                echo "Add new database settings：${item_name}" . PHP_EOL;
                $add_counter += 1;
            }
        }
        // 检查移除
        $db_settings = Setting::all();
        foreach ($db_settings as $db_setting) {
            if (! \in_array($db_setting->item, $config)) {
                $db_setting->delete();
                $del_counter += 1;
            }
        }

        if ($add_counter !== 0) {
            echo "Total added ${add_counter} item new database settings" . PHP_EOL;
        } else {
            echo 'No new database settings need to be added' . PHP_EOL;
        }
        if ($del_counter !== 0) {
            echo "Total removed ${del_counter} item database settings" . PHP_EOL;
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

    /**
     * 重置用户端口
     */
    public function resetPort(): void
    {
        fwrite(STDOUT, 'Please enter user id: ');
        $user = ModelsUser::find(trim(fgets(STDIN)));
        if ($user !== null) {
            $user->port = Tools::getAvPort();
            if ($user->save()) {
                echo 'reset successful!';
            }
        } else {
            echo 'User does not exist';
        }
    }

    /**
     * 重置所有用户端口
     */
    public function resetAllPort(): void
    {
        $users = ModelsUser::all();
        foreach ($users as $user) {
            $origin_port = $user->port;
            $user->port = Tools::getAvPort();
            echo '$origin_port=' . $origin_port . '&$user->port=' . $user->port . PHP_EOL;
            $user->save();
        }
    }

    /**
     * 重置所有用户流量
     */
    public function resetTraffic(): void
    {
        try {
            ModelsUser::where('enable', 1)->update([
                'd' => 0,
                'u' => 0,
                'last_day_t' => 0,
            ]);
        } catch (Exception $e) {
            echo $e->getMessage();
            return;
        }
        echo 'reset traffic successful';
    }

    /**
     * 为所有用户生成新的 UUID
     */
    public function generateUUID(): void
    {
        $users = ModelsUser::all();
        $current_timestamp = \time();
        foreach ($users as $user) {
            /** @var ModelsUser $user */
            $user->generateUUID($current_timestamp);
        }
        echo 'generate UUID successful';
    }

    /**
     * 二次验证
     */
    public function generateGa(): void
    {
        $users = ModelsUser::all();
        foreach ($users as $user) {
            $ga = new GoogleAuthenticator();
            $secret = $ga->createSecret();
            $user->ga_token = $secret;
            $user->save();
        }
        echo 'generate Ga Secret successful';
    }

    /**
     * 为所有用户生成新的 Api Token
     */
    public function generateApiToken(): void
    {
        $users = ModelsUser::all();
        $current_timestamp = \time();
        foreach ($users as $user) {
            /** @var ModelsUser $user */
            $user->generateApiToken($current_timestamp);
        }
        echo 'generate Api Token successful';
    }

    /**
     * 创建 Admin 账户
     */
    public function createAdmin(): void
    {
        if (count($this->argv) === 3) {
            // ask for input
            fwrite(STDOUT, '(1/3) Please enter the administrator email：') . PHP_EOL;
            // get input
            $email = trim(fgets(STDIN));
            if ($email === null) {
                die("Administrator email must be entered.\r\n");
            }

            // write input back
            fwrite(STDOUT, '(2/3) Please enter the administrator account password：') . PHP_EOL;
            $passwd = trim(fgets(STDIN));
            if ($passwd === null) {
                die("Administrator password must be entered.\r\n");
            }

            fwrite(STDOUT, '(3/3) press Y or y Confirm creation：');
            $y = trim(fgets(STDIN));
        } elseif (count($this->argv) === 5) {
            [,,, $email, $passwd] = $this->argv;
            $y = 'y';
        }

        if (strtolower($y) === 'y') {
            $current_timestamp = \time();
            // create admin user
            $configs = Setting::getClass('register');
            // do reg user
            $user = new ModelsUser();
            $user->user_name = 'Admin';
            $user->email = $email;
            $user->remark = '';
            $user->pass = Hash::passwordHash($passwd);
            $user->passwd = Tools::genRandomChar(16);
            $user->uuid = Uuid::uuid3(Uuid::NAMESPACE_DNS, $email . '|' . $current_timestamp);
            $user->api_token = Uuid::uuid3(Uuid::NAMESPACE_DNS, $user->pass . '|' . $current_timestamp);
            $user->port = Tools::getLastPort() + 1;
            $user->t = 0;
            $user->u = 0;
            $user->d = 0;
            $user->transfer_enable = Tools::toGB($configs['sign_up_for_free_traffic']);
            $user->invite_num = $configs['sign_up_for_invitation_codes'];
            $user->ref_by = 0;
            $user->is_admin = 1;
            $user->expire_in = date('Y-m-d H:i:s', \time() + $configs['sign_up_for_free_time'] * 86400);
            $user->reg_date = date('Y-m-d H:i:s');
            $user->money = 0;
            $user->im_type = 1;
            $user->im_value = '';
            $user->class = 0;
            $user->node_speedlimit = 0;
            $user->theme = $_ENV['theme'];

            $ga = new GoogleAuthenticator();
            $secret = $ga->createSecret();
            $user->ga_token = $secret;
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

    /**
     * 获取 USERID 的 Cookie
     */
    public function getCookie(): void
    {
        if (count($this->argv) === 4) {
            $user = ModelsUser::find($this->argv[3]);
            $expire_in = 86400 + \time();
            echo Hash::cookieHash($user->pass, $expire_in) . ' ' . $expire_in;
        }
    }

    /**
     * 为所有用户设置新的主题
     */
    public function setTheme(): void
    {
        fwrite(STDOUT, 'Please enter a theme name to set: ');
        $theme = trim(fgets(STDIN));
        $users = ModelsUser::all();
        foreach ($users as $user) {
            $user->theme = $theme;
            $user->save();
        }
    }
}

<?php

declare(strict_types=1);

namespace App\Command;

use tronovav\GeoIP2Update\Client;
use const BASE_PATH;

final class Update extends Command
{
    public string $description = <<< END
├─=: php xcat Update         - Update and migrate configuration
END;

    public function boot(): void
    {
        // 迁移配置
        global $_ENV;
        $copy_result = copy(BASE_PATH . '/config/.config.php', BASE_PATH . '/config/.config.php.bak');
        if ($copy_result) {
            echo ".config.php File backup successful。\n";
        } else {
            echo ".config.php File backup failed, migration terminated。\n";
        }

        $config_old = file_get_contents(BASE_PATH . '/config/.config.php');
        $config_new = file_get_contents(BASE_PATH . '/config/.config.example.php');
        //将旧config迁移到新config上
        $migrated = [];
        foreach ($_ENV as $key => $value_reserve) {
            $regex = '/_ENV\[\'' . $key . '\'\].*?;/s';
            $matches_new = [];
            preg_match($regex, $config_new, $matches_new);
            if (isset($matches_new[0]) === false) {
                echo "Configuration item not found:" . $key . " Could not be found in new version .config.php file, may have been renamed or obsolete。\n";
                continue;
            }

            $matches_old = [];
            preg_match($regex, $config_old, $matches_old);

            $config_new = str_replace($matches_new[0], $matches_old[0], $config_new);
            $migrated[] = '_ENV[\'' . $key . '\']';
        }
        //检查新增了哪些config
        $regex_new = '/_ENV\[\'.*?\'\]/s';
        $matches_new_all = [];
        preg_match_all($regex_new, $config_new, $matches_new_all);
        $differences = array_diff($matches_new_all[0], $migrated);
        foreach ($differences as $difference) {
            //匹配注释
            $regex_comment = '/' . $difference . '.*?;.*?(?=\n)/s';
            $regex_comment = str_replace(['[', ']'], ['\[', '\]'], $regex_comment);
            $matches_comment = [];
            preg_match($regex_comment, $config_new, $matches_comment);
            $comment = '';
            if (isset($matches_comment[0])) {
                $comment = $matches_comment[0];
                $comment = substr(
                    $comment,
                    strpos(
                        $comment,
                        '//',
                        strpos($comment, ';') //查找';'之后的第一个'//'，然后substr其后面的comment
                    ) + 2
                );
            }
            //裁去首尾
            $difference = substr($difference, 15);
            $difference = substr($difference, 0, -2);

            echo "New .config.php configuration item：" . $difference . ":" . $comment . " \n";
        }
        echo "No new .config.php configuration items need to be added。\n";
        file_put_contents(BASE_PATH . '/config/.config.php', $config_new);
        echo "migration complete.\n";
        // 更新 GeoLite2 数据库
        if ($_ENV['maxmind_license_key'] !== '') {
            echo "Updating GeoLite2 database...\n";
            $client = new Client([
                'license_key' => $_ENV['maxmind_license_key'],
                'dir' => BASE_PATH . '/storage/',
                'editions' => ['GeoLite2-City', "GeoLite2-Country"],
            ]);
            $client->run();
        }
    }
}

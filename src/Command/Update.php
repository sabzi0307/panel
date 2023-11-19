<?php

declare(strict_types=1);

namespace App\Command;

use Exception;
use tronovav\GeoIP2Update\Client;
use function array_diff;
use function copy;
use function file_get_contents;
use function file_put_contents;
use function preg_match;
use function preg_match_all;
use function str_replace;
use function strpos;
use function substr;
use const BASE_PATH;
use const PHP_EOL;

final class Update extends Command
{
    public string $description = <<< END
├─=: php xcat Update         - Update and migrate configuration
END;

    public function boot(): void
    {
        // 迁移配置
        global $_ENV;
        $copy_result = copy(BASE_PATH . '/conf/.config.php', BASE_PATH . '/conf/.config.php.bak');

        if ($copy_result) {
            echo '.config.php File backup successful。' . PHP_EOL;
        } else {
            echo '.config.php File backup failed, migration terminated。' . PHP_EOL;
        }

        $config_old = file_get_contents(BASE_PATH . '/conf/.config.php');
        $config_new = file_get_contents(BASE_PATH . '/conf/.config.example.php');
        //将旧config迁移到新config上
        $migrated = [];

        foreach ($_ENV as $key => $value_reserve) {
            $regex = '/_ENV\[\'' . $key . '\'\].*?;/s';
            $matches_new = [];
            preg_match($regex, $config_new, $matches_new);

            if (! isset($matches_new[0])) {
                echo 'Configuration item not found:' . $key . ' Could not be found in new version .config.php file, may have been renamed or obsolete。' . PHP_EOL;
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

            echo 'New .config.php configuration item：' . $difference . ':' . $comment . PHP_EOL;
        }

        echo 'هیچ مورد جدید پیکربندی .config.php برای افزودن وجود ندارد.' . PHP_EOL;
        file_put_contents(BASE_PATH . '/conf/.config.php', $config_new);
        echo 'مهاجرت کامل شد' . PHP_EOL;

        // 更新 GeoLite2 数据库
        if ($_ENV['maxmind_license_key'] !== '' || $_ENV['maxmind_license_key'] !== 'local') {
            echo 'Updating GeoLite2 database...' . PHP_EOL;

            $client = new Client([
                'license_key' => $_ENV['maxmind_license_key'],
                'dir' => BASE_PATH . '/storage/',
                'editions' => ['GeoLite2-City', 'GeoLite2-Country'],
            ]);

            try {
                $client->run();
                echo 'Successfully updated GeoLite2 database.' . PHP_EOL;
            } catch (Exception $e) {
                echo 'Failed to update GeoLite2 database.' . PHP_EOL;
                echo $e->getMessage() . PHP_EOL;
            }
        }
    }
}

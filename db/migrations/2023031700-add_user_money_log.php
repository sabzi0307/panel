<?php

declare(strict_types=1);

use App\Interfaces\MigrationInterface;
use App\Services\DB;

return new class() implements MigrationInterface {
    public function up(): int
    {
        DB::getPdo()->exec("CREATE TABLE IF NOT EXISTS `user_money_log` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                `user_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'User ID',
                `before` decimal(10,2) NOT NULL DEFAULT 0 COMMENT 'Account balance before user change',
                `after` decimal(10,2) NOT NULL DEFAULT 0 COMMENT 'Account balance after user change',
                `amount` decimal(10,2) NOT NULL DEFAULT 0 COMMENT 'total change',
                `remark` text NOT NULL DEFAULT '' COMMENT 'Remark',
                `create_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'creation time',
                PRIMARY KEY (`id`),
                KEY `user_id` (`user_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;");

        return 2023031700;
    }

    public function down(): int
    {
        DB::getPdo()->exec('DROP TABLE IF EXISTS `user_money_log`;');

        return 2023030500;
    }
};

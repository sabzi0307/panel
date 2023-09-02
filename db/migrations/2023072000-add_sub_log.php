<?php

declare(strict_types=1);

use App\Interfaces\MigrationInterface;
use App\Services\DB;

return new class() implements MigrationInterface {
    public function up(): int
    {
        DB::getPdo()->exec("
            CREATE TABLE IF NOT EXISTS `subscribe_log` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `user_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'User ID',
                `type` varchar(255) NOT NULL DEFAULT '' COMMENT 'subscription type',
                `request_ip` varchar(255) NOT NULL DEFAULT '' COMMENT 'Request IP',
                `request_user_agent` varchar(255) NOT NULL DEFAULT '' COMMENT 'request UA information',
                `request_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'request time',
                PRIMARY KEY (`id`),
                KEY `user_id` (`user_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
            DROP TABLE IF EXISTS `user_subscribe_log`;
        ");

        return 2023072000;
    }

    public function down(): int
    {
        DB::getPdo()->exec("
            CREATE TABLE IF NOT EXISTS `user_subscribe_log` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `user_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'username',
                `user_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'User ID',
                `email` varchar(255) NOT NULL DEFAULT '' COMMENT 'user mailbox',
                `subscribe_type` varchar(255) NOT NULL DEFAULT '' COMMENT 'subscription type',
                `request_ip` varchar(255) NOT NULL DEFAULT '' COMMENT 'Request IP',
                `request_time` timestamp NOT NULL DEFAULT '1989-06-04 00:05:00' COMMENT 'request time',
                `request_user_agent` varchar(255) NOT NULL DEFAULT '' COMMENT 'request UA information',
                PRIMARY KEY (`id`),
                KEY `user_id` (`user_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
            DROP TABLE IF EXISTS `subscribe_log`;
        ");

        return 2023071700;
    }
};

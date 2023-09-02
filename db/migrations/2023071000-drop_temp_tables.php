<?php

declare(strict_types=1);

use App\Interfaces\MigrationInterface;
use App\Services\DB;

return new class() implements MigrationInterface {
    public function up(): int
    {
        DB::getPdo()->exec('
            DROP TABLE IF EXISTS `email_verify`;
            DROP TABLE IF EXISTS `user_password_reset`;
            DROP TABLE IF EXISTS `telegram_session`;
        ');

        return 2023071000;
    }

    public function down(): int
    {
        DB::getPdo()->exec(
            "CREATE TABLE IF NOT EXISTS `email_verify` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `email` varchar(255) NOT NULL DEFAULT '' COMMENT 'email',
                `ip` varchar(255) NOT NULL DEFAULT '' COMMENT 'IP',
                `code` varchar(255) NOT NULL DEFAULT '' COMMENT 'verification code',
                `expire_in` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'expiration',
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
            
            CREATE TABLE IF NOT EXISTS `telegram_session` (
                `id` bigint(20) NOT NULL AUTO_INCREMENT,
                `user_id` bigint(20) DEFAULT NULL,
                `type` int(11) DEFAULT NULL,
                `session_content` varchar(255) DEFAULT NULL,
                `datetime` bigint(20) DEFAULT NULL,
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE IF NOT EXISTS `user_password_reset` (
                `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `email` varchar(255) NOT NULL DEFAULT '' COMMENT 'user mailbox',
                `token` varchar(255) NOT NULL DEFAULT '' COMMENT 'reset password token',
                `init_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'creation time',
                `expire_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'Expiration',
                PRIMARY KEY (`id`),
                KEY `email` (`email`),
                KEY `token` (`token`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
        );

        return 2023063000;
    }
};

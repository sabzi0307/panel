<?php

declare(strict_types=1);

use App\Interfaces\MigrationInterface;
use App\Services\DB;

return new class() implements MigrationInterface {
    public function up(): int
    {
        DB::getPdo()->exec("
        ALTER TABLE user ADD COLUMN IF NOT EXISTS `locale` varchar(16) NOT NULL DEFAULT 'zh-TW' COMMENT 'Display language';
        ALTER TABLE user MODIFY COLUMN `user_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'username';
        ALTER TABLE user MODIFY COLUMN `email` varchar(255) NOT NULL COMMENT 'Email';
        ALTER TABLE user MODIFY COLUMN `pass` varchar(255) NOT NULL COMMENT 'login password';
        ALTER TABLE user MODIFY COLUMN `passwd` varchar(255) NOT NULL COMMENT 'node password';
        ALTER TABLE user MODIFY COLUMN `u` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'account current upload traffic';
        ALTER TABLE user MODIFY COLUMN `d` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'account current download traffic';
        ALTER TABLE user MODIFY COLUMN `transfer_today` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Account traffic used today';
        ALTER TABLE user MODIFY COLUMN `transfer_total` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Account accumulative flow';
        ALTER TABLE user MODIFY COLUMN `transfer_enable` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Account current available traffic';
        ALTER TABLE user MODIFY COLUMN `last_detect_ban_time` datetime NOT NULL DEFAULT '1989-06-04 00:05:00' COMMENT 'Time of last ban';
        ALTER TABLE user MODIFY COLUMN `all_detect_number` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'Cumulative number of violations';
        ALTER TABLE user MODIFY COLUMN `last_check_in_time` int(11) unsigned DEFAULT 0 COMMENT 'last checkin time';
        ALTER TABLE user MODIFY COLUMN `reg_date` datetime NOT NULL DEFAULT '1989-06-04 00:05:00' COMMENT 'registration time';
        ALTER TABLE user MODIFY COLUMN `money` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'account balance';
        ALTER TABLE user MODIFY COLUMN `ref_by` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Inviter ID';
        ALTER TABLE user MODIFY COLUMN `method` varchar(255) NOT NULL DEFAULT 'aes-128-gcm' COMMENT 'Shadowsocks encryption method';
        ALTER TABLE user MODIFY COLUMN `reg_ip` varchar(255) NOT NULL DEFAULT '127.0.0.1' COMMENT 'Registration IP';
        ALTER TABLE user MODIFY COLUMN `is_admin` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'is_admin';
        ALTER TABLE user MODIFY COLUMN `im_type` smallint(6) unsigned NOT NULL DEFAULT 1 COMMENT 'contact type';
        UPDATE user SET im_value = '' WHERE im_value IS NULL;
        ALTER TABLE user MODIFY COLUMN `im_value` varchar(255) NOT NULL DEFAULT '' COMMENT 'Contact information';
        ALTER TABLE user MODIFY COLUMN `class` smallint(6) unsigned NOT NULL DEFAULT 0 COMMENT 'class';
        ALTER TABLE user MODIFY COLUMN `class_expire` datetime NOT NULL DEFAULT '1989-06-04 00:05:00' COMMENT 'class expiration time';
        ALTER TABLE user MODIFY COLUMN `theme` varchar(255) NOT NULL DEFAULT 'tabler' COMMENT 'website theme';
        ALTER TABLE user MODIFY COLUMN `ga_token` varchar(255) NOT NULL DEFAULT '' COMMENT 'GA key';
        ALTER TABLE user MODIFY COLUMN `ga_enable` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'GA switch';
        ALTER TABLE user MODIFY COLUMN `remark` text NOT NULL DEFAULT '' COMMENT 'remark';
        ALTER TABLE user MODIFY COLUMN `node_group` smallint(6) unsigned NOT NULL DEFAULT 0 COMMENT 'node group';
        ALTER TABLE user MODIFY COLUMN `is_banned` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'is_banned';
        ALTER TABLE user MODIFY COLUMN `banned_reason` varchar(255) NOT NULL DEFAULT '' COMMENT 'Banned reason';
        ALTER TABLE user MODIFY COLUMN `expire_notified` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'Expired reminder';
        ALTER TABLE user MODIFY COLUMN `traffic_notified` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'traffic notification';
        ALTER TABLE user MODIFY COLUMN `auto_reset_day` smallint(6) unsigned NOT NULL DEFAULT 0 COMMENT 'Auto reset traffic day';
        ALTER TABLE user MODIFY COLUMN `auto_reset_bandwidth` decimal(12,2) unsigned NOT NULL DEFAULT 0.00 COMMENT 'Auto reset bandwidth';
        ALTER TABLE user MODIFY COLUMN `is_dark_mode` tinyint(1) NOT NULL DEFAULT 0;
        ALTER TABLE user DROP KEY IF EXISTS `user_name`;
        ALTER TABLE user ADD UNIQUE KEY IF NOT EXISTS `api_token` (`api_token`);
        ALTER TABLE user ADD KEY IF NOT EXISTS `is_admin` (`is_admin`);
        ALTER TABLE user ADD KEY IF NOT EXISTS `is_banned` (`is_banned`);
        ALTER TABLE user CHANGE COLUMN IF EXISTS `sendDailyMail` `daily_mail_enable` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Daily report switch';
        ");

        return 2023060300;
    }

    public function down(): int
    {
        DB::getPdo()->exec('ALTER TABLE user DROP COLUMN IF EXISTS `locale`;');

        return 2023053000;
    }
};

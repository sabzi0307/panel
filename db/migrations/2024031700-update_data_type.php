<?php

declare(strict_types=1);

use App\Interfaces\MigrationInterface;
use App\Services\DB;

return new class() implements MigrationInterface {
    public function up(): int
    {
        DB::getPdo()->exec("
            ALTER TABLE announcement MODIFY COLUMN `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Announcement ID';
            ALTER TABLE announcement MODIFY COLUMN `content` longtext NOT NULL DEFAULT '' COMMENT 'Announcement content';
            ALTER TABLE config MODIFY COLUMN `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Configuration ID';
            ALTER TABLE config MODIFY COLUMN `item` varchar(255) NOT NULL DEFAULT '' COMMENT 'Configuration Items';
            ALTER TABLE config MODIFY COLUMN `value` varchar(2048) NOT NULL DEFAULT '' COMMENT 'Configuration Value';
            ALTER TABLE config MODIFY COLUMN `class` varchar(16) NOT NULL DEFAULT '' COMMENT 'Configuration Category';
            ALTER TABLE config MODIFY COLUMN `is_public` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'Public Parameter';
            ALTER TABLE config MODIFY COLUMN `type` varchar(16) NOT NULL DEFAULT '' COMMENT 'Configuration value type';
            ALTER TABLE config MODIFY COLUMN `default` varchar(2048) NOT NULL DEFAULT '' COMMENT 'Default value';
            ALTER TABLE config MODIFY COLUMN `mark` varchar(255) NOT NULL DEFAULT '' COMMENT 'Remark';
            ALTER TABLE detect_ban_log MODIFY COLUMN `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Ban record ID';
            ALTER TABLE invoice MODIFY COLUMN `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Billing ID';
            ALTER TABLE link MODIFY COLUMN `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Record ID';
            ALTER TABLE subscribe_log MODIFY COLUMN `request_user_agent` varchar(1024) NOT NULL DEFAULT '' COMMENT 'Request UA';
            ALTER TABLE subscribe_log ADD KEY IF NOT EXISTS `request_ip` (`request_ip`);
            ALTER TABLE subscribe_log ADD KEY IF NOT EXISTS `request_time` (`request_time`);
            ALTER TABLE subscribe_log ADD KEY IF NOT EXISTS `request_user_agent` (`request_user_agent`);
            ALTER TABLE user_coupon MODIFY COLUMN `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Discount code ID';
            ALTER TABLE user_coupon DROP KEY IF EXISTS `code`;
            ALTER TABLE user_coupon ADD UNIQUE KEY IF NOT EXISTS `code` (`code`);
        ");

        return 2024031700;
    }

    public function down(): int
    {
        return 2024031700;
    }
};

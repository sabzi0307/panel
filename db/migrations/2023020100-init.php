<?php

declare(strict_types=1);

use App\Interfaces\MigrationInterface;
use App\Services\DB;

return new class() implements MigrationInterface {
    public function up(): int
    {
        DB::getPdo()->exec(
            "CREATE TABLE `announcement` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `date` datetime DEFAULT NULL,
                `content` text DEFAULT NULL,
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `config` (
                `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
                `item` varchar(255) DEFAULT NULL COMMENT 'item',
                `value` varchar(2048) DEFAULT NULL,
                `class` varchar(255) DEFAULT 'default' COMMENT 'Configuration classification',
                `is_public` int(11) DEFAULT 0 COMMENT 'Whether it is a public parameter',
                `type` varchar(255) DEFAULT NULL COMMENT 'value type',
                `default` varchar(255) DEFAULT NULL COMMENT 'Defaults',
                `mark` varchar(255) DEFAULT NULL COMMENT 'Remark',
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `detect_ban_log` (
                `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                `user_name` varchar(255) DEFAULT NULL COMMENT 'username',
                `user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'user id',
                `email` varchar(255) DEFAULT NULL COMMENT 'user email',
                `detect_number` int(11) DEFAULT NULL COMMENT 'The number of violations this time',
                `ban_time` int(11) DEFAULT NULL COMMENT 'The duration of this ban',
                `start_time` bigint(20) DEFAULT NULL COMMENT 'Statistics start time',
                `end_time` bigint(20) DEFAULT NULL COMMENT 'Statistics end time',
                `all_detect_number` int(11) DEFAULT NULL COMMENT 'all detect number of violations',
                PRIMARY KEY (`id`),
                KEY `user_id` (`user_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `detect_list` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                `name` varchar(255) DEFAULT NULL,
                `text` varchar(255) DEFAULT NULL,
                `regex` varchar(255) DEFAULT NULL,
                `type` int(11) DEFAULT NULL,
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `detect_log` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                `user_id` bigint(20) unsigned DEFAULT NULL,
                `list_id` bigint(20) unsigned DEFAULT NULL,
                `datetime` bigint(20) unsigned DEFAULT NULL,
                `node_id` int(11) DEFAULT NULL,
                `status` int(11) DEFAULT 0,
                PRIMARY KEY (`id`),
                KEY `user_id` (`user_id`),
                KEY `node_id` (`node_id`),
                KEY `list_id` (`list_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `docs` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                `date` datetime DEFAULT NULL,
                `title` varchar(255) DEFAULT NULL,
                `content` varchar(255) DEFAULT NULL,
                `markdown` varchar(255) DEFAULT NULL,
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `email_queue` (
                `id` bigint(20) NOT NULL AUTO_INCREMENT,
                `to_email` varchar(255) DEFAULT NULL,
                `subject` varchar(255) DEFAULT NULL,
                `template` varchar(255) DEFAULT NULL,
                `array` longtext DEFAULT NULL,
                `time` int(11) DEFAULT NULL,
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `email_verify` (
                `id` bigint(20) NOT NULL AUTO_INCREMENT,
                `email` varchar(255) DEFAULT NULL,
                `ip` varchar(255) DEFAULT NULL,
                `code` varchar(255) DEFAULT NULL,
                `expire_in` bigint(20) DEFAULT NULL,
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `gift_card` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                `card` text DEFAULT NULL COMMENT 'card number',
                `balance` int(11) DEFAULT NULL COMMENT 'balance',
                `create_time` int(11) DEFAULT NULL COMMENT 'creation time',
                `status` int(11) DEFAULT NULL COMMENT 'status of use',
                `use_time` int(11) DEFAULT NULL COMMENT 'usage time',
                `use_user` int(11) DEFAULT NULL COMMENT 'user',
                PRIMARY KEY (`id`),
                KEY `id` (`id`),
                KEY `status` (`status`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `invoice` (
                `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Billing ID',
                `user_id` int(11) DEFAULT NULL COMMENT 'Attributed User',
                `order_id` int(11) DEFAULT NULL COMMENT 'order ID',
                `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'bill content' CHECK (json_valid(`content`)),
                `price` double DEFAULT NULL COMMENT 'Billing amount',
                `status` varchar(255) DEFAULT NULL COMMENT 'Billing Status',
                `create_time` int(11) DEFAULT NULL COMMENT 'creation time',
                `update_time` int(11) DEFAULT NULL COMMENT 'update time',
                `pay_time` int(11) DEFAULT NULL COMMENT 'Payment time',
                PRIMARY KEY (`id`),
                KEY `id` (`id`),
                KEY `user_id` (`user_id`),
                KEY `order_id` (`order_id`),
                KEY `status` (`status`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `link` (
                `id` bigint(20) NOT NULL AUTO_INCREMENT,
                `token` varchar(255) DEFAULT NULL,
                `userid` bigint(20) unsigned DEFAULT NULL,
                PRIMARY KEY (`id`),
                UNIQUE KEY `token` (`token`),
                UNIQUE KEY `userid` (`userid`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `login_ip` (
                `id` bigint(20) NOT NULL AUTO_INCREMENT,
                `userid` bigint(20) unsigned DEFAULT NULL,
                `ip` varchar(255) DEFAULT NULL,
                `datetime` bigint(20) DEFAULT NULL,
                `type` int(11) DEFAULT NULL,
                PRIMARY KEY (`id`),
                KEY `userid` (`userid`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `node` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `name` varchar(255) DEFAULT NULL,
                `type` int(11) DEFAULT NULL,
                `server` varchar(255) DEFAULT NULL,
                `custom_config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{}' COMMENT 'custom configuration' CHECK (json_valid(`custom_config`)),
                `info` text DEFAULT '',
                `status` varchar(255) DEFAULT '',
                `sort` int(11) DEFAULT NULL,
                `traffic_rate` float DEFAULT 1,
                `node_class` int(11) DEFAULT 0,
                `node_speedlimit` double NOT NULL DEFAULT 0 COMMENT 'Node speed limit',
                `node_connector` int(11) DEFAULT 0,
                `node_bandwidth` bigint(20) DEFAULT 0,
                `node_bandwidth_limit` bigint(20) DEFAULT 0,
                `bandwidthlimit_resetday` int(11) DEFAULT 0,
                `node_heartbeat` bigint(20) DEFAULT 0,
                `online_user` int(11) DEFAULT 0 COMMENT 'node online user',
                `node_ip` varchar(255) DEFAULT NULL,
                `node_group` int(11) DEFAULT 0,
                `mu_only` tinyint(1) DEFAULT 0,
                `online` tinyint(1) DEFAULT 1,
                `gfw_block` tinyint(1) DEFAULT 0,
                `password` varchar(255) DEFAULT NULL,
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
            
            CREATE TABLE `online_log` (
                `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                `user_id` INT UNSIGNED NOT NULL,
                `ip` INET6 NOT NULL,
                `node_id` INT UNSIGNED NOT NULL,
                `first_time` INT UNSIGNED NOT NULL,
                `last_time` INT UNSIGNED NOT NULL,
                PRIMARY KEY (`id`),
                UNIQUE KEY (`user_id`, `ip`),
                KEY (`last_time`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `order` (
                `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'order ID',
                `user_id` int(11) DEFAULT NULL COMMENT 'submit user',
                `product_id` int(11) DEFAULT NULL COMMENT 'Product ID',
                `product_type` varchar(255) DEFAULT NULL COMMENT 'Product Types',
                `product_name` varchar(255) DEFAULT NULL COMMENT 'product name',
                `product_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'product content' CHECK (json_valid(`product_content`)),
                `coupon` varchar(255) DEFAULT NULL COMMENT 'Order coupon code',
                `price` double DEFAULT NULL COMMENT 'total price',
                `status` varchar(255) DEFAULT NULL COMMENT 'Order Status',
                `create_time` int(11) DEFAULT NULL COMMENT 'creation time',
                `update_time` int(11) DEFAULT NULL COMMENT 'update time',
                PRIMARY KEY (`id`),
                KEY `id` (`id`),
                KEY `user_id` (`user_id`),
                KEY `product_id` (`product_id`),
                KEY `status` (`status`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `payback` (
                `id` bigint(20) NOT NULL AUTO_INCREMENT,
                `total` decimal(12,2) DEFAULT NULL,
                `userid` bigint(20) DEFAULT NULL,
                `ref_by` bigint(20) DEFAULT NULL,
                `ref_get` decimal(12,2) DEFAULT NULL,
                `datetime` bigint(20) DEFAULT NULL,
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `paylist` (
                `id` bigint(20) NOT NULL AUTO_INCREMENT,
                `userid` bigint(20) unsigned DEFAULT NULL,
                `total` decimal(12,2) DEFAULT NULL,
                `status` int(11) DEFAULT 0,
                `invoice_id` int(11) DEFAULT 0,
                `tradeno` varchar(255) DEFAULT NULL,
                `gateway` varchar(255) NOT NULL DEFAULT '',
                `datetime` bigint(20) DEFAULT 0,
                PRIMARY KEY (`id`),
                KEY `userid` (`userid`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `product` (
                `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Product ID',
                `type` varchar(255) DEFAULT NULL COMMENT 'type',
                `name` varchar(255) DEFAULT NULL COMMENT 'name',
                `price` double DEFAULT NULL COMMENT 'selling price',
                `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'content' CHECK (json_valid(`content`)),
                `limit` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'purchase limit' CHECK (json_valid(`limit`)),
                `status` int(11) DEFAULT NULL COMMENT 'sales status',
                `create_time` int(11) DEFAULT NULL COMMENT 'creation time',
                `update_time` int(11) DEFAULT NULL COMMENT 'update time',
                `sale_count` int(11) DEFAULT NULL COMMENT 'sale count',
                `stock` int(11) DEFAULT NULL COMMENT 'in stock',
                PRIMARY KEY (`id`),
                KEY `id` (`id`),
                KEY `type` (`type`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `stream_media` (
                `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                `node_id` int(11) DEFAULT NULL COMMENT '节点id',
                `result` text DEFAULT NULL COMMENT '检测结果',
                `created_at` int(11) DEFAULT NULL COMMENT '创建时间',
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `telegram_session` (
                `id` bigint(20) NOT NULL AUTO_INCREMENT,
                `user_id` bigint(20) DEFAULT NULL,
                `type` int(11) DEFAULT NULL,
                `session_content` varchar(255) DEFAULT NULL,
                `datetime` bigint(20) DEFAULT NULL,
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `ticket` (
                `id` bigint(20) NOT NULL AUTO_INCREMENT,
                `title` varchar(255) DEFAULT NULL,
                `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT 'Ticket Content' CHECK (json_valid(`content`)),
                `userid` bigint(20) DEFAULT NULL,
                `datetime` bigint(20) DEFAULT NULL,
                `status` varchar(255) DEFAULT '' COMMENT 'Ticket Status',
                `type` varchar(255) DEFAULT 'other' COMMENT 'Ticket Type',
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `user` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'User ID',
                `user_name` varchar(255) DEFAULT NULL COMMENT 'username',
                `email` varchar(255) DEFAULT NULL COMMENT 'E-Mail',
                `pass` varchar(255) DEFAULT NULL COMMENT 'login password',
                `passwd` varchar(255) DEFAULT NULL COMMENT 'node password',
                `uuid` char(36) NOT NULL COMMENT 'UUID',
                `t` bigint(20) unsigned DEFAULT 0 COMMENT 'last used time',
                `u` bigint(20) unsigned DEFAULT 0 COMMENT 'The account\'s current upload traffic',
                `d` bigint(20) unsigned DEFAULT 0 COMMENT 'Account current download traffic',
                `transfer_today` bigint(20) unsigned DEFAULT 0 COMMENT 'Account traffic used today',
                `transfer_total` bigint(20) unsigned DEFAULT 0 COMMENT 'total traffic usage of the account',
                `transfer_enable` bigint(20) unsigned DEFAULT 0 COMMENT 'Account current available traffic',
                `port` smallint(6) unsigned NOT NULL COMMENT 'port',
                `last_detect_ban_time` datetime DEFAULT '1989-06-04 00:05:00' COMMENT 'Last banned time',
                `all_detect_number` int(11) DEFAULT 0 COMMENT 'total number of violations',
                `last_check_in_time` bigint(20) unsigned DEFAULT 0 COMMENT 'Last check-in time',
                `reg_date` datetime DEFAULT NULL COMMENT 'Registration time',
                `invite_num` int(11) DEFAULT 0 COMMENT 'Available invitations',
                `money` decimal(10,2) NOT NULL DEFAULT 0.00,
                `ref_by` bigint(20) unsigned DEFAULT 0 COMMENT 'Inviter ID',
                `method` varchar(255) DEFAULT 'aes-128-gcm' COMMENT 'Shadowsocks encryption method',
                `reg_ip` varchar(255) DEFAULT '127.0.0.1' COMMENT 'register IP',
                `node_speedlimit` double NOT NULL DEFAULT 0 COMMENT 'user speed limit',
                `node_iplimit` smallint(6) unsigned NOT NULL DEFAULT 0 COMMENT 'The number of IPs that can be connected at the same time',
                `node_connector` int(11) DEFAULT 0 COMMENT 'Simultaneously available connections',
                `is_admin` tinyint(1) DEFAULT 0 COMMENT 'Are you an administrator',
                `im_type` int(11) DEFAULT 1 COMMENT 'contact type',
                `im_value` varchar(255) DEFAULT '' COMMENT 'Contact information',
                `sendDailyMail` tinyint(1) DEFAULT 0 COMMENT 'Daily Report Switch',
                `class` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'level',
                `class_expire` datetime DEFAULT '1989-06-04 00:05:00' COMMENT 'Level Expiration Time',
                `expire_in` datetime DEFAULT '2199-01-01 00:00:00',
                `theme` varchar(255) DEFAULT NULL COMMENT 'website theme',
                `ga_token` varchar(255) DEFAULT NULL,
                `ga_enable` int(11) DEFAULT 0,
                `remark` text DEFAULT '' COMMENT 'Remark',
                `node_group` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'node grouping',
                `is_banned` int(11) DEFAULT 0 COMMENT 'Is banned?',
                `banned_reason` varchar(255) DEFAULT '' COMMENT 'Ban reason',
                `telegram_id` bigint(20) DEFAULT 0,
                `expire_notified` tinyint(1) DEFAULT 0,
                `traffic_notified` tinyint(1) DEFAULT 0,
                `forbidden_ip` varchar(255) DEFAULT '',
                `forbidden_port` varchar(255) DEFAULT '',
                `auto_reset_day` int(11) DEFAULT 0,
                `auto_reset_bandwidth` decimal(12,2) DEFAULT 0.00,
                `api_token` char(36) NOT NULL DEFAULT '' COMMENT 'API key',
                `use_new_shop` smallint(6) NOT NULL DEFAULT 0 COMMENT 'Whether to enable new stores',
                `is_dark_mode` int(11) DEFAULT 0,
                PRIMARY KEY (`id`),
                UNIQUE KEY `uuid` (`uuid`),
                UNIQUE KEY `email` (`email`),
                UNIQUE KEY `ga_token` (`ga_token`),
                KEY `user_name` (`user_name`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `user_coupon` (
                `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Coupon code ID',
                `code` varchar(255) DEFAULT NULL COMMENT 'Coupon Code',
                `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Coupon code content' CHECK (json_valid(`content`)),
                `limit` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Coupon Code Restrictions' CHECK (json_valid(`limit`)),
                `create_time` int(11) DEFAULT NULL COMMENT 'creation time',
                `expire_time` int(11) DEFAULT NULL COMMENT 'Expiration',
                PRIMARY KEY (`id`),
                KEY `id` (`id`),
                KEY `code` (`code`),
                KEY `expire_time` (`expire_time`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `user_hourly_usage` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                `user_id` bigint(20) unsigned DEFAULT NULL,
                `traffic` bigint(20) DEFAULT NULL,
                `hourly_usage` bigint(20) DEFAULT NULL,
                `datetime` int(11) DEFAULT NULL,
                PRIMARY KEY (`id`),
                KEY `user_id` (`user_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `user_invite_code` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                `code` varchar(255) DEFAULT NULL,
                `user_id` bigint(20) unsigned DEFAULT NULL,
                `created_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
                `updated_at` timestamp NULL DEFAULT '1989-06-04 00:05:00',
                PRIMARY KEY (`id`),
                UNIQUE KEY `code` (`code`),
                UNIQUE KEY `user_id` (`user_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
            
            CREATE TABLE `user_money_log` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                `user_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'User ID',
                `before` decimal(10,2) NOT NULL DEFAULT 0 COMMENT 'Account balance before user change',
                `after` decimal(10,2) NOT NULL DEFAULT 0 COMMENT 'Account balance after user change',
                `amount` decimal(10,2) NOT NULL DEFAULT 0 COMMENT 'total change',
                `remark` text NOT NULL DEFAULT '' COMMENT 'Remark',
                `create_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'creation time',
                PRIMARY KEY (`id`),
                KEY `user_id` (`user_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `user_password_reset` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `email` varchar(255) DEFAULT NULL,
                `token` varchar(255) DEFAULT NULL,
                `init_time` int(11) DEFAULT NULL,
                `expire_time` int(11) DEFAULT NULL,
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `user_subscribe_log` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                `user_name` varchar(255) DEFAULT NULL COMMENT 'username',
                `user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'user id',
                `email` varchar(255) DEFAULT NULL COMMENT 'user Email',
                `subscribe_type` varchar(255) DEFAULT NULL COMMENT 'The type of subscription obtained',
                `request_ip` varchar(255) DEFAULT NULL COMMENT 'Request IP',
                `request_time` datetime DEFAULT NULL COMMENT 'request time',
                `request_user_agent` text DEFAULT NULL COMMENT 'Request UA information',
                PRIMARY KEY (`id`),
                KEY `user_id` (`user_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `user_token` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                `token` varchar(255) DEFAULT NULL,
                `user_id` bigint(20) unsigned DEFAULT NULL,
                `create_time` bigint(20) unsigned DEFAULT NULL,
                `expire_time` bigint(20) DEFAULT NULL,
                PRIMARY KEY (`id`),
                KEY `user_id` (`user_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
        );

        return 2023020100;
    }

    public function down(): int
    {
        echo "No reverse operation for initial migration\n";

        return 2023020100;
    }
};

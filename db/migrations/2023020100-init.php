<?php

declare(strict_types=1);

use App\Interfaces\MigrationInterface;
use App\Services\DB;

return new class() implements MigrationInterface {
    public function up(): int
    {
        DB::getPdo()->exec(
            "CREATE TABLE `announcement` (
                `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Announcement ID',
                `date` int(11) unsigned 0 COMMENT 'announcement date',
                `content` text NOT NULL DEFAULT '' COMMENT 'Announcement content',
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `config` (
                `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
                `item` varchar(255) DEFAULT NULL COMMENT 'item',
                `value` varchar(2048) DEFAULT NULL COMMENT 'value',
                `class` varchar(255) DEFAULT 'default' COMMENT 'Configuration classification',
                `is_public` int(11) DEFAULT 0 COMMENT 'Whether it is a public parameter',
                `type` varchar(255) DEFAULT NULL COMMENT 'value type',
                `default` varchar(255) DEFAULT NULL COMMENT 'Defaults',
                `mark` varchar(255) DEFAULT NULL COMMENT 'Remark',
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `detect_ban_log` (
                `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `user_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'User ID',
                `detect_number` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'The number of ban this time',
                `ban_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'The duration of this ban',
                `start_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'Statistics start time',
                `end_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'Statistics end time',
                `all_detect_number` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'total number of violations',
                PRIMARY KEY (`id`),
                KEY `user_id` (`user_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `detect_list` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Audit rule ID',
                `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'rule name',
                `text` varchar(255) NOT NULL DEFAULT '' COMMENT 'rule text',
                `regex` varchar(255) NOT NULL DEFAULT '' COMMENT 'regular expression',
                `type` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'rule type',
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `detect_log` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `user_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'User ID',
                `list_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'rule ID',
                `datetime` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'trigger time',
                `node_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Node ID',
                `status` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'state',
                PRIMARY KEY (`id`),
                KEY `user_id` (`user_id`),
                KEY `node_id` (`node_id`),
                KEY `list_id` (`list_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `docs` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
                `date` datetime NOT NULL DEFAULT '1989-06-04 00:05:00' COMMENT 'document date',
                `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'document title',
                `content` longtext NOT NULL DEFAULT '' COMMENT 'document content',
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `email_queue` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `to_email` varchar(255) NOT NULL DEFAULT '' COMMENT 'recipient email',
                `subject` varchar(255) NOT NULL DEFAULT '' COMMENT 'mail title',
                `template` varchar(255) NOT NULL DEFAULT '' COMMENT 'email template',
                `array` longtext NOT NULL DEFAULT '{}' COMMENT 'Template parameters' CHECK (json_valid(`array`)),
                `time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'add time',
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `gift_card` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'gift card ID',
                `card` text NOT NULL DEFAULT '' COMMENT 'card number',
                `balance` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'balance',
                `create_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'creation time',
                `status` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'status of use',
                `use_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'usage time',
                `use_user` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'user',
                PRIMARY KEY (`id`),
                KEY `id` (`id`),
                KEY `status` (`status`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `invoice` (
                `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Billing ID',
                `user_id` bigint(20) unsigned DEFAULT 0 COMMENT 'Attributed UserID',
                `order_id` bigint(20) unsigned DEFAULT 0 COMMENT 'order ID',
                `content` longtext DEFAULT '{}' COMMENT 'bill content' CHECK (json_valid(`content`)),
                `price` double unsigned DEFAULT 0 COMMENT 'Billing amount',
                `status` varchar(255) DEFAULT '' COMMENT 'Billing Status',
                `create_time` int(11) unsigned DEFAULT 0 COMMENT 'creation time',
                `update_time` int(11) unsigned DEFAULT 0 COMMENT 'update time',
                `pay_time` int(11) unsigned DEFAULT 0 COMMENT 'Payment time',
                PRIMARY KEY (`id`),
                KEY `id` (`id`),
                KEY `user_id` (`user_id`),
                KEY `order_id` (`order_id`),
                KEY `status` (`status`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `link` (
                `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `token` varchar(255) NOT NULL DEFAULT '' COMMENT 'subscription token',
                `userid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'User ID',
                PRIMARY KEY (`id`),
                UNIQUE KEY `token` (`token`),
                UNIQUE KEY `userid` (`userid`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `login_ip` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `userid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'User ID',
                `ip` varchar(255) NOT NULL DEFAULT '' COMMENT 'Login IP',
                `datetime` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'Log in time',
                `type` tinyint(1) unsigned NOT NULL DEFAULT 1 COMMENT 'login type',
                PRIMARY KEY (`id`),
                KEY `userid` (`userid`),
                KEY `type` (`type`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `node` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Node ID',
                `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'node name',
                `type` tinyint(1) unsigned NOT NULL DEFAULT 1 COMMENT 'node display',
                `server` varchar(255) NOT NULL DEFAULT '' COMMENT 'node address',
                `custom_config` longtext NOT NULL DEFAULT '{}' COMMENT 'custom configuration' CHECK (json_valid(`custom_config`)),
                `sort` tinyint(2) unsigned NOT NULL DEFAULT 14 COMMENT 'node type',
                `traffic_rate` float unsigned NOT NULL DEFAULT 1 COMMENT 'Flow rate',
                `is_dynamic_rate` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'enable dynamic traffic ratio',
                `dynamic_rate_type` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT '动态流量倍率计算方式',
                `dynamic_rate_config` longtext NOT NULL DEFAULT '{}' COMMENT 'Dynamic traffic ratio configuration' CHECK (json_valid(`custom_config`)),
                `node_class` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'node level',
                `node_speedlimit` double unsigned NOT NULL DEFAULT 0 COMMENT 'Node speed limit',
                `node_bandwidth` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'node level',
                `node_bandwidth_limit` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Node traffic limit',
                `bandwidthlimit_resetday` tinyint(2) unsigned NOT NULL DEFAULT 0 COMMENT 'Traffic reset date',
                `node_heartbeat` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'node heartbeat',
                `online_user` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'node online user',
                `node_ip` varchar(255) NOT NULL DEFAULT '' COMMENT 'Node IP',
                `node_group` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'node group',
                `online` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'online status',
                `gfw_block` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'is blocked by GFW',
                `password` varchar(255) NOT NULL DEFAULT '' COMMENT 'backend connection password',
                `is_route_dns` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'enable routedns',
                PRIMARY KEY (`id`),
                KEY `type` (`type`),
                KEY `sort` (`sort`),
                KEY `node_class` (`node_class`),
                KEY `node_group` (`node_group`),
                KEY `online` (`online`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
            
            CREATE TABLE `online_log` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `user_id` bigint(20) unsigned NOT NULL COMMENT 'User ID',
                `ip` inet6 NOT NULL COMMENT 'IP address',
                `node_id` int(11) unsigned NOT NULL COMMENT 'Node ID',
                `first_time` int(11) unsigned NOT NULL COMMENT 'first online time',
                `last_time` int(11) unsigned NOT NULL COMMENT 'last online time',
                PRIMARY KEY (`id`),
                UNIQUE KEY (`user_id`, `ip`),
                KEY (`last_time`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `order` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'order ID',
                `user_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'submit userID',
                `product_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Product ID',
                `product_type` varchar(255) NOT NULL DEFAULT '' COMMENT 'Product Types',
                `product_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'product name',
                `product_content` longtext NOT NULL DEFAULT '{}' COMMENT 'product content' CHECK (json_valid(`product_content`)),
                `coupon` varchar(255) NOT NULL DEFAULT '' COMMENT 'Order coupon code',
                `price` double unsigned NOT NULL DEFAULT 0 COMMENT 'total price',
                `status` varchar(255) NOT NULL DEFAULT '' COMMENT 'Order Status',
                `create_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'creation time',
                `update_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'update time',
                PRIMARY KEY (`id`),
                KEY `id` (`id`),
                KEY `user_id` (`user_id`),
                KEY `product_id` (`product_id`),
                KEY `status` (`status`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `payback` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `total` decimal(12,2) unsigned NOT NULL DEFAULT 0 COMMENT 'total amount',
                `userid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'User ID',
                `ref_by` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Referrer ID',
                `ref_get` decimal(12,2) unsigned NOT NULL DEFAULT 0 COMMENT 'Amount received by referrer',
                `datetime` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'creation time',
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `paylist` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `userid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'User ID',
                `total` decimal(12,2) NOT NULL DEFAULT 0 COMMENT 'total amount',
                `status` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'state',
                `invoice_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Billing ID',
                `tradeno` varchar(255) NOT NULL DEFAULT '' COMMENT 'Gateway tracking number',
                `gateway` varchar(255) NOT NULL DEFAULT '' COMMENT 'payment gateway',
                `datetime` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'creation time',
                PRIMARY KEY (`id`),
                KEY `userid` (`userid`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `product` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Product ID',
                `type` varchar(255) NOT NULL DEFAULT 'tabp' COMMENT 'type',
                `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'name',
                `price` double unsigned NOT NULL DEFAULT 0 COMMENT 'selling price',
                `content` longtext NOT NULL DEFAULT '{}' COMMENT 'content' CHECK (json_valid(`content`)),
                `limit` longtext NOT NULL DEFAULT '{}' COMMENT 'purchase limit' CHECK (json_valid(`limit`)),
                `status` tinyint(1) unsigned NOT NULL DEFAULT 1 COMMENT 'sales status',
                `create_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'creation time',
                `update_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'update time',
                `sale_count` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'sale count',
                `stock` int(11) NOT NULL DEFAULT -1 COMMENT 'in stock',
                PRIMARY KEY (`id`),
                KEY `id` (`id`),
                KEY `type` (`type`),
                KEY `status` (`status`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `subscribe_log` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `user_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'User ID',
                `type` varchar(255) NOT NULL DEFAULT '' COMMENT 'Get the subscription type',
                `request_ip` varchar(255) NOT NULL DEFAULT '' COMMENT 'Request IP',
                `request_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'request time',
                `request_user_agent` varchar(255) NOT NULL DEFAULT '' COMMENT 'request UA information',
                PRIMARY KEY (`id`),
                KEY `user_id` (`user_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `ticket` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Ticket ID',
                `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'ticket title',
                `content` longtext NOT NULL DEFAULT '{}' COMMENT 'Ticket Content' CHECK (json_valid(`content`)),
                `userid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'User ID',
                `datetime` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'creation time',
                `status` varchar(255) NOT NULL DEFAULT '' COMMENT 'Ticket Status',
                `type` varchar(255) NOT NULL DEFAULT '' COMMENT 'Ticket Type',
                PRIMARY KEY (`id`),
                KEY `userid` (`userid`),
                KEY `status` (`status`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `user` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'User ID',
                `user_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'username',
                `email` varchar(255) NOT NULL COMMENT 'E-Mail',
                `pass` varchar(255) NOT NULL COMMENT 'login password',
                `passwd` varchar(255) NOT NULL COMMENT 'node password',
                `uuid` char(36) NOT NULL COMMENT 'UUID',
                `u` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'The account\'s current upload traffic',
                `d` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Account current download traffic',
                `transfer_today` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Account traffic used today',
                `transfer_total` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'total traffic usage of the account',
                `transfer_enable` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Account current available traffic',
                `port` smallint(6) unsigned NOT NULL COMMENT 'port',
                `last_detect_ban_time` datetime NOT NULL DEFAULT '1989-06-04 00:05:00' COMMENT 'Last banned time',
                `all_detect_number` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'total number of violations',
                `last_use_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'last used time',
                `last_check_in_time` int(11) unsigned DEFAULT 0 COMMENT 'Last check-in time',
                `last_login_time` int(11) unsigned DEFAULT 0 COMMENT 'last login time',
                `reg_date` datetime NOT NULL DEFAULT '1989-06-04 00:05:00' COMMENT 'Registration time',
                `invite_num` int(11) NOT NULL DEFAULT 0 COMMENT 'Available invitations',
                `money` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Account Balance',
                `ref_by` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Inviter ID',
                `method` varchar(255) NOT NULL DEFAULT 'aes-128-gcm' COMMENT 'Shadowsocks encryption method',
                `reg_ip` varchar(255) NOT NULL DEFAULT '127.0.0.1' COMMENT 'register IP',
                `node_speedlimit` double NOT NULL DEFAULT 0 COMMENT 'user speed limit',
                `node_iplimit` smallint(6) unsigned NOT NULL DEFAULT 0 COMMENT 'The number of IPs that can be connected at the same time',
                `is_admin` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'Are you an administrator',
                `im_type` smallint(6) unsigned NOT NULL DEFAULT 1 COMMENT 'contact type',
                `im_value` varchar(255) NOT NULL DEFAULT '' COMMENT 'Contact information',
                `contact_method` smallint(6) NOT NULL DEFAULT 1 COMMENT '偏好的联系方式',
                `daily_mail_enable` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Daily Report Switch',
                `class` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'level',
                `class_expire` datetime NOT NULL DEFAULT '1989-06-04 00:05:00' COMMENT 'Level Expiration Time',
                `theme` varchar(255) NOT NULL DEFAULT 'tabler' COMMENT 'website theme',
                `ga_token` varchar(255) NOT NULL DEFAULT '' COMMENT 'GA Token',
                `ga_enable` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'GA Enable',
                `remark` text NOT NULL DEFAULT '' COMMENT 'Remark',
                `node_group` smallint(6) unsigned NOT NULL DEFAULT 0 COMMENT 'node grouping',
                `is_banned` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT 'Is banned?',
                `banned_reason` varchar(255) NOT NULL DEFAULT '' COMMENT 'Ban reason',
                `is_shadow_banned` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT '是否处于账户异常状态',
                `expire_notified` tinyint(1)  unsigned NOT NULL DEFAULT 0 COMMENT 'Expiration reminder',
                `traffic_notified` tinyint(1)  unsigned NOT NULL DEFAULT 0 COMMENT 'traffic reminder',
                `forbidden_ip` varchar(255) NOT NULL DEFAULT '' COMMENT 'Forbidden to access IP',
                `forbidden_port` varchar(255) NOT NULL DEFAULT '' COMMENT 'Forbidden port',
                `auto_reset_day` smallint(6) unsigned NOT NULL DEFAULT 0 COMMENT 'Auto reset traffic day',
                `auto_reset_bandwidth` decimal(12,2) unsigned NOT NULL DEFAULT 0 COMMENT 'auto reset traffic',
                `api_token` char(36) NOT NULL DEFAULT '' COMMENT 'API key',
                `is_dark_mode` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT '是否启用暗黑模式',
                `is_inactive` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT '是否处于闲置状态',
                `locale` varchar(16) NOT NULL DEFAULT 'fa-IR' COMMENT 'display language',
                `smart_dns` smallint(5) unsigned DEFAULT NULL COMMENT 'smart dns ip count',
                PRIMARY KEY (`id`),
                UNIQUE KEY `uuid` (`uuid`),
                UNIQUE KEY `email` (`email`),
                UNIQUE KEY `ga_token` (`ga_token`),
                UNIQUE KEY `api_token` (`api_token`),
                KEY `is_admin` (`is_admin`),
                KEY `is_banned` (`is_banned`),
                KEY `is_inactive` (`is_inactive`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `user_coupon` (
                `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Coupon code ID',
                `code` varchar(255) NOT NULL DEFAULT '' COMMENT 'Coupon Code',
                `content` longtext NOT NULL DEFAULT '{}' COMMENT 'Coupon code content' CHECK (json_valid(`content`)),
                `limit` longtext NOT NULL DEFAULT '{}' COMMENT 'Coupon Code Restrictions' CHECK (json_valid(`limit`)),
                `use_count` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'Total use times',
                `create_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'creation time',
                `expire_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'Expiration',
                PRIMARY KEY (`id`),
                KEY `id` (`id`),
                KEY `code` (`code`),
                KEY `expire_time` (`expire_time`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `user_hourly_usage` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `user_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'User ID',
                `traffic` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'current total traffic',
                `hourly_usage` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'traffic in the past hour',
                `datetime` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'record time',
                PRIMARY KEY (`id`),
                KEY `user_id` (`user_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `user_invite_code` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `code` varchar(255) NOT NULL DEFAULT '' COMMENT 'Invitation code',
                `user_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'User ID',
                PRIMARY KEY (`id`),
                UNIQUE KEY `code` (`code`),
                UNIQUE KEY `user_id` (`user_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
            
            CREATE TABLE `user_money_log` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `user_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'User ID',
                `before` decimal(10,2) NOT NULL DEFAULT 0 COMMENT 'Account balance before user change',
                `after` decimal(10,2) NOT NULL DEFAULT 0 COMMENT 'Account balance after user change',
                `amount` decimal(10,2) NOT NULL DEFAULT 0 COMMENT 'total change',
                `remark` text NOT NULL DEFAULT '' COMMENT 'Remark',
                `create_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'creation time',
                PRIMARY KEY (`id`),
                KEY `user_id` (`user_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `stream_media` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `node_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'node ID',
                `result` text NOT NULL DEFAULT '' COMMENT 'Test results',
                `created_at` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'created time',
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            CREATE TABLE `shared_account` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `priority` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'node id',
                `status` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'Test results',
                `create_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'creation time',
                `update_time` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'update time',
                `account` varchar(255) NOT NULL DEFAULT '' COMMENT 'user name',
                `password` varchar(255) NOT NULL DEFAULT '' COMMENT 'account password',
                `country` varchar(255) NOT NULL DEFAULT '' COMMENT 'account registerd country',
                UNIQUE KEY (`account`),
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
            
            CREATE TABLE `smart_dns` (
                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'record ID',
                `node` bigint(20) unsigned NOT NULL COMMENT 'Node ID',
                `userid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'user ID',
                `ip` varchar(255) NOT NULL DEFAULT '' COMMENT 'dns Login IP',
                `mark` varchar(255) NOT NULL DEFAULT '' COMMENT 'Remark',
                `created_at` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'created time',
                `updated_at` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'updated time',
                PRIMARY KEY (`id`),
                UNIQUE KEY (`ip`),
                KEY `userid` (`userid`)
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

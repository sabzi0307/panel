<?php

declare(strict_types=1);

use App\Interfaces\MigrationInterface;
use App\Services\DB;

return new class() implements MigrationInterface {
    public function up(): int
    {
        DB::getPdo()->exec("
            ALTER TABLE node ADD COLUMN IF NOT EXISTS `ipv4` inet4 NOT NULL DEFAULT '127.0.0.1' COMMENT 'IPv4 address';
            ALTER TABLE node ADD COLUMN IF NOT EXISTS `ipv6` inet6 NOT NULL DEFAULT '::1' COMMENT 'IPv6 address';
            ALTER TABLE node DROP COLUMN IF EXISTS `node_ip`;
        ");

        return 2024030300;
    }

    public function down(): int
    {
        DB::getPdo()->exec("
            ALTER TABLE node ADD COLUMN IF NOT EXISTS `node_ip` varchar(255) NOT NULL DEFAULT '' COMMENT 'node IP';
            ALTER TABLE node DROP COLUMN IF EXISTS `ipv4`;
            ALTER TABLE node DROP COLUMN IF EXISTS `ipv6`;
        ");

        return 2024021900;
    }
};

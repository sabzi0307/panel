<?php

declare(strict_types=1);

use App\Interfaces\MigrationInterface;
use App\Services\DB;

return new class() implements MigrationInterface {
    public function up(): int
    {
        DB::getPdo()->exec('
            ALTER TABLE user DROP COLUMN IF EXISTS `invite_num`;
        ');

        return 2024012300;
    }

    public function down(): int
    {
        DB::getPdo()->exec("
            ALTER TABLE user ADD COLUMN IF NOT EXISTS `invite_num` int(11) NOT NULL DEFAULT 0 COMMENT 'تعداد دعوت‌های موجود';
        ");

        return 2024012000;
    }
};

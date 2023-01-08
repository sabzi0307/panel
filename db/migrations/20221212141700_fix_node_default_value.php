<?php

declare(strict_types=1);

use Phinx\Migration\AbstractMigration;

final class FixNodeDefaultValue extends AbstractMigration
{
    public function up(): void
    {
        $this->table('node')
            ->changeColumn('node_speedlimit', 'double', [ 'comment' => 'محدودیت سرعت سرور', 'default' => 0, 'null' => false ])
            ->save();
    }

    public function down(): void
    {
    }
}

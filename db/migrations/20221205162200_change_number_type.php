<?php

declare(strict_types=1);

use Phinx\Migration\AbstractMigration;

final class ChangeNumberType extends AbstractMigration
{
    public function up(): void
    {
        $this->table('user')
            ->changeColumn('port', 'smallinteger', [ 'comment' => 'پورت', 'signed' => false, 'null' => false ])
            ->changeColumn('class', 'integer', [ 'comment' => 'سطح', 'default' => 0, 'signed' => false, 'null' => false ])
            ->changeColumn('node_group', 'integer', [ 'comment' => 'گروه بندی سرور', 'default' => 0, 'signed' => false, 'null' => false ])
            ->changeColumn('node_speedlimit', 'double', [ 'comment' => 'محدودیت سرعت کاربر', 'default' => 0, 'null' => false ])
            ->changeColumn('node_iplimit', 'smallinteger', [ 'comment' => 'تعداد IP هایی که می توان همزمان وصل کرد', 'default' => 0, 'signed' => false, 'null' => false ])
            ->changeColumn('uuid', 'uuid', [ 'comment' => 'UUID', 'null' => false ])
            ->save();
        $this->table('node')
            ->changeColumn('node_speedlimit', 'double', [ 'comment' => 'محدودیت سرعت سرور', 'default' => 0, 'null' => false ])
            ->save();
    }

    public function down(): void
    {
        $this->table('user')
            ->changeColumn('port', 'integer', [ 'comment' => 'پورت کاربر' ])
            ->changeColumn('class', 'integer', [ 'comment' => 'سطح کاربر', 'default' => 0 ])
            ->changeColumn('node_group', 'integer', [ 'comment' => 'گروه بندی سرور', 'default' => 0 ])
            ->changeColumn('node_speedlimit', 'decimal', [ 'comment' => 'محدودیت سرعت در هر اتصال', 'default' => 0 ])
            ->changeColumn('uuid', 'string', [ 'comment' => 'UUID' ])
            ->save();
        $this->table('node')
            ->changeColumn('node_speedlimit', 'decimal', [ 'default' => 0.00,'precision' => 12, 'scale' => 2 ])
            ->save();
    }
}

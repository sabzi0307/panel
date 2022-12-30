<?php

declare(strict_types=1);

use Phinx\Migration\AbstractMigration;

final class AddUserNodeIplimit extends AbstractMigration
{
    public function up(): void
    {
        if (! $this->table('user')->hasColumn('node_iplimit')) {
            $this->table('user')
                ->addColumn('node_iplimit', 'smallinteger', [ 'comment' => 'تعداد IP هایی که می توان همزمان وصل کرد', 'default' => 0, 'signed' => false, 'null' => false ])
                ->save();
        }
    }

    public function down(): void
    {
        $this->table('user')
            ->removeColumn('node_iplimit')
            ->save();
    }
}

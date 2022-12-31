<?php

declare(strict_types=1);

use Phinx\Migration\AbstractMigration;

final class CreateStreamMediaTable extends AbstractMigration
{
    public function up(): void
    {
        $table = $this->table('stream_media');
        $table->addColumn('node_id', 'integer', ['comment' => 'شناسه نود'])
            ->addColumn('result', 'text', ['comment' => 'نتایج آزمون'])
            ->addColumn('created_at', 'integer', ['comment' => 'زمان ایجاد'])
            ->create();
    }

    public function down(): void
    {
        $this->table('stream_media')->drop()->update();
    }
}

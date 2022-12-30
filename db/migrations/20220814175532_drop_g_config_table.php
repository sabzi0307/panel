<?php

declare(strict_types=1);

use Phinx\Migration\AbstractMigration;

final class DropGConfigTable extends AbstractMigration
{
    public function up(): void
    {
        if ($this->hasTable('gconfig')) {
            $this->table('gconfig')->drop()->update();
        }
    }

    public function down(): void
    {
        $this->table('gconfig', [ 'id' => false, 'primary_key' => [ 'id' ]])
            ->addColumn('id', 'integer', [ 'identity' => true,'signed' => false ])
            ->addColumn('key', 'string', [ 'comment' => 'نام کلید تنظیمات' ])
            ->addColumn('type', 'string', [ 'comment' => 'نوع مقدار' ])
            ->addColumn('value', 'string', [ 'comment' => 'مقدار تنظیمات' ])
            ->addColumn('oldvalue', 'string', [ 'comment' => 'مقدار پیکربندی قبلی' ])
            ->addColumn('name', 'string', [ 'comment' => 'نام پیکربندی' ])
            ->addColumn('comment', 'string', [ 'comment' => 'توضیحات پیکربندی' ])
            ->addColumn('operator_id', 'integer', [ 'comment' => 'شناسه اپراتور' ])
            ->addColumn('operator_name', 'string', [ 'comment' => 'نام اپراتور' ])
            ->addColumn('operator_email', 'string', [ 'comment' => 'ایمیل اپراتور' ])
            ->addColumn('last_update', 'biginteger', [ 'comment' => 'زمان را تغییر دهید' ])
            ->create();
    }
}

<?php

declare(strict_types=1);

use Phinx\Migration\AbstractMigration;

final class GiftCardTable extends AbstractMigration
{
    public function up(): void
    {
        if (! $this->hasTable('gift_card')) {
            $this->table('gift_card', [ 'id' => false, 'primary_key' => [ 'id' ]])
                ->addColumn('id', 'biginteger', [ 'identity' => true,'signed' => false ])
                ->addColumn('card', 'text', ['comment' => 'شماره کارت'])
                ->addColumn('balance', 'integer', ['comment' => 'اعتبار'])
                ->addColumn('create_time', 'integer', ['comment' => 'زمان ایجاد'])
                ->addColumn('status', 'integer', ['comment' => 'وضعیت استفاده'])
                ->addColumn('use_time', 'integer', ['comment' => 'زمان استفاده'])
                ->addColumn('use_user', 'integer', ['comment' => 'کاربر'])
                ->addIndex([ 'id' ])
                ->addIndex([ 'status' ])
                ->create();
        }
    }

    public function down(): void
    {
        $this->table('gift_card')->drop()->update();
    }
}

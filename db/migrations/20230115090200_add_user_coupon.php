<?php

declare(strict_types=1);

use Phinx\Migration\AbstractMigration;

final class AddUserCoupon extends AbstractMigration
{
    public function up(): void
    {
        if (! $this->hasTable('user_coupon')) {
            $this->table('user_coupon', [ 'id' => false, 'primary_key' => [ 'id' ]])
                ->addColumn('id', 'integer', [ 'comment' => 'شناسه کد تخفیف', 'identity' => true ])
                ->addColumn('code', 'string', [ 'comment' => 'کد تخفیف' ])
                ->addColumn('content', 'json', [ 'comment' => 'محتوای کد تخفیف' ])
                ->addColumn('limit', 'json', [ 'comment' => 'محدودیت کد تخفیف' ])
                ->addColumn('create_time', 'integer', [ 'comment' => 'زمان ایجاد' ])
                ->addColumn('expire_time', 'integer', [ 'comment' => 'انقضا' ])
                ->addIndex([ 'id' ])
                ->addIndex([ 'code' ])
                ->addIndex([ 'expire_time' ])
                ->create();
        }
    }

    public function down(): void
    {
        $this->table('user_coupon')->drop()->update();
    }
}

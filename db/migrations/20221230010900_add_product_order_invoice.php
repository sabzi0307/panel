<?php

declare(strict_types=1);

use Phinx\Migration\AbstractMigration;

final class AddProductOrderInvoice extends AbstractMigration
{
    public function up(): void
    {
        if (! $this->hasTable('product')) {
            $this->table('product', [ 'id' => false, 'primary_key' => [ 'id' ]])
                ->addColumn('id', 'integer', [ 'comment' => 'شناسه سرویس', 'identity' => true ])
                ->addColumn('type', 'string', [ 'comment' => 'انواع' ])
                ->addColumn('name', 'string', [ 'comment' => 'نام' ])
                ->addColumn('price', 'double', [ 'comment' => 'قیمت فروش' ])
                ->addColumn('content', 'json', [ 'comment' => 'محتوا' ])
                ->addColumn('limit', 'json', [ 'comment' => 'محدودیت خرید'])
                ->addColumn('status', 'integer', [ 'comment' => 'وضعیت فروش' ])
                ->addColumn('create_time', 'integer', [ 'comment' => 'زمان ایجاد' ])
                ->addColumn('update_time', 'integer', [ 'comment' => 'زمان به روز رسانی' ])
                ->addColumn('sale_count', 'integer', [ 'comment' => 'تعداد'])
                ->addColumn('stock', 'integer', [ 'comment' => 'در انبار'])
                ->addIndex([ 'id' ])
                ->addIndex([ 'type' ])
                ->create();
        }

        if (! $this->hasTable('order')) {
            $this->table('order', [ 'id' => false, 'primary_key' => [ 'id' ]])
                ->addColumn('id', 'integer', [ 'comment' => 'شماره سفارش', 'identity' => true ])
                ->addColumn('user_id', 'integer', [ 'comment' => 'شناسه کاربر' ])
                ->addColumn('product_id', 'integer', [ 'comment' => 'شناسه سرویس' ])
                ->addColumn('product_type', 'string', [ 'comment' => 'انواع سرویس' ])
                ->addColumn('product_name', 'string', [ 'comment' => 'نام سرویس' ])
                ->addColumn('product_content', 'json', [ 'comment' => 'محتوای سرویس' ])
                ->addColumn('coupon', 'string', [ 'comment' => 'سفارش کد تخفیف'])
                ->addColumn('price', 'double', [ 'comment' => 'تعداد' ])
                ->addColumn('status', 'string', [ 'comment' => 'وضعیت سفارش' ])
                ->addColumn('create_time', 'integer', [ 'comment' => 'زمان ایجاد' ])
                ->addColumn('update_time', 'integer', [ 'comment' => 'زمان به روز رسانی' ])
                ->addIndex([ 'id' ])
                ->addIndex([ 'user_id' ])
                ->addIndex([ 'product_id' ])
                ->addIndex([ 'status' ])
                ->create();
        }

        if (! $this->hasTable('invoice')) {
            $this->table('invoice', [ 'id' => false, 'primary_key' => [ 'id' ]])
                ->addColumn('id', 'integer', [ 'comment' => 'شناسه صورتحساب', 'identity' => true ])
                ->addColumn('user_id', 'integer', [ 'comment' => 'کاربر منتسب' ])
                ->addColumn('order_id', 'integer', [ 'comment' => 'شماره سفارش' ])
                ->addColumn('content', 'json', [ 'comment' => 'محتوای صورت حساب' ])
                ->addColumn('price', 'double', [ 'comment' => 'مبلغ صورتحساب' ])
                ->addColumn('status', 'string', [ 'comment' => 'وضعیت صورتحساب' ])
                ->addColumn('create_time', 'integer', [ 'comment' => 'زمان ایجاد' ])
                ->addColumn('update_time', 'integer', [ 'comment' => 'زمان به روز رسانی' ])
                ->addColumn('pay_time', 'integer', [ 'comment' => 'زمان پرداخت' ])
                ->addIndex([ 'id' ])
                ->addIndex([ 'user_id' ])
                ->addIndex([ 'order_id' ])
                ->addIndex([ 'status' ])
                ->create();
        }
    }

    public function down(): void
    {
        $this->table('product')->drop()->update();
        $this->table('order')->drop()->update();
        $this->table('invoice')->drop()->update();
    }
}

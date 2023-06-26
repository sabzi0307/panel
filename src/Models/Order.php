<?php

declare(strict_types=1);

namespace App\Models;

final class Order extends Model
{
    protected $connection = 'default';
    protected $table = 'order';

    /**
     * 订单状态
     */
    public function status(): string
    {
        return match ($this->status) {
            'pending_payment' => 'منتظر تایید پرداخت',
            'pending_activation' => 'منتظر فعال سازی',
            'activated' => 'فعال شده',
            'expired' => 'منقضی شده',
            'cancelled' => 'لغو شده',
            default => 'ناشناخته',
        };
    }

    /**
     * 订单商品类型
     */
    public function productType(): string
    {
        return match ($this->product_type) {
            'tabp' => 'بسته ترافیک زمانی',
            'time' => 'بسته زمانی',
            'bandwidth' => 'بسته ترافیک',
            default => 'سایر',
        };
    }
}

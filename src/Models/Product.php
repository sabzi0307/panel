<?php

declare(strict_types=1);

namespace App\Models;

final class Product extends Model
{
    protected $connection = 'default';
    protected $table = 'product';

    /**
     * 商品状态
     */
    public function status(): string
    {
        return $this->status ? 'عادی' : 'توقف فروش';
    }

    /**
     * 商品类型
     */
    public function type(): string
    {
        return match ($this->type) {
            'tabp' => 'بسته ترافیک زمانی',
            'time' => 'بسته زمانی',
            'bandwidth' => 'بسته ترافیک',
            default => 'سایر',
        };
    }

    /**
     * 商品库存
     */
    public function stock(): string|int
    {
        return $this->stock < 0 ? 'نامحدود' : $this->stock;
    }
}

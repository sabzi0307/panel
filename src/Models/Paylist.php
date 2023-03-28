<?php

declare(strict_types=1);

namespace App\Models;

final class Paylist extends Model
{
    protected $connection = 'default';
    protected $table = 'paylist';

    /**
     * 网关记录状态
     */
    public function status(): string
    {
        return match ($this->status) {
            0 => 'پرداخت نشده',
            1 => 'پرداخت شده',
            default => 'ناشناخته',
        };
    }
}

<?php

declare(strict_types=1);

namespace App\Models;

final class Invoice extends Model
{
    protected $connection = 'default';
    protected $table = 'invoice';

    /**
     * 账单状态
     */
    public function status(): string
    {
        return match ($this->status) {
            'unpaid' => 'پرداخت نشده',
            'paid_gateway' => 'پرداخت شده (درگاه پرداخت)',
            'paid_balance' => 'پرداخت شده (موجودی حساب)',
            'paid_admin' => 'پرداخت شده (ادمین)',
            'cancelled' => 'لغو شد',
            default => 'ناشناخته',
        };
    }
}

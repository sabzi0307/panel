<?php

declare(strict_types=1);

namespace App\Models;

/**
 * Ticket Model
 */
final class Ticket extends Model
{
    protected $connection = 'default';
    protected $table = 'ticket';

    /**
     * 工单类型
     */
    public function type(): string
    {
        return match ($this->type) {
            'howto' => 'نحوه استفاده',
            'billing' => 'امور مالی',
            'account' => 'حساب کاربری',
            default => 'سایر',
        };
    }

    /**
     * 工单状态
     */
    public function status(): string
    {
        return match ($this->status) {
            'closed' => 'بسته شده',
            'open_wait_user' => 'منتظر پاسخ کاربر',
            'open_wait_admin' => 'در حال انجام',
            default => 'ناشناخته',
        };
    }
}

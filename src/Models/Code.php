<?php

declare(strict_types=1);

namespace App\Models;

/**
 * Code Model
 */
final class Code extends Model
{
    protected $connection = 'default';

    protected $table = 'code';

    /**
     * 用户
     */
    public function user(): ?User
    {
        return User::find($this->userid);
    }

    /**
     * 用户 ID
     */
    public function userid(): int
    {
        return $this->userid;
    }

    /**
     * 用户名
     */
    public function userName(): string
    {
        if ($this->userid === 0) {
            return 'استفاده نشده';
        }
        if ($this->user() === null) {
            return 'کاربر دیگر وجود ندارد';
        }
        return $this->user()->user_name;
    }

    /**
     * 类型
     */
    public function type(): string
    {
        return match ($this->type) {
            -1 => 'مقدار شارژ مجدد',
            -2 => 'هزینه های مالی',
            default => 'منسوخ شده',
        };
    }

    /**
     * 操作
     */
    public function number(): string
    {
        return match ($this->type) {
            -1 => 'شارژ مجدد ' . $this->number . ' تومان',
            -2 => 'هزینه های مالی ' . $this->number . ' تومان',
            default => 'منسوخ شده',
        };
    }

    /**
     * 是否已经使用
     */
    public function isused(): string
    {
        return $this->isused === 1 ? 'استفاده شده' : 'استفاده نشده';
    }

    /**
     * 使用时间
     */
    public function usedatetime(): string
    {
        return $this->usedatetime > '2000-1-1 0:0:0' ? $this->usedatetime : 'استفاده نشده';
    }
}

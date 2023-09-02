<?php

declare(strict_types=1);

namespace App\Models;

use function json_decode;
use function time;

final class UserCoupon extends Model
{
    protected $connection = 'default';
    protected $table = 'user_coupon';

    /**
     * 优惠码类型
     */
    public function type(): string
    {
        return match (json_decode($this->content)) {
            'percentage' => 'درصد',
            'fixed' => 'مقدار ثابت',
            default => 'ناشناخته',
        };
    }

    /**
     * 优惠码状态
     */
    public function status(): string
    {
        return $this->expire_time < time() ? "منقضی شده" : "فعال شده";
    }
}

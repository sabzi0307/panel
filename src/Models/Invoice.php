<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Query\Builder;

/**
 * @property int    $id          账单ID
 * @property int    $user_id     归属用户ID
 * @property string $order_id    订单ID
 * @property string $content     账单内容
 * @property float  $price       账单金额
 * @property string $status      账单状态
 * @property int    $create_time 创建时间
 * @property int    $update_time 更新时间
 * @property int    $pay_time    支付时间
 *
 * @mixin Builder
 */
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

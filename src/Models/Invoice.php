<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Query\Builder;
use function in_array;
use function json_decode;
use function json_encode;
use function time;

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
            'refunded_balance' => 'بازپرداخت (موجودی حساب)',
            default => 'ناشناخته',
        };
    }

    public function refundToBalance(): void
    {
        if (in_array($this->status, ['paid_gateway', 'paid_balance', 'paid_admin'])) {
            $user = (new User())->find($this->user_id);
            $user->money += $this->price;
            $user->save();

            (new UserMoneyLog())->add(
                $user->id,
                $user->money - $this->price,
                $user->money,
                $this->price,
                $this->id . ' بازپرداخت به مانده حساب صورت حساب #'
            );

            $content = json_decode($this->content, true);
            $content[] = [
                'content_id' => count($content),
                'name' => 'بازپرداخت به مانده حساب',
                'price' => '-' . $this->price,
            ];

            $this->content = json_encode($content);
            $this->status = 'refunded_balance';
            $this->update_time = time();
            $this->save();
        }
    }
}

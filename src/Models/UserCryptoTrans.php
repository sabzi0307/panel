<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Query\Builder;
use function time;

/**
 * @property int $id 记录ID
 * @property int $user_id 用户ID
 * @property string $tran_hash 用户变动前账户余额
 * @property string $tran_type 用户变动前账户余额 BSC-USD
 * @property string $tran_status 用户变动后账户余额
 * @property float $tran_amount 变动总额
 * @property string $tran_block 备注
 * @property int $tran_time 创建时间
 * @property int $create_time 创建时间
 *
 * @mixin Builder
 */
final class UserCryptoTrans extends Model
{
    protected $connection = 'default';
    protected $table = 'user_crypto_tran';

    public function add(int $user_id, $tran): void
    {
        $this->user_id = $user_id;
        $this->tran_amount = $tran['balance'];
        $this->tran_type = $tran['type'];
        $this->tran_block = $tran['block'];
        $this->tran_status = $tran['status'];
        $this->tran_time = $tran['timestamp'];
        $this->tran_hash = $tran['hash'];
        $this->create_time = time();
        $this->save();
    }
}

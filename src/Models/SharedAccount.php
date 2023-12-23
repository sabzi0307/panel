<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Query\Builder;

/**
 * @property int    $id          商品ID
 * @property int    $priority        类型
 * @property int    $status        名称
 * @property int    $create_time 创建时间
 * @property int    $update_time 更新时间
 * @property int    $account  累计销量
 * @property int    $password       库存
 * @property int    $country       库存
 *
 * @mixin Builder
 */

final class SharedAccount extends Model
{
    protected $connection = 'default';
    protected $table = 'shared_account';
}

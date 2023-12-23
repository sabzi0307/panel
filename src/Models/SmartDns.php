<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Query\Builder;

/**
 * @property int        $id          商品ID
 * @property int        $node        类型
 * @property int        $userid        名称
 * @property int        $create_time 创建时间
 * @property int        $update_time 更新时间
 * @property string     $ip  累计销量
 * @property string     $mark       库存
 *
 * @mixin Builder
 */

final class SmartDns extends Model
{
    protected $connection = 'default';
    protected $table = 'smart_dns';
}

<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Query\Builder;

/**
 * @property int        $id          商品ID
 * @property string     $token        类型
 * @property string     $customer_id 类型
 * @property string     $name 类型
 * @property string     $login 类型
 * @property int        $created_at 创建时间
 * @property int        $updated_at 更新时间
 *
 * @mixin Builder
 */

final class Fastly extends Model
{
    protected $connection = 'default';
    protected $table = 'fastly';
}

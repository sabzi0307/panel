<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Query\Builder;

/**
 * @property int        $id          商品ID
 * @property int        $node_id        类型
 * @property int        $create_time 创建时间
 * @property string     $result  累计销量
 *
 * @mixin Builder
 */

final class StreamMedia extends Model
{
    protected $connection = 'default';
    protected $table = 'stream_media';
}

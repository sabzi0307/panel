<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Query\Builder;
use function json_decode;
use function time;

/**
 * @property int    $id          优惠码ID
 * @property int $user_id 
 * @property string $state        :'waiting_for_giftcard' , 'waiting_for_transaction' , 'none' ,
 * @property string $content     优惠码内容
 * @property int    $create_time 创建时间
 * @property int    $last_update_time 创建时间
 
 *
 * @mixin Builder
 */
final class TelegramBotState extends Model
{
    protected $connection = 'default';
    protected $table = 'telegram_bot_state';

   

    public function add(int $user_id, string $state,string $content): void
    {
        $this->user_id = $user_id;
        $this->state = $state;
        $this->content = $content;
        $this->create_time = time();
        $this->save();
    }
   
}

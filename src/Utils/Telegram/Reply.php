<?php

declare(strict_types=1);

namespace App\Utils\Telegram;

use App\Models\Bought;

final class Reply
{
    /**
     * 用户的流量使用讯息
     */
    public static function getUserTrafficInfo(\App\Models\User $user): string
    {
        $text = [
            'وضعیت ترافیک فعلی شما:',
            '',
            'امروزه استفاده می شود ' . $user->todayUsedTrafficPercent() . '% ：' . $user->todayUsedTraffic(),
            'قبل استفاده شده ' . $user->lastUsedTrafficPercent() . '% ：' . $user->lastUsedTraffic(),
            'ترافیک تقریباً باقی مانده است ' . $user->unusedTrafficPercent() . '% ：' . $user->unusedTraffic(),
        ];
        return implode(PHP_EOL, $text);
    }

    /**
     * 用户基本讯息
     */
    public static function getUserInfo(\App\Models\User $user): string
    {
        $text = [
            'موجودی فعلی: ' . $user->money,
            'دستگاه آنلاین：' . ($user->node_connector !== 0 ? $user->onlineIpCount() . ' / ' . $user->node_connector : $user->onlineIpCount() . ' / بدون محدودیت'),
            'سرعت پورت：' . ($user->node_speedlimit !== 0 ? $user->node_speedlimit . 'Mbps' : 'نامحدود'),
            'آخرین استفاده：' . $user->lastSsTime(),
            'تاریخ انقضا：' . $user->class_expire,
        ];
        return implode(PHP_EOL, $text);
    }

    /**
     * 获取用户或管理的尊称
     */
    public static function getUserTitle(\App\Models\User $user): string
    {
        if ($user->class > 0) {
            $text = 'عزیز VIP ' . $user->class . ' سلام：';
        } else {
            $text = 'کاربران گرامی سلام：';
        }
        return $text;
    }

    /**
     * [admin]获取用户购买记录
     *
     * @return array
     */
    public static function getUserBoughts(\App\Models\User $user): array
    {
        $boughts = Bought::where('userid', $user->id)->orderBy('id', 'desc')->get();
        $data = [];
        foreach ($boughts as $bought) {
            $shop = $bought->shop();
            if ($shop === null) {
                $bought->delete();
                continue;
            }
            if ($bought->valid()) {
                $strArray = [];
                $strArray[] = ' - نام بسته کالا：' . $shop->name;
                $strArray[] = ' - زمان خرید بسته：' . $bought->datetime();
                $strArray[] = ' - تمدید خودکار بسته：' . $bought->renew();
                $strArray[] = ' - تنظیم مجدد ترافیک بعدی：' . $bought->resetTime();
                $strArray[] = ' - زمان انقضای بسته：' . $bought->expTime();
                $strArray[] = '';
                $data[] = implode(PHP_EOL, $strArray);
            }
        }
        return $data;
    }

    /**
     * [admin]获取用户信息
     */
    public static function getUserInfoFromAdmin(\App\Models\User $user, int $ChatID): string
    {
        $strArray = [
            '#' . $user->id . ' ' . $user->user_name . ' اطلاعات کاربر',
            '',
            'ایمیل کاربر：' . TelegramTools::getUserEmail($user->email, $ChatID),
            'موجودی حساب：' . $user->money,
            'وضعیت حساب：' . ((int) $user->is_banned === 1 ? 'ممنوع شده' : 'نرمال'),
            'سطح کاربر：' . $user->class,
            'ترافیک باقیمانده：' . $user->unusedTraffic(),
            'انقضای سطح：' . $user->class_expire,
            'انقصای حساب：' . $user->expire_in,
            'جزئیات بسته：',
        ];
        $boughts = self::getUserBoughts($user);
        if (count($boughts) !== 0) {
            $strArray = array_merge($strArray, $boughts);
        } else {
            $strArray[] = ' - کاربر بسته معتبری ندارد.';
        }
        return implode(PHP_EOL, $strArray);
    }
}

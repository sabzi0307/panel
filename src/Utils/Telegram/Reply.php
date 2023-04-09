<?php

declare(strict_types=1);

namespace App\Utils\Telegram;

use App\Models\User;

final class Reply
{
    /**
     * 用户的流量使用讯息
     */
    public static function getUserTrafficInfo(User $user): string
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
    public static function getUserInfo(User $user): string
    {
        $text = [
            'موجودی فعلی: ' . $user->money,
            'تعداد IP های آنلاین：' . ($user->node_iplimit !== 0 ? $user->onlineIpCount() . ' / ' . $user->node_iplimit : $user->onlineIpCount() . ' / بدون محدودیت'),
            'سرعت درگاه: ' . ($user->node_speedlimit > 0 ? $user->node_speedlimit . 'Mbps' : 'بدون محدودیت'),
            'آخرین استفاده: ' . $user->lastSsTime(),
            'انقضا: ' . $user->class_expire,
        ];
        return implode(PHP_EOL, $text);
    }

    /**
     * 获取用户或管理的尊称
     */
    public static function getUserTitle(User $user): string
    {
        if ($user->class > 0) {
            $text = 'عزیز VIP ' . $user->class . ' سلام：';
        } else {
            $text = 'کاربران گرامی سلام：';
        }
        return $text;
    }

    /**
     * [admin]获取用户信息
     */
    public static function getUserInfoFromAdmin(User $user, int $ChatID): string
    {
        $strArray = [
            '#' . $user->id . ' ' . $user->user_name . ' اطلاعات کاربر',
            '',
            'ایمیل کاربر：' . TelegramTools::getUserEmail($user->email, $ChatID),
            'موجودی حساب：' . $user->money,
            'وضعیت حساب：' . ((int) $user->is_banned === 1 ? 'ممنوع شده' : 'عادی'),
            'سطح کاربری：' . $user->class,
            'ترافیک باقیمانده：' . $user->unusedTraffic(),
            'انقضای سطح کاربری：' . $user->class_expire,
            'انقضای حساب کاربری：' . $user->expire_in,
        ];
        return implode(PHP_EOL, $strArray);
    }
}

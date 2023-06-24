<?php

declare(strict_types=1);

namespace App\Utils\Telegram;

use App\Models\Setting;
use App\Models\User;
use App\Models\UserMoneyLog;
use App\Utils\Tools;
use function array_map;
use function count;
use function curl_close;
use function curl_exec;
use function curl_init;
use function curl_setopt;
use function date;
use function explode;
use function implode;
use function in_array;
use function is_numeric;
use function json_encode;
use function number_format;
use function str_pad;
use function stripos;
use function strlen;
use function strpos;
use function strtotime;
use function substr;
use function time;
use function trim;
use const CURLOPT_HTTPHEADER;
use const CURLOPT_POST;
use const CURLOPT_POSTFIELDS;
use const CURLOPT_TIMEOUT;
use const CURLOPT_URL;
use const PHP_EOL;

final class TelegramTools
{
    /**
     * 搜索用户
     *
     * @param int $value  搜索值
     * @param string $method 查找列
     */
    public static function getUser(int $value, string $method = 'telegram_id')
    {
        return User::where($method, $value)->first();
    }

    /**
     * Sends a POST request to Telegram Bot API.
     * 伪异步，无结果返回.
     *
     * @param $Method
     * @param $Params
     */
    public static function sendPost($Method, $Params): void
    {
        $URL = 'https://api.telegram.org/bot' . $_ENV['telegram_token'] . '/' . $Method;
        $POSTData = json_encode($Params);
        $C = curl_init();
        curl_setopt($C, CURLOPT_URL, $URL);
        curl_setopt($C, CURLOPT_POST, 1);
        curl_setopt($C, CURLOPT_HTTPHEADER, ['Content-Type:application/json; charset=utf-8']);
        curl_setopt($C, CURLOPT_POSTFIELDS, $POSTData);
        curl_setopt($C, CURLOPT_TIMEOUT, 1);
        curl_exec($C);
        curl_close($C);
    }

    /**
     * 用户识别搜索字段
     *
     * @return array
     */
    public static function getUserSearchMethods(): array
    {
        return [
            'id' => [],
            'email' => ['email'],
            'port' => ['port'],
        ];
    }

    /**
     * 操作字段
     *
     * @return array
     */
    public static function getUserActionOption(): array
    {
        return [
            'is_admin' => ['is_admin'],
            'banned' => ['banned'],
            'money' => ['remark_user_option_money'],
            'port' => ['port'],
            'transfer_enable' => ['transfer_enable'],
            'passwd' => ['passwd'],
            'method' => ['method'],
            'invite_num' => ['invite_num'],
            'node_group' => ['node_group'],
            'class' => ['class'],
            'class_expire' => ['class_expire'],
            'expire_in' => ['expire_in'],
            'node_speedlimit' => ['node_speedlimit'],
            'node_iplimit' => ['node_iplimit'],
        ];
    }

    /**
     * 待定
     *
     * @param $User
     * @param $useOptionMethod
     * @param $value
     * @param $ChatID
     *
     * @return array
     */
    public static function operationUser($User, $useOptionMethod, $value, $ChatID): array
    {
        $Email = self::getUserEmail($User->email, $ChatID);
        $old = $User->$useOptionMethod;
        $useOptionMethodName = self::getUserActionOption()[$useOptionMethod][0];
        switch ($useOptionMethod) {
            // ##############
            case 'is_banned':
            case 'is_admin':
                $strArray = [
                    '// پشتیبانی از نوشتن',
                    '// [فعال|بله] —— معنای لغوی',
                    '// [غیرفعال کردن|خیر] —— معنای لغوی',
                ];
                if (str_contains($value, ' ')) {
                    return [
                        'ok' => false,
                        'msg' => 'خطای پردازش، نوشتن پشتیبانی نشده است.' . PHP_EOL . PHP_EOL . self::strArrayToCode($strArray),
                    ];
                }
                if (in_array($value, ['فعال کردن', 'بله'])) {
                    $User->$useOptionMethod = 1;
                    $new = 'فعال کردن';
                } elseif (in_array($value, ['غیر فعال', 'خیر'])) {
                    $User->$useOptionMethod = 0;
                    $new = 'غیر فعال';
                } else {
                    return [
                        'ok' => false,
                        'msg' => 'خطای پردازش，املای پشتیبانی نشده.' . PHP_EOL . PHP_EOL . self::strArrayToCode($strArray),
                    ];
                }
                $old = ($old ? 'فعال کردن' : 'غیر فعال');
                break;
                // ##############
            case 'port':
                // 支持正整数或 0 随机选择
                if (! is_numeric($value) || str_starts_with((string) $value, '-')) {
                    return [
                        'ok' => false,
                        'msg' => 'پورت ارائه شده غیر عددی است، 0 را برای تنظیم مجدد تصادفی مشخص کنید.',
                    ];
                }
                if ((int) $value === 0) {
                    $value = Tools::getAvPort();
                }
                $temp = $User->setPort($value);
                if ($temp['ok'] === false) {
                    $strArray = [
                        'کاربران را مورد هدف قرار دهید：' . $Email,
                        'موردی که باید اصلاح شود：' . $useOptionMethodName . '[' . $useOptionMethod . ']',
                        'مقدار فعلی：' . $old,
                        'می خواهند تغییر کنند به：' . $value,
                        'جزئیات خطا：' . $temp['msg'],
                    ];
                    return [
                        'ok' => false,
                        'msg' => self::strArrayToCode($strArray),
                    ];
                }
                $new = $User->$useOptionMethod;
                $User->$useOptionMethod = $new;
                break;
                // ##############
            case 'transfer_enable':
                $strArray = [
                    '// نوشتن پشتیبانی شده، واحد b را پشتیبانی نمی کند، به حروف بزرگ و کوچک حساس نیست',
                    '// واحدهای پشتیبانی شده：kb | mb | gb | tb | pb',
                    '//  2kb —— به عنوان جریان ارزش تعیین می شود',
                    '// +2kb —— افزایش ترافیک',
                    '// -2kb —— کاهش ترافیک',
                    '// *2   —— ضرب در ترافیک کنونی، از پر کردن واحد پشتیبانی نمی کند',
                    '// /2   —— تقسیم بر ترافیک فعلی، از پر کردن واحد پشتیبانی نمی کند',
                ];
                if (str_contains($value, ' ')) {
                    return [
                        'ok' => false,
                        'msg' => 'خطای پردازش، نوشتن پشتیبانی نشده است.' . PHP_EOL . PHP_EOL . self::strArrayToCode($strArray),
                    ];
                }
                $new = self::trafficMethod($User->$useOptionMethod, $value);
                if ($new === null) {
                    return [
                        'ok' => false,
                        'msg' => 'خطای پردازش، نوشتن پشتیبانی نشده است.' . PHP_EOL . PHP_EOL . self::strArrayToCode($strArray),
                    ];
                }
                $User->$useOptionMethod = $new;
                $old = Tools::autoBytes($old);
                $new = Tools::autoBytes($new);
                break;
                // ##############
            case 'expire_in':
            case 'class_expire':
                $strArray = [
                    '// روش های نوشتاری پشتیبانی شده، واحد: روز',
                    '// تنظیم روزهای استفاده نمی تواند حاوی فاصله باشد',
                    '//  2 —— تعداد روزها را بر اساس زمان فعلی تنظیم کنید',
                    '// +2 —— تعداد روزها را افزایش دهید',
                    '// -2 —— تعداد روزها را کاهش دهید',
                    '// تاریخ را با فاصله بین تاریخ و زمان مشخص کنید',
                    '// 2020-02-30 —— تاریخ مشخص شده',
                    '// 2020-02-30 08:00:00 —— تاریخ مشخص شده به دومی دقیق می باشد',
                ];
                if (
                    str_starts_with($value, '+')
                    ||
                    str_starts_with($value, '-')
                ) {
                    $operator = substr($value, 0, 1);
                    $number = substr($value, 1);
                    if (is_numeric($number)) {
                        $number *= 86400;
                        $old_time = strtotime($old);
                        $new = ($operator === '+' ? $old_time + $number : $old_time - $number);
                        $new = date('Y-m-d H:i:s', (int) $new);
                    } else {
                        if (strtotime($value) === false) {
                            return [
                                'ok' => false,
                                'msg' => 'خطای پردازش، نوشتن پشتیبانی نشده است.' . PHP_EOL . PHP_EOL . self::strArrayToCode($strArray),
                            ];
                        }
                        $new = strtotime($value);
                        $new = date('Y-m-d H:i:s', $new);
                    }
                } else {
                    $number = $value;
                    if (is_numeric($value)) {
                        $number *= 86400;
                        $new = time() + $number;
                        $new = date('Y-m-d H:i:s', (int) $new);
                    } else {
                        if (strtotime($value) === false) {
                            return [
                                'ok' => false,
                                'msg' => 'خطای پردازش، نوشتن پشتیبانی نشده است.' . PHP_EOL . PHP_EOL . self::strArrayToCode($strArray),
                            ];
                        }
                        $new = strtotime($value);
                        $new = date('Y-m-d H:i:s', $new);
                    }
                }
                $User->$useOptionMethod = $new;
                break;
                // ##############
            case 'method':
            case 'passwd':
            case 'money':
                $strArray = [
                    '// فاصله در مقدار پارامتر مجاز نیست، نتیجه شامل 2 رقم اعشار خواهد بود',
                    '// +2  —— افزایش اعتبار',
                    '// -2  —— کاهش اعتبار',
                    '// *2  —— ضرب در موجودی فعلی',
                    '// /2  —— تقسیم بر موجودی فعلی',
                ];
                $value = explode(' ', $value)[0];
                $new = self::computingMethod($User->$useOptionMethod, $value, true);
                if ($new === null) {
                    return [
                        'ok' => false,
                        'msg' => 'خطای پردازش، نوشتن پشتیبانی نشده است.'  . PHP_EOL . PHP_EOL . self::strArrayToCode($strArray),
                    ];
                }
                $User->$useOptionMethod = $new;
                break;
                // ##############
            case 'class':
            case 'invite_num':
            case 'node_group':
            case 'node_iplimit':
            case 'node_speedlimit':
                $strArray = [
                    '// فاصله در مقادیر پارامتر مجاز نیست',
                    '// +2  —— افزودن سطح',
                    '// -2  —— کاهش سطح',
                    '// *2  —— ضرب در مقدار فعلی',
                    '// /2  —— تقسیم بر مقدار فعلی',
                ];
                $value = explode(' ', $value)[0];
                $new = self::computingMethod($User->$useOptionMethod, $value);
                if ($new === null) {
                    return [
                        'ok' => false,
                        'msg' => 'خطای پردازش، نوشتن پشتیبانی نشده است.'  . PHP_EOL . PHP_EOL . self::strArrayToCode($strArray),
                    ];
                }
                $User->$useOptionMethod = $new;
                break;
                // ##############
            default:
                return [
                    'ok' => false,
                    'msg' => 'هنوز پشتیبانی نشده است.',
                ];
        }
        if ($User->save()) {
            if ($useOptionMethod === 'money') {
                $diff = $new - $old;
                $remark = ($diff > 0 ? 'Admin اضافه کردن مالی' : 'مدیر موجودی را کم می کند');
                (new UserMoneyLog())->addMoneyLog($User->id, (float) $old, (float) $new, (float) $diff, $remark);
            }
            $strArray = [
                'کاربران را هدف قرار دهید：' . $Email,
                'مورد اصلاح شده：' . $useOptionMethodName . '[' . $useOptionMethod . ']',
                'قبل از تغییر：' . $old,
                'اصلاح شده به：' . $new,
            ];
            return [
                'ok' => true,
                'msg' => self::strArrayToCode($strArray),
            ];
        }
        return [
            'ok' => false,
            'msg' => 'خطا در ذخیره',
        ];
    }

    /**
     * 获取用户邮箱
     *
     * @param string $email  邮箱
     * @param int    $ChatID 会话 ID
     */
    public static function getUserEmail(string $email, int $ChatID): string
    {
        if (Setting::obtain('enable_user_email_group_show') || $ChatID > 0) {
            return $email;
        }
        $a = strpos($email, '@');
        if ($a === false) {
            return $email;
        }
        $string = substr($email, $a);
        return $a === 1 ? '*' . $string : substr($email, 0, 1) . str_pad('', $a - 1, '*') . $string;
    }

    /**
     * 分割字符串
     *
     * @param string $Str       源字符串
     * @param string $Delimiter 分割定界符
     * @param int    $Quantity  最大返回数量
     *
     * @return array
     */
    public static function strExplode(string $Str, string $Delimiter, int $Quantity = 10): array
    {
        $return = [];
        $Str = trim($Str);
        for ($x = 0; $x <= 10; $x++) {
            if (str_contains($Str, $Delimiter) && count($return) < $Quantity - 1) {
                $temp = substr($Str, 0, strpos($Str, $Delimiter));
                $return[] = $temp;
                $Str = trim(substr($Str, strlen($temp)));
            } else {
                $return[] = $Str;
                break;
            }
        }
        return $return;
    }

    /**
     * 查找字符串是否是某个方法的别名
     *
     * @param array  $MethodGroup 方法别名的数组
     * @param string $Search      被搜索的字符串
     */
    public static function getOptionMethod(array $MethodGroup, string $Search): string
    {
        $useMethod = '';
        foreach ($MethodGroup as $MethodName => $Remarks) {
            if (strlen($MethodName) === strlen($Search) && stripos($MethodName, $Search) === 0) {
                $useMethod = $MethodName;
                break;
            }
            if (count($Remarks) >= 1) {
                foreach ($Remarks as $Remark) {
                    if (strlen($Remark) === strlen($Search) && stripos($Remark, $Search) === 0) {
                        $useMethod = $MethodName;
                        break 2;
                    }
                }
            }
        }
        return $useMethod;
    }

    /**
     * 使用 $Value 给定的运算式与 $Source 计算结果
     *
     * @param string $Source         源数值
     * @param string $Value          运算式含增改数值
     * @param bool   $FloatingNumber 是否格式化为浮点数
     */
    public static function computingMethod(string $Source, string $Value, bool $FloatingNumber = false): ?string
    {
        if (
            (str_starts_with($Value, '+')
                ||
                str_starts_with($Value, '-')
                ||
                str_starts_with($Value, '*')
                ||
                str_starts_with($Value, '/'))
            &&
            is_numeric(substr($Value, 1))
        ) {
            $Source = match (substr($Value, 0, 1)) {
                '+' => (int) $Source + (int) substr($Value, 1),
                '-' => (int) $Source - (int) substr($Value, 1),
                '*' => (int) $Source * (int) substr($Value, 1),
                '/' => (int) $Source / (int) substr($Value, 1),
                default => null,
            };
        } else {
            if (is_numeric($Value)) {
                $Source = $Value;
            } else {
                $Source = null;
            }
        }
        if ($Source !== null) {
            $Source = ($FloatingNumber === false
                ? number_format($Source, 0, '.', '')
                : number_format($Source, 2, '.', ''));
        }
        return $Source;
    }

    /**
     * 使用 $Value 给定的运算式及流量单位与 $Source 计算结果
     *
     * @param string $Source 源数值
     * @param string $Value  运算式含增改数值
     */
    public static function trafficMethod(string $Source, string $Value): ?int
    {
        if (
            str_starts_with($Value, '+')
            ||
            str_starts_with($Value, '-')
            ||
            str_starts_with($Value, '*')
            ||
            str_starts_with($Value, '/')
        ) {
            $operator = substr($Value, 0, 1);
            if (! in_array($operator, ['*', '/'])) {
                $number = Tools::autoBytesR(substr($Value, 1));
            } else {
                $number = substr($Value, 1, strlen($Value) - 1);
                if (! is_numeric($number)) {
                    return null;
                }
            }
            if ($number === null) {
                return null;
            }

            $Source = match ($operator) {
                '+' => (int) $Source + (int) $number,
                '-' => (int) $Source - (int) $number,
                '*' => (int) $Source * (int) $number,
                '/' => (int) $Source / (int) $number,
                default => null,
            };
        } else {
            if (is_numeric($Value)) {
                if ((int) $Value === 0) {
                    $Source = 0;
                } else {
                    $Source = Tools::autoBytesR($Value . 'KB');
                }
            } else {
                $Source = Tools::autoBytesR($Value);
            }
        }
        return $Source;
    }

    /**
     * 字符串数组转 TG HTML 等宽字符串
     *
     * @param array $strArray 字符串数组
     */
    public static function strArrayToCode(array $strArray): string
    {
        return implode(
            PHP_EOL,
            array_map(
                static function ($item) {
                    return '<code>' . $item . '</code>';
                },
                $strArray
            )
        );
    }
}

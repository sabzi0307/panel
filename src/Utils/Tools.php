<?php

declare(strict_types=1);

namespace App\Utils;

use App\Models\Link;
use App\Models\Model;
use App\Models\Paylist;
use App\Models\Setting;
use App\Models\User;
use App\Services\Config;
use function floatval;
use function in_array;
use function intval;
use function is_null;
use function time;

final class Tools
{
    /**
     * 查询IP归属
     */
    public static function getIpInfo($ip): false|string
    {
        $iplocation = new QQWry();
        $location = $iplocation->getlocation($ip);
        return iconv('gbk', 'utf-8//IGNORE', $location['country'] . $location['area']);
    }

    /**
     * 根据流量值自动转换单位输出
     */
    public static function flowAutoShow($value = 0): string
    {
        $kb = 1024;
        $mb = 1048576;
        $gb = 1073741824;
        $tb = $gb * 1024;
        $pb = $tb * 1024;
        if (abs((float) $value) > $pb) {
            return round((float) $value / $pb, 2) . 'PB';
        }

        if (abs((float) $value) > $tb) {
            return round((float) $value / $tb, 2) . 'TB';
        }

        if (abs((float) $value) > $gb) {
            return round((float) $value / $gb, 2) . 'GB';
        }

        if (abs((float) $value) > $mb) {
            return round((float) $value / $mb, 2) . 'MB';
        }

        if (abs((float) $value) > $kb) {
            return round((float) $value / $kb, 2) . 'KB';
        }

        return round((float) $value, 2) . 'B';
    }

    /**
     * 根据含单位的流量值转换 B 输出
     */
    public static function flowAutoShowZ($Value): ?float
    {
        $number = substr($Value, 0, -2);
        if (! is_numeric($number)) {
            return null;
        }
        $number = intval($number);
        $unit = strtoupper(substr($Value, -2));
        $kb = 1024;
        $mb = 1048576;
        $gb = 1073741824;
        $tb = $gb * 1024;
        $pb = $tb * 1024;
        switch ($unit) {
            case 'B':
                $number = round($number, 2);
                break;
            case 'KB':
                $number = round($number * $kb, 2);
                break;
            case 'MB':
                $number = round($number * $mb, 2);
                break;
            case 'GB':
                $number = round($number * $gb, 2);
                break;
            case 'TB':
                $number = round($number * $tb, 2);
                break;
            case 'PB':
                $number = round($number * $pb, 2);
                break;
            default:
                return null;
        }
        return $number;
    }

    //虽然名字是toMB，但是实际上功能是from MB to B
    public static function toMB($traffic): float|int
    {
        $mb = 1048576;
        return $traffic * $mb;
    }

    //虽然名字是toGB，但是实际上功能是from GB to B
    public static function toGB($traffic): float|int
    {
        $gb = 1048576 * 1024;
        return $traffic * $gb;
    }

    public static function flowToGB($traffic): float
    {
        $gb = 1048576 * 1024;
        return $traffic / $gb;
    }

    public static function flowToMB($traffic): float
    {
        $gb = 1048576;
        return $traffic / $gb;
    }

    public static function genRandomChar($length = 8): string
    {
        return bin2hex(openssl_random_pseudo_bytes($length / 2));
    }

    public static function toDateTime(int $time): string
    {
        return date('Y-m-d H:i:s', $time);
    }

    public static function getLastPort()
    {
        $user = User::orderBy('id', 'desc')->first();
        if ($user === null) {
            return 1024;
        }
        return $user->port;
    }

    public static function getAvPort()
    {
        if (Setting::obtain('min_port') > 65535 || Setting::obtain('min_port') <= 0 || Setting::obtain('max_port') > 65535 || Setting::obtain('max_port') <= 0) {
            return 0;
        }
        $det = User::pluck('port')->toArray();
        $port = array_diff(range(Setting::obtain('min_port'), Setting::obtain('max_port')), $det);
        shuffle($port);
        return $port[0];
    }

    public static function getDir($dir): array
    {
        $dirArray = [];
        $handle = opendir($dir);
        if ($handle !== false) {
            $i = 0;
            while (($file = readdir($handle)) !== false) {
                if ($file !== '.' && $file !== '..' && ! strpos($file, '.')) {
                    $dirArray[$i] = $file;
                    $i++;
                }
            }
            closedir($handle);
        }
        return $dirArray;
    }

    public static function isSpecialChars($input): bool
    {
        return ! preg_match('/[^A-Za-z0-9\-_\.]/', $input);
    }

    public static function isParamValidate($type, $str): bool
    {
        $list = Config::getSupportParam($type);
        if (in_array($str, $list)) {
            return true;
        }
        return false;
    }

    /**
     * Filter key in `App\Models\Model` object
     */
    public static function keyFilter(Model $object, array $filter_array): Model
    {
        foreach ($object->toArray() as $key => $value) {
            if (! in_array($key, $filter_array)) {
                unset($object->$key);
            }
        }
        return $object;
    }

    public static function getRealIp($rawIp): array|string
    {
        return str_replace('::ffff:', '', $rawIp);
    }

    public static function isEmail($input): bool
    {
        if (filter_var($input, FILTER_VALIDATE_EMAIL) === false) {
            return false;
        }
        return true;
    }

    public static function isEmailLegal($email): array
    {
        $res = [];
        $res['ret'] = 0;

        if (! self::isEmail($email)) {
            $res['msg'] = '邮箱不规范';
            return $res;
        }

        $mail_suffix = explode('@', $email)[1];
        $mail_filter_list = $_ENV['mail_filter_list'];
        $res['msg'] = 'نتوانستیم نامه را به دامنه ارسال کنیم ' . $mail_suffix . ' ، لطفا آدرس ایمیل خود را تغییر دهید';

        switch ($_ENV['mail_filter']) {
            case 1:
                // 白名单
                if (in_array($mail_suffix, $mail_filter_list)) {
                    $res['ret'] = 1;
                }
                return $res;
            case 2:
                // 黑名单
                if (! in_array($mail_suffix, $mail_filter_list)) {
                    $res['ret'] = 1;
                }
                return $res;
            default:
                $res['ret'] = 1;
                return $res;
        }
    }

    public static function isIPv4($input): bool
    {
        if (filter_var($input, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4) === false) {
            return false;
        }
        return true;
    }

    public static function isIPv6($input): bool
    {
        if (filter_var($input, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6) === false) {
            return false;
        }
        return true;
    }

    public static function isInt($input): bool
    {
        if (filter_var($input, FILTER_VALIDATE_INT) === false) {
            return false;
        }
        return true;
    }

    /**
     * Eloquent 分页链接渲染
     *
     * @param mixed $data
     *
     * @return string
     */
    public static function paginateRender(mixed $data): string
    {
        $totalPage = $data->lastPage();
        $currentPage = $data->currentPage();
        $html = '<ul class="pagination pagination-primary justify-content-end">';
        for ($i = 1; $i <= $totalPage; $i++) {
            $active = '<li class="page-item active"><span class="page-link">' . $i . '</span></li>';
            $page = '<li class="page-item"><a class="page-link" href="' . $data->url($i) . '">' . $i . '</a></li>';
            if ($i === 1) {
                // 当前为第一页
                if ($currentPage === $i) {
                    $html .= '<li class="page-item disabled"><a class="page-link">صفحه قبلی</a></li>';
                    $html .= $active;
                    if ($i === $totalPage) {
                        $html .= '<li class="page-item disabled"><a class="page-link">صفحه بعد</a></li>';
                        continue;
                    }
                } else {
                    $html .= '<li class="page-item"><a class="page-link" href="' . $data->url($currentPage - 1) . '">صفحه قبلی</a></li>';
                    if ($currentPage > 4) {
                        $html .= '<li class="page-item disabled"><a class="page-link">...</a></li>';
                    } else {
                        $html .= $page;
                    }
                }
            }
            if ($i === $totalPage) {
                // 当前为最后一页
                if ($currentPage === $i) {
                    $html .= $active;
                    $html .= '<li class="page-item disabled"><a class="page-link">صفحه بعد</a></li>';
                } else {
                    if ($totalPage - $currentPage > 3) {
                        $html .= '<li class="page-item disabled"><a class="page-link">...</a></li>';
                    } else {
                        $html .= $page;
                    }
                    $html .= '<li class="page-item"><a class="page-link" href="' . $data->url($currentPage + 1) . '">صفحه بعد</a></li>';
                }
            }
            if ($i > 1 && $i < $totalPage) {
                // 其他页
                if ($currentPage === $i) {
                    $html .= $active;
                } else {
                    if ($totalPage > 10) {
                        if (
                            ($currentPage > 4 && $i < $currentPage && $i > $currentPage - 3)
                            ||
                            ($totalPage - $currentPage > 4 && $i > $currentPage && $i < $currentPage + 4)
                            ||
                            ($currentPage <= 4 && $i <= 4)
                            ||
                            ($totalPage - $currentPage <= 4 && $i > $currentPage)
                        ) {
                            $html .= $page;
                        }
                        continue;
                    }
                    $html .= $page;
                }
            }
        }
        return $html . '</ul>';
    }

    public static function genSubToken(): string
    {
        for ($i = 0; $i < 10; $i++) {
            $token = self::genRandomChar(16);
            $is_token_used = Link::where('token', $token)->first();
            if ($is_token_used === null) {
                return $token;
            }
        }

        return "couldn't alloc token";
    }

    public static function generateSSRSubCode(int $userid): string
    {
        $Elink = Link::where('userid', $userid)->first();
        if ($Elink !== null) {
            return $Elink->token;
        }

        $NLink = new Link();
        $NLink->userid = $userid;
        $NLink->token = self::genSubToken();
        $NLink->save();

        return $NLink->token;
    }

    public static function searchEnvName($name): int|string|null
    {
        global $_ENV;
        foreach ($_ENV as $configKey => $configValue) {
            if (strtoupper($configKey) === $name) {
                return $configKey;
            }
        }
        return null;
    }

    /**
     * 获取累计收入
     */
    public static function getIncome(string $req): float
    {
        $today = strtotime('00:00:00');
        $number = match ($req) {
            'today' => Paylist::where('status', 1)->whereBetween('datetime', [$today, time()])->sum('total'),
            'yesterday' => Paylist::where('status', 1)->whereBetween('datetime', [strtotime('-1 day', $today), $today])->sum('total'),
            'this month' => Paylist::where('status', 1)->whereBetween('datetime', [strtotime('first day of this month 00:00:00'), $today])->sum('total'),
            default => Paylist::where('status', 1)->sum('total'),
        };
        return is_null($number) ? 0.00 : round(floatval($number), 2);
    }

    /**
     * 工单状态
     */
    public static function getTicketStatus($ticket): string
    {
        if ($ticket->status === 'closed') {
            return 'بسته شده';
        }
        if ($ticket->status === 'open_wait_user') {
            return 'در انتظار پاسخ کاربر';
        }
        if ($ticket->status === 'open_wait_admin') {
            return 'در حال انجام است';
        }
        return 'ناشناخته';
    }

    /**
     * 工单类型
     */
    public static function getTicketType($ticket): string
    {
        if ($ticket->type === 'howto') {
            return 'نحوه استفاده';
        }
        if ($ticket->type === 'billing') {
            return 'مالی';
        }
        if ($ticket->type === 'account') {
            return 'حساب';
        }
        return 'دیگر';
    }

    /**
     * 节点状态
     */
    public static function getNodeType($node): string
    {
        return $node->type ? 'نشان دادن' : 'پنهان شدن';
    }

    /**
     * 节点类型
     */
    public static function getNodeSort($node): string
    {
        return match ((int) $node->sort) {
            0 => 'Shadowsocks',
            9 => 'ShadowsocksR چند کاربره تک پورت (قدیمی)',
            11 => 'V2Ray',
            14 => 'Trojan',
            default => 'ناشناخته',
        };
    }

    /**
     * 礼品卡状态
     */
    public static function getGiftCardStatus($giftcard): string
    {
        return $giftcard->status ? 'استفاده شده' : 'استفاده نشده';
    }

    /**
     * 商品类型
     */
    public static function getProductType($product): string
    {
        if ($product->type === 'tabp') {
            return 'بسته ترافیک زمانی';
        }
        if ($product->type === 'time') {
            return 'بسته زمانی';
        }
        if ($product->type === 'bandwidth') {
            return 'بسته ترافیک';
        }
        return 'سایر';
    }

    /**
     * 商品状态
     */
    public static function getProductStatus($product): string
    {
        return $product->status ? 'نرمال' : 'توقف فروش';
    }

    /**
     * 商品库存
     */
    public static function getProductStock($product)
    {
        if ($product->stock === -1) {
            return 'نامحدود';
        }
        return $product->stock;
    }

    /**
     * 订单状态
     */
    public static function getOrderStatus($order): string
    {
        if ($order->status === 'pending_payment') {
            return 'منتظر پرداخت باشید';
        }
        if ($order->status === 'pending_activation') {
            return 'منتظر فعال سازی';
        }
        if ($order->status === 'activated') {
            return 'فعال شد';
        }
        if ($order->status === 'expired') {
            return 'منقضی شده';
        }
        if ($order->status === 'cancelled') {
            return 'لغو شد';
        }
        return 'ناشناخته';
    }

    /**
     * 订单商品类型
     */
    public static function getOrderProductType($order): string
    {
        if ($order->product_type === 'tabp') {
            return 'بسته ترافیک زمانی';
        }
        if ($order->product_type === 'time') {
            return 'بسته زمانی';
        }
        if ($order->product_type === 'bandwidth') {
            return 'بسته ترافیک';
        }
        return 'سایر';
    }

    /**
     * 账单状态
     */
    public static function getInvoiceStatus($invoice): string
    {
        if ($invoice->status === 'unpaid') {
            return 'پرداخت نشده';
        }
        if ($invoice->status === 'paid_gateway') {
            return 'پرداخت شده (درگاه پرداخت) ';
        }
        if ($invoice->status === 'paid_balance') {
            return 'پرداخت شده (موجودی حساب) ';
        }
        if ($invoice->status === 'paid_admin') {
            return 'پرداخت شده (ادمین) ';
        }
        if ($invoice->status === 'cancelled') {
            return 'لغو شده';
        }
        return 'ناشناخته';
    }

    /**
     * 优惠码状态
     */
    public static function getCouponStatus($coupon): string
    {
        if ($coupon->expire_time < time()) {
            return 'منقضی شده';
        }
        return 'فعال سازی';
    }

    /**
     * 优惠码类型
     */
    public static function getCouponType($content): string
    {
        if ($content->type === 'percentage') {
            return 'درصد';
        }
        if ($content->type === 'fixed') {
            return 'مبلغ ثابت';
        }
        return 'ناشناخته';
    }

    /**
     * 优惠码类型
     */
    public static function getPaylistStatus($paylist): string
    {
        return match ($paylist->status) {
            0 => 'پرداخت نشده',
            1 => 'پرداخت شده',
            default => 'ناشناخته',
        };
    }

    /**
     * 优惠码类型
     */
    public static function getPaylistStatus($paylist): string
    {
        return match ($paylist->status) {
            0 => 'پرداخت نشده',
            1 => 'پرداخت شده',
            default => 'ناشناخته',
        };
    }
}

<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\UserCoupon;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function in_array;
use function json_decode;
use function json_encode;
use function time;

/*
 *  Coupon Controller
 */
final class CouponController extends BaseController
{
    public static array $details = [
        'field' => [
            'op' => 'اقدام',
            'id' => 'شناسه کد تخفیف',
            'code' => 'کد تخفیف',
            'type' => 'نوع کد تخفیف',
            'value' => 'مبلغ کد تخفیف',
            'product_id' => 'شناسه محصول موجود',
            'use_time' => 'تعداد استفاده به ازای هر کاربر',
            'new_user' => 'فقط برای کاربران جدید',
            'disabled' => 'غیر فعال',
            'create_time' => 'زمان ایجاد',
            'expire_time' => 'انقضا',
        ],
        'create_dialog' => [
            [
                'id' => 'code',
                'info' => 'کد تخفیف',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'type',
                'info' => 'نوع کد تخفیف',
                'type' => 'select',
                'select' => [
                    'percentage' => 'درصد',
                    'fixed' => 'مبلغ ثابت',
                ],
            ],
            [
                'id' => 'value',
                'info' => 'مبلغ کد تخفیف',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'product_id',
                'info' => 'شناسه‌های کالاهای موجود (شناسه‌های متعدد با کاما از هم جدا می‌شوند)',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'use_time',
                'info' => 'تعداد دفعاتی که هر کاربر می تواند از آن استفاده کند (کمتر از 0 نامحدود است)',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'new_user',
                'info' => 'فقط برای کاربران جدید',
                'type' => 'select',
                'select' => [
                    '1' => 'فعال کردن',
                    '0' => 'غیر فعال',
                ],
            ],
            [
                'id' => 'generate_method',
                'info' => 'روش تولید',
                'type' => 'select',
                'select' => [
                    'char' => 'کاراکتر مشخص',
                    'random' => 'کاراکترهای تصادفی (عدم توجه به پارامترهای کد تخفیف)',
                    'char_random' => 'کاراکتر مشخص + کاراکتر تصادفی',
                ],
            ],
        ],
    ];

    /**
     * 后台优惠码页面
     *
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('admin/coupon.tpl')
        );
    }

    /**
     * 添加优惠码
     */
    public function add(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $code = $request->getParam('code');
        $type = $request->getParam('type');
        $value = $request->getParam('value');
        $product_id = $request->getParam('product_id');
        $use_time = $request->getParam('use_time');
        $new_user = $request->getParam('new_user');
        $generate_method = $request->getParam('generate_method');
        $expire_time = $request->getParam('expire_time');

        if ($code === '' && in_array($generate_method, ['char', 'char_ramdom'])) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'کد تخفیف نمی تواند خالی باشد',
            ]);
        }

        if ($type === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'نوع کد تخفیف نمی تواند خالی باشد',
            ]);
        }

        if ($value === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'مقدار کد تخفیف نمی تواند خالی باشد',
            ]);
        }

        if ($expire_time !== '' && $expire_time < time()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'زمان انقضا نمی تواند از زمان حال کمتر باشد',
            ]);
        }

        if ($generate_method === 'char' && UserCoupon::where('code', $code)->count() !== 0) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'کد تخفیف از قبل وجود دارد',
            ]);
        }

        if ($generate_method === 'char_random') {
            $code .= Tools::genRandomChar();

            if (UserCoupon::where('code', $code)->count() !== 0) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'مشکلی رخ داده است. لطفا بعدا دوباره امتحان کنید',
                ]);
            }
        }

        if ($generate_method === 'random') {
            $code = Tools::genRandomChar();

            if (UserCoupon::where('code', $code)->count() !== 0) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'مشکلی رخ داده است. لطفا بعدا دوباره امتحان کنید',
                ]);
            }
        }

        $content = [
            'type' => $type,
            'value' => $value,
        ];

        $limit = [
            'product_id' => $product_id,
            'use_time' => $use_time,
            'new_user' => $new_user,
            'disabled' => 0,
        ];

        $coupon = new UserCoupon();
        $coupon->code = $code;
        $coupon->content = json_encode($content);
        $coupon->limit = json_encode($limit);
        $coupon->create_time = time();
        if ($expire_time !== '') {
            $coupon->expire_time = $expire_time;
        } else {
            $coupon->expire_time = 0;
        }
        $coupon->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'کد تخفیف ' . $code . ' با موفقیت اضافه شد',
        ]);
    }

    public function delete(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $coupon_id = $args['id'];
        UserCoupon::find($coupon_id)->delete();
        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت حذف شد',
        ]);
    }

    public function disable(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $coupon_id = $args['id'];
        $coupon = UserCoupon::find($coupon_id)->first();
        $limit = json_decode($coupon->limit);
        $limit->disabled = 1;
        $coupon->limit = json_encode($limit);
        $coupon->save();
        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت غیرفعال شد',
        ]);
    }

    public function disable(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $coupon_id = $args['id'];
        $coupon = UserCoupon::find($coupon_id)->first();
        $limit = json_decode($coupon->limit);
        $limit->disabled = 1;
        $coupon->limit = json_encode($limit);
        $coupon->save();
        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت غیرفعال شد',
        ]);
    }

    /**
     * 后台商品优惠码页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $coupons = UserCoupon::orderBy('id', 'desc')->get();
        foreach ($coupons as $coupon) {
            $content = json_decode($coupon->content);
            $limit = json_decode($coupon->limit);
            if ($limit->disabled === 1) {
                $coupon->op = '<button type="button" class="btn btn-red" id="delete-coupon-' . $coupon->id . '" 
                onclick="deleteCoupon(' . $coupon->id . ')">حذف</button>';
            } else {
                $coupon->op = '<button type="button" class="btn btn-red" id="delete-coupon-' . $coupon->id . '" 
                onclick="deleteCoupon(' . $coupon->id . ')">حذف</button>
                <button type="button" class="btn btn-orange" id="disable-coupon-' . $coupon->id . '" 
                onclick="disableCoupon(' . $coupon->id . ')">غیر فعال</button>';
            }
            $coupon->type = Tools::getCouponType($content);
            $coupon->value = $content->value;
            $coupon->product_id = $limit->product_id;
            if ((int) $limit->use_time < 0) {
                $coupon->use_time = 'نامحدود';
            } else {
                $coupon->use_time = $limit->use_time;
            }
            if ($limit->new_user === 1) {
                $coupon->new_user = 'بله';
            } else {
                $coupon->new_user = 'خیر';
            }
            if ($limit->disabled === 1) {
                $coupon->disabled = 'بله';
            } else {
                $coupon->disabled = 'خیر';
            }
            $coupon->create_time = Tools::toDateTime((int) $coupon->create_time);
            if ($coupon->expire_time === 0) {
                $coupon->expire_time = 'دائمی';
            } else {
                $coupon->expire_time = Tools::toDateTime((int) $coupon->expire_time);
            }
        }
        return $response->withJson([
            'coupons' => $coupons,
        ]);
    }
}

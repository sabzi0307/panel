<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\UserCoupon;
use App\Utils\Tools;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Request;
use Slim\Http\Response;

/*
 *  Coupon Controller
 */
final class CouponController extends BaseController
{
    public static $details = [
        'field' => [
            'op' => 'اقدام',
            'id' => 'شناسه کد تخفیف',
            'code' => 'کد تخفیف',
            'type' => 'نوع کد تخفیف',
            'value' => 'مبلغ کد تخفیف',
            'product_id' => 'شناسه محصول موجود',
            'use_time' => 'تعداد استفاده به ازای هر کاربر',
            'new_user' => 'فقط برای کاربران جدید',
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
                'info' => 'شناسه محصول موجود',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'use_time',
                'info' => 'تعداد استفاده به ازای هر کاربر',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'new_user',
                'info' => 'فقط برای کاربران جدید',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'generate_method',
                'info' => 'روش تولید',
                'type' => 'select',
                'select' => [
                    'char' => 'کاراکتر مشخص',
                    'random' => 'کاراکترهای تصادفی (عدم توجه به پارامترهای کد تخفیف)',
                    'char_ramdom' => 'کاراکتر مشخص + کاراکتر تصادفی',
                ],
            ],
        ],
    ];

    /**
     * 后台优惠码页面
     *
     * @param array     $args
     */
    public function index(Request $request, Response $response, array $args): ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->display('admin/coupon.tpl')
        );
    }

    /**
     * 添加优惠码
     *
     * @param array     $args
     */
    public function add(Request $request, Response $response, array $args): ResponseInterface
    {
        $code = $request->getParam('code');
        $type = $request->getParam('type');
        $value = $request->getParam('value');
        $product_id = $request->getParam('product_id');
        $use_time = $request->getParam('use_time');
        $new_user = $request->getParam('new_user');
        $generate_method = $request->getParam('generate_method');
        $expire_time = $request->getParam('expire_time');

        if ($code === '' && \in_array($generate_method, ['char', 'char_ramdom'])) {
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

        if ($expire_time < \time()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'زمان انقضا نمی تواند از زمان حال کمتر باشد',
            ]);
        }

        if ($generate_method === 'char') {
            if (UserCoupon::where('code', $code)->count() !== 0) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'کد تخفیف از قبل وجود دارد',
                ]);
            }
        }

        if ($generate_method === 'char_ramdom') {
            $code .= Tools::genRandomChar(8);

            if (UserCoupon::where('code', $code)->count() === 0) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'مشکلی رخ داده است. لطفا بعدا دوباره امتحان کنید',
                ]);
            }
        }

        if ($generate_method === 'ramdom') {
            $code = Tools::genRandomChar(8);

            if (UserCoupon::where('code', $code)->count() === 0) {
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
        ];

        $coupon = new UserCoupon();
        $coupon->code = $code;
        $coupon->content = \json_encode($content);
        $coupon->limit = \json_encode($limit);
        $coupon->create_time = \time();
        $coupon->expire_time = $expire_time;
        $coupon->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'کد تخفیف <code>' . $code . '</code> با موفقیت اضافه شد',
        ]);
    }

    public function delete(Request $request, Response $response, array $args): ResponseInterface
    {
        $coupon_id = $args['id'];
        UserCoupon::find($coupon_id)->delete();
        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت حذف شد',
        ]);
    }

    /**
     * 后台商品优惠码页面 AJAX
     *
     * @param array     $args
     */
    public function ajax(Request $request, Response $response, array $args): ResponseInterface
    {
        $coupons = UserCoupon::orderBy('id', 'desc')->get();
        foreach ($coupons as $coupon) {
            $content = \json_decode($coupon->content);
            $limit = \json_decode($coupon->limit);
            $coupon->op = '<button type="button" class="btn btn-red" id="delete-coupon-' . $coupon->id . '" 
        onclick="deleteCoupons(' . $coupon->id . ')">حذف</button>';
            $coupon->type = Tools::getCouponType($content);
            $coupon->value = $content->value;
            $coupon->product_id = $limit->product_id;
            $coupon->use_time = $limit->use_time;
            $coupon->new_user = $limit->new_user;
            $coupon->create_time = Tools::toDateTime((int) $coupon->create_time);
            $coupon->expire_time = Tools::toDateTime((int) $coupon->expire_time);
        }
        return $response->withJson([
            'coupons' => $coupons,
        ]);
    }
}

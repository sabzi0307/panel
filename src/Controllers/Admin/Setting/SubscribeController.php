<?php

declare(strict_types=1);

namespace App\Controllers\Admin\Setting;

use App\Controllers\BaseController;
use App\Models\Setting;
use Exception;

final class SubscribeController extends BaseController
{
    private static array $update_field = [
        'enable_forced_replacement',
        'enable_traditional_sub',
        'enable_ss_sub',
        'enable_v2_sub',
        'enable_trojan_sub',
    ];

    /**
     * @throws Exception
     */
    public function sub($request, $response, $args)
    {
        $settings = Setting::getClass('subscribe');

        return $response->write(
            $this->view()
                ->assign('update_field', self::$update_field)
                ->assign('settings', $settings)
                ->fetch('admin/setting/sub.tpl')
        );
    }

    public function saveSub($request, $response, $args)
    {
        foreach (self::$update_field as $item) {
            if (! Setting::set($item, $request->getParam($item))) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'خطا در ذخیره ' . $item ,
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت ذخیره شد',
        ]);
    }
}

<?php

declare(strict_types=1);

namespace App\Controllers\Admin\Setting;

use App\Controllers\BaseController;
use App\Models\Config;
use App\Utils\Tools;
use Exception;

final class SmartDnsController extends BaseController
{
    private static array $update_field = [
        'smart_dns',
        'smart_dns_check_url',
        'smart_dns_fail_url',
        'smart_dns_plain',
        'smart_dns_plain_url_1',
        'smart_dns_plain_url_2',
        'smart_dns_dot',
        'smart_dns_dot_url',
        'smart_dns_doh',
        'smart_dns_doh_url',
        'smart_dns_dodtls',
        'smart_dns_dodtls_url',
        'smart_dns_doq',
        'smart_dns_doq_url',
    ];

    /**
     * @throws Exception
     */
    public function index($request, $response, $args)
    {
        $settings = Config::getClass('smartdns');

        return $response->write(
            $this->view()
                ->assign('update_field', self::$update_field)
                ->assign('settings', $settings)
                ->fetch('admin/setting/smart.tpl')
        );
    }

    public function save($request, $response, $args)
    {
        $plain = $request->getParam('smart_dns_plain');
        if ($plain) {

            $plain_url_1 = $request->getParam('smart_dns_plain_url_1');
            $plain_url_2 = $request->getParam('smart_dns_plain_url_2');

            if (!Tools::isIPv4($plain_url_1)) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'مقدار آدرس Plain DNS 1 صحیح نمی باشد.',
                ]);
            }

            if (!Tools::isIPv4($plain_url_2)) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'مقدار آدرس Plain DNS 2 صحیح نمی باشد.',
                ]);
            }
        }
        foreach (self::$update_field as $item) {

            if (! Config::set($item, $request->getParam($item))) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'خطا در ذخیره ' . $item,
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت ذخیره شد',
        ]);
    }
}

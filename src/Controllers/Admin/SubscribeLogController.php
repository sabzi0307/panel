<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\UserSubscribeLog;
use App\Utils\Tools;
use Exception;
use GeoIp2\Exception\AddressNotFoundException;
use MaxMind\Db\Reader\InvalidDatabaseException;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class SubscribeLogController extends BaseController
{
    public static array $details =
    [
        'field' => [
            'id' => 'شناسه رویداد',
            'user_name' => 'نام کاربری',
            'user_id' => 'شناسه کاربر',
            'email' => 'ایمیل کاربر',
            'subscribe_type' => 'دریافت نوع اشتراک',
            'request_ip' => 'درخواست IP',
            'location' => 'انتساب IP',
            'request_time' => 'زمان درخواست',
            'request_user_agent' => 'شناسه مشتری',
        ],
    ];

    /**
     * 后台订阅记录页面
     *
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('admin/subscribe.tpl')
        );
    }

    /**
     * 后台订阅记录页面 AJAX
     *
     * @throws AddressNotFoundException
     * @throws InvalidDatabaseException
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $length = $request->getParam('length');
        $page = $request->getParam('start') / $length + 1;
        $draw = $request->getParam('draw');

        $subscribes = UserSubscribeLog::orderBy('id', 'desc')->paginate($length, '*', '', $page);
        $total = UserSubscribeLog::count();

        foreach ($subscribes as $subscribe) {
            $subscribe->location = Tools::getIpLocation($subscribe->request_ip);
        }

        return $response->withJson([
            'draw' => $draw,
            'recordsTotal' => $total,
            'recordsFiltered' => $total,
            'subscribes' => $subscribes,
        ]);
    }
}

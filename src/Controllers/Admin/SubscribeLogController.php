<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\SubscribeLog;
use App\Utils\Tools;
use Exception;
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
            'user_id' => 'شناسه کاربر',
            'type' => 'دریافت نوع اشتراک',
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
                ->fetch('admin/log/subscribe.tpl')
        );
    }

    /**
     * 后台订阅记录页面 AJAX
     *
     * @throws InvalidDatabaseException
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $length = $request->getParam('length');
        $page = $request->getParam('start') / $length + 1;
        $draw = $request->getParam('draw');

        $subscribes = SubscribeLog::orderBy('id', 'desc')->paginate($length, '*', '', $page);
        $total = SubscribeLog::count();

        foreach ($subscribes as $subscribe) {
            $subscribe->request_time = Tools::toDateTime($subscribe->request_time);
            $subscribe->location = $subscribe->getAttributes();
        }

        return $response->withJson([
            'draw' => $draw,
            'recordsTotal' => $total,
            'recordsFiltered' => $total,
            'subscribes' => $subscribes,
        ]);
    }
}

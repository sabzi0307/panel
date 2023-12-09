<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\OnlineLog;
use App\Utils\Tools;
use Exception;
use MaxMind\Db\Reader\InvalidDatabaseException;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function time;

final class OnlineLogController extends BaseController
{
    private static array $details =
        [
            'field' => [
                'id' => 'ID رویداد',
                'user_id' => 'شناسه کاربر',
                'user_name' => 'نام کاربری',
                'node_id' => 'شناسه گره',
                'node_name' => 'نام گره',
                'ip' => 'IP',
                'location' => 'موقعیت IP',
                'first_time' => 'اولین اتصال',
                'last_time' => 'آخرین اتصال',
            ],
        ];

    /**
     * 后台在线 IP 页面
     *
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('admin/log/online.tpl')
        );
    }

    /**
     * 后台在线 IP 页面 AJAX
     *
     * @throws InvalidDatabaseException
     */
    public function ajax(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $length = $request->getParam('length');
        $page = $request->getParam('start') / $length + 1;
        $draw = $request->getParam('draw');

        $onlines = (new OnlineLog())->where('last_time', '>', time() - 90)->orderByDesc('last_time')->paginate($length, '*', '', $page);
        $total = (new OnlineLog())->where('last_time', '>', time() - 90)->count();

        foreach ($onlines as $online) {
            $online->user_name = $online->userName();
            $online->node_name = $online->nodeName();
            $online->ip = $online->ip();
            $online->location = Tools::getIpLocation($online->ip);
            $online->first_time = Tools::toDateTime($online->first_time);
            $online->last_time = Tools::toDateTime($online->last_time);
        }

        return $response->withJson([
            'draw' => $draw,
            'recordsTotal' => $total,
            'recordsFiltered' => $total,
            'onlines' => $onlines,
        ]);
    }
}

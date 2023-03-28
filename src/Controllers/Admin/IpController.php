<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\LoginIp;
use App\Services\DB;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function array_map;
use function array_slice;
use function count;

final class IpController extends BaseController
{
    public static array $login_details =
    [
        'field' => [
            'id' => 'شناسه رویداد',
            'userid' => 'شناسه کاربر',
            'user_name' => 'نام کاربری',
            'ip' => 'IP',
            'location' => 'انتساب IP',
            'datetime' => 'زمان',
            'type' => 'نوع',
        ],
    ];

    public static array $ip_details =
    [
        'field' => [
            'id' => 'شناسه رویداد',
            'user_id' => 'شناسه کاربر',
            'user_name' => 'نام کاربری',
            'node_id' => 'شناسه سرور',
            'node_name' => 'نام سرور',
            'ip' => 'IP',
            'location' => 'انتساب IP',
            'first_time' => 'اتصال برای اولین بار',
            'last_time' => 'آخرین اتصال',
        ],
    ];

    /**
     * 后台登录记录页面
     *
     * @throws Exception
     */
    public function login(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$login_details)
                ->fetch('admin/log/login.tpl')
        );
    }

    /**
     * 后台登录记录页面 AJAX
     */
    public function ajaxLogin(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $length = $request->getParam('length');
        $page = $request->getParam('start') / $length + 1;
        $draw = $request->getParam('draw');

        $logins = LoginIp::orderBy('id', 'desc')->paginate($length, '*', '', $page);
        $total = LoginIp::count();

        foreach ($logins as $login) {
            $login->user_name = $login->userName();
            $login->location = Tools::getIpLocation($login->ip);
            $login->datetime = Tools::toDateTime((int) $login->datetime);
            $login->type = $login->type();
        }

        return $response->withJson([
            'draw' => $draw,
            'recordsTotal' => $total,
            'recordsFiltered' => $total,
            'logins' => $logins,
        ]);
    }

    /**
     * 后台在线 IP 页面
     *
     * @throws Exception
     */
    public function online(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$ip_details)
                ->fetch('admin/log/online.tpl')
        );
    }

    /**
     * 后台在线 IP 页面 AJAX
     */
    public function ajaxOnline(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $data = $request->getParsedBody();
        $length = (int) ($data['length'] ?? 0);
        $start = (int) ($data['start'] ?? 0);
        $draw = $data['draw'] ?? null;

        $logs = DB::select('
            SELECT
                online_log.id,
                online_log.user_id,
                user.user_name,
                online_log.node_id,
                node.name AS node_name,
                online_log.ip,
                online_log.first_time,
                online_log.last_time
            FROM
                online_log
                LEFT JOIN user ON user.id = online_log.user_id
                LEFT JOIN node ON node.id = online_log.node_id
            WHERE
                last_time > UNIX_TIMESTAMP() - 90
        ');

        $count = count($logs);
        $data = array_map(static function ($val) {
            return [
                'id' => $val->id,
                'user_id' => $val->user_id,
                'user_name' => $val->user_name,
                'node_id' => $val->node_id,
                'node_name' => $val->node_name,
                'ip' => str_replace('::ffff:', '', $val->ip),
                'location' => Tools::getIpLocation($val->ip),
                'first_time' => Tools::toDateTime($val->first_time),
                'last_time' => Tools::toDateTime($val->last_time),
            ];
        }, array_slice($logs, $start, $length));

        return $response->withJson([
            'draw' => $draw,
            'recordsTotal' => $count,
            'recordsFiltered' => $count,
            'onlines' => $data,
        ]);
    }
}

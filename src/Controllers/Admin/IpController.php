<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Ip;
use App\Models\LoginIp;
use App\Utils\QQWry;
use App\Utils\Tools;
use Slim\Http\Request;
use Slim\Http\Response;

final class IpController extends BaseController
{
    public static $login_details =
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

    public static $ip_details =
    [
        'field' => [
            'id' => 'شناسه رویداد',
            'userid' => 'شناسه کاربر',
            'user_name' => 'نام کاربری',
            'nodeid' => 'شناسه نود',
            'node_name' => 'نام نود',
            'ip' => 'IP',
            'location' => 'انتساب IP',
            'datetime' => 'زمان',
        ],
    ];

    /**
     * 后台登录记录页面
     *
     * @param array     $args
     */
    public function login(Request $request, Response $response, array $args)
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$login_details)
                ->display('admin/log/login.tpl')
        );
    }

    /**
     * 后台登录记录页面 AJAX
     *
     * @param array     $args
     */
    public function ajaxLogin(Request $request, Response $response, array $args)
    {
        $length = $request->getParam('length');
        $page = $request->getParam('start') / $length + 1;
        $draw = $request->getParam('draw');

        $logins = LoginIp::orderBy('id', 'desc')->paginate($length, '*', '', $page);
        $total = LoginIp::count();

        $QQWry = new QQWry();
        foreach ($logins as $login) {
            $login->user_name = $login->userName();
            $login->location = $login->location($QQWry);
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
     * @param array     $args
     */
    public function alive(Request $request, Response $response, array $args)
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$ip_details)
                ->display('admin/log/alive.tpl')
        );
    }

    /**
     * 后台在线 IP 页面 AJAX
     *
     * @param array     $args
     */
    public function ajaxAlive(Request $request, Response $response, array $args)
    {
        $length = $request->getParam('length');
        $page = $request->getParam('start') / $length + 1;
        $draw = $request->getParam('draw');

        $alives = Ip::where('datetime', '>=', \time() - 60)->orderBy('id', 'desc')->paginate($length, '*', '', $page);
        $total = count(Ip::where('datetime', '>=', \time() - 60)->orderBy('id', 'desc')->get());

        $QQWry = new QQWry();
        foreach ($alives as $alive) {
            $alive->user_name = $alive->userName();
            $alive->node_name = $alive->nodeName();
            $alive->ip = Tools::getRealIp($alive->ip);
            $alive->location = $alive->location($QQWry);
            $alive->datetime = Tools::toDateTime((int) $alive->datetime);
        }

        return $response->withJson([
            'draw' => $draw,
            'recordsTotal' => $total,
            'recordsFiltered' => $total,
            'alives' => $alives,
        ]);
    }
}

<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\UserMoneyLog;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class MoneyLogController extends BaseController
{
    private static array $details =
    [
        'field' => [
            'id' => 'شناسه رویداد',
            'user_id' => 'شناسه کاربر',
            'before' => 'موجودی قبل از تغییرات',
            'after' => 'موجودی پس از تغییر',
            'amount' => 'میزان تغییر',
            'remark' => 'ریمارک',
            'create_time' => 'زمان تغییر',
        ],
    ];

    /**
     * 后台用户余额记录页面
     *
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('admin/log/money.tpl')
        );
    }

    /**
     * 后台用户余额记录页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $money_logs = UserMoneyLog::orderBy('id', 'desc')->get();

        foreach ($money_logs as $money_log) {
            $money_log->create_time = Tools::toDateTime((int) $money_log->create_time);
        }

        return $response->withJson([
            'money_logs' => $money_logs,
        ]);
    }
}

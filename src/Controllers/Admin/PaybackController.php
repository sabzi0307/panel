<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Payback;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class PaybackController extends BaseController
{
    private static array $details =
        [
            'field' => [
                'id' => 'شناسه رویداد',
                'total' => 'مبلغ اصلی',
                'userid' => 'شروع شناسه کاربر',
                'user_name' => 'شروع نام کاربری',
                'ref_by' => 'شناسه کاربر سودآور',
                'ref_user_name' => 'نام کاربری سودآور',
                'ref_get' => 'مقدار سود',
                'invoice_id' => 'شناسه قبض',
                'datetime' => 'زمان',
            ],
        ];

    /**
     * 后台邀请记录页面
     *
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('admin/log/payback.tpl')
        );
    }

    /**
     * 后台登录记录页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $paybacks = (new Payback())->orderBy('id', 'desc')->get();

        foreach ($paybacks as $payback) {
            $payback->datetime = Tools::toDateTime((int) $payback->datetime);
            $payback->user_name = $payback->getAttributes();
            $payback->ref_user_name = $payback->getAttributes();
        }

        return $response->withJson([
            'paybacks' => $paybacks,
        ]);
    }
}

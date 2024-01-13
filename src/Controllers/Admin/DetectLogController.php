<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\DetectLog;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class DetectLogController extends BaseController
{
    private static array $details =
        [
            'field' => [
                'id' => 'شناسه رویداد',
                'user_id' => 'شناسه کاربر',
                'node_id' => 'شناسه گره',
                'node_name' => 'نام گره',
                'list_id' => 'شناسه قانون',
                'rule_name' => 'نام قانون',
                'datetime' => 'زمان',
            ],
        ];

    /**
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('admin/log/detect.tpl')
        );
    }

    public function ajax(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $length = $request->getParam('length');
        $page = $request->getParam('start') / $length + 1;
        $draw = $request->getParam('draw');

        $detect_log = DetectLog::query();

        $search = $request->getParam('search')['value'];

        if ($search !== '') {
            $detect_log->where('user_id', '=', $search)
                ->orWhere('list_id', '=', $search)
                ->orWhere('node_id', '=', $search);
        }

        $order = $request->getParam('order')[0]['dir'];

        if ($request->getParam('order')[0]['column'] !== '0') {
            $order_field = self::$details['field'][$request->getParam('order')[0]['column']];

            $detect_log->orderBy($order_field, $order)->orderBy('id', 'desc');
        } else {
            $detect_log->orderBy('id', $order);
        }

        $filtered = $detect_log->count();
        $total = (new DetectLog())->count();

        $logs = $detect_log->paginate($length, '*', '', $page);

        foreach ($logs as $log) {
            $log->node_name = $log->nodeName();
            $log->rule_name = $log->ruleName();
            $log->datetime = Tools::toDateTime((int) $log->datetime);
        }

        return $response->withJson([
            'draw' => $draw,
            'recordsTotal' => $total,
            'recordsFiltered' => $filtered,
            'logs' => $logs,
        ]);
    }
}

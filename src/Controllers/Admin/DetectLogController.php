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
                'user_name' => 'نام کاربری',
                'node_id' => 'شناسه گره',
                'node_name' => 'نام گره',
                'list_id' => 'شناسه قانون',
                'rule_name' => 'نام قانون',
                'rule_text' => 'شرح قانون',
                'rule_regex' => 'عبارت منظم',
                'rule_type' => 'نوع قانون',
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

        $logs = DetectLog::orderBy('id', 'desc')->paginate($length, '*', '', $page);
        $total = DetectLog::count();

        foreach ($logs as $log) {
            $log->user_name = $log->userName();
            $log->node_name = $log->nodeName();
            $log->rule_name = $log->ruleName();
            $log->rule_text = $log->ruleText();
            $log->rule_regex = $log->ruleRegex();
            $log->rule_type = $log->ruleType();
            $log->datetime = Tools::toDateTime((int) $log->datetime);
        }

        return $response->withJson([
            'draw' => $draw,
            'recordsTotal' => $total,
            'recordsFiltered' => $total,
            'logs' => $logs,
        ]);
    }
}

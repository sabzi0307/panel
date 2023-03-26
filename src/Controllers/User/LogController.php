<?php

declare(strict_types=1);

namespace App\Controllers\User;

use App\Controllers\BaseController;
use App\Models\DetectLog;
use App\Models\UserSubscribeLog;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class LogController extends BaseController
{
    /**
     * 订阅记录
     *
     * @throws Exception
     */
    public function subscribe(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $logs = UserSubscribeLog::orderBy('id', 'desc')->where('user_id', $this->user->id)->get();

        foreach ($logs as $log) {
            $log->location = Tools::getIpLocation($log->request_ip);
        }

        return $response->write($this->view()
            ->assign('logs', $logs)
            ->fetch('user/subscribe_log.tpl'));
    }

    /**
     * 审计碰撞记录
     *
     * @throws Exception
     */
    public function detect(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $logs = DetectLog::orderBy('id', 'desc')->where('user_id', $this->user->id)->get();

        foreach ($logs as $log) {
            $log->node_name = $log->nodeName();
            $log->rule = $log->rule();

            if ($log->rule->type === 1) {
                $log->rule->type = 'مطابقت متن ساده بسته';
            } elseif ($log->type === 2) {
                $log->rule->type = 'مطابقت بسته هگز';
            }

            $log->datetime = Tools::toDateTime($log->datetime);
        }

        return $response->write($this->view()
            ->assign('logs', $logs)
            ->fetch('user/detect/log.tpl'));
    }
}

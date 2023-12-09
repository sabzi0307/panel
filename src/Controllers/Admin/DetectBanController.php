<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\DetectBanLog;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class DetectBanController extends BaseController
{
    private static array $details =
        [
            'field' => [
                'id' => 'شناسه رویداد',
                'user_id' => 'شناسه کاربر',
                'user_name' => 'نام کاربری',
                'detect_number' => 'تعداد تخلفات',
                'ban_time' => 'مدت زمان ممنوعیت (دقیقه)',
                'start_time' => 'زمان شروع آمار',
                'end_time' => 'زمان پایان و ممنوعیت شروع آمار',
                'ban_end_time' => 'ممنوعیت پایان زمان',
                'all_detect_number' => 'تعداد تجمعی تخلفات',
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
                ->fetch('admin/log/detect_ban.tpl')
        );
    }

    public function ajax(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $length = $request->getParam('length');
        $page = $request->getParam('start') / $length + 1;
        $draw = $request->getParam('draw');

        $bans = (new DetectBanLog())->orderBy('id', 'desc')->paginate($length, '*', '', $page);
        $total = (new DetectBanLog())->count();

        foreach ($bans as $ban) {
            $ban->user_name = $ban->userName();
            $ban->start_time = Tools::toDateTime((int) $ban->start_time);
            $ban->end_time = Tools::toDateTime((int) $ban->end_time);
            $ban->ban_end_time = $ban->banEndTime();
        }

        return $response->withJson([
            'draw' => $draw,
            'recordsTotal' => $total,
            'recordsFiltered' => $total,
            'bans' => $bans,
        ]);
    }
}

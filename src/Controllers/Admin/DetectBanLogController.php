<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\DetectBanLog;
use App\Utils\ResponseHelper;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class DetectBanLogController extends BaseController
{
    /**
     * @param array     $args
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('table_config', ResponseHelper::buildTableConfig([
                    'id' => 'ID',
                    'user_id' => 'شناسه کاربر',
                    'user_name' => 'نام کاربری',
                    'email' => 'ایمیل کاربر',
                    'detect_number' => 'تعداد تخلفات',
                    'ban_time' => 'مدت زمان ممنوعیت (دقیقه)',
                    'start_time' => 'زمان شروع آمار',
                    'end_time' => 'زمان پایان و ممنوعیت شروع آمار',
                    'ban_end_time' => 'پایان زمان ممنوعیت',
                    'all_detect_number' => 'تعداد تجمعی تخلفات',
                ], 'ban/ajax'))
                ->fetch('admin/detect/ban.tpl')
        );
    }

    /**
     * @param array     $args
     */
    public function ajaxLog(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $query = DetectBanLog::getTableDataFromAdmin(
            $request,
            static function (&$order_field): void {
                if (\in_array($order_field, ['ban_end_time'])) {
                    $order_field = 'end_time';
                }
            }
        );

        $data = [];
        foreach ($query['datas'] as $value) {
            /** @var DetectBanLog $value */

            if ($value->user() === null) {
                DetectBanLog::userIsNull($value);
                continue;
            }
            $tempdata = [];
            $tempdata['id'] = $value->id;
            $tempdata['user_id'] = $value->user_id;
            $tempdata['user_name'] = $value->user_name;
            $tempdata['email'] = $value->email;
            $tempdata['detect_number'] = $value->detect_number;
            $tempdata['ban_time'] = $value->ban_time;
            $tempdata['start_time'] = $value->startTime();
            $tempdata['end_time'] = $value->endTime();
            $tempdata['ban_end_time'] = $value->banEndTime();
            $tempdata['all_detect_number'] = $value->all_detect_number;

            $data[] = $tempdata;
        }

        return $response->withJson([
            'draw' => $request->getParam('draw'),
            'recordsTotal' => DetectBanLog::count(),
            'recordsFiltered' => $query['count'],
            'data' => $data,
        ]);
    }
}

<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\DetectBanLog;
use App\Models\DetectLog;
use App\Models\DetectRule;
use App\Services\IM\Telegram;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Telegram\Bot\Exceptions\TelegramSDKException;

final class DetectController extends BaseController
{
    public static array $rule_details =
    [
        'field' => [
            'op' => 'شرح اقدام',
            'id' => 'شناسه قانون',
            'name' => 'نام قانون',
            'text' => 'معرفی قوانین',
            'regex' => 'regex',
            'type' => 'نوع قانون',
        ],
        'add_dialog' => [
            [
                'id' => 'name',
                'info' => 'نام قانون',
                'type' => 'input',
                'placeholder' => 'نام قانون فیلترینگ',
            ],
            [
                'id' => 'text',
                'info' => 'معرفی قوانین',
                'type' => 'input',
                'placeholder' => 'قوانین فیلترینگ را بطور مختصر شرح دهید',
            ],
            [
                'id' => 'regex',
                'info' => 'regex',
                'type' => 'input',
                'placeholder' => 'regex برای مطابقت با محتوای فیلترینگ',
            ],
            [
                'id' => 'type',
                'info' => 'نوع قانون',
                'type' => 'select',
                'select' => [
                    '1' => 'مطابقت متن ساده بسته',
                    '0' => 'بسته هگز منطبق',
                ],
            ],
        ],
    ];

    public static array $log_details =
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
            'rule_regex' => 'قانون regular expression',
            'rule_type' => 'نوع قانون',
            'datetime' => 'زمان',
        ],
    ];

    public static array $ban_details =
    [
        'field' => [
            'id' => 'شناسه رویداد',
            'user_name' => 'نام کاربری',
            'user_id' => 'شناسه کاربر',
            'email' => 'صندوق پستی کاربر',
            'detect_number' => 'تعداد تخلفات',
            'ban_time' => 'مدت زمان ممنوعیت (دقیقه)',
            'start_time' => 'زمان شروع آمار',
            'end_time' => 'زمان پایان و شروع آمار ممنوعیت',
            'ban_end_time' => 'پایان زمان ممنوعیت',
            'all_detect_number' => 'مجموع تعداد تخلفات',
        ],
    ];

    /**
     * @throws Exception
     */
    public function detect(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$rule_details)
                ->fetch('admin/detect.tpl')
        );
    }

    /**
     * @throws TelegramSDKException
     */
    public function add(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $rule = new DetectRule();
        $rule->name = $request->getParam('name');
        $rule->text = $request->getParam('text');
        $rule->regex = $request->getParam('regex');
        $rule->type = $request->getParam('type');

        if (! $rule->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'افزودن ناموفق بود',
            ]);
        }

        (new Telegram())->sendMarkdown(0, 'قوانین ممیزی جدید وجود دارد:' . $rule->name);
        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت اضافه شد',
        ]);
    }

    public function delete(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $id = $args['id'];
        $rule = DetectRule::find($id);
        if (! $rule->delete()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'حذف نشد',
            ]);
        }
        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت حذف شد',
        ]);
    }

    /**
     * @throws Exception
     */
    public function log(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$log_details)
                ->fetch('admin/log/detect.tpl')
        );
    }

    /**
     * @throws Exception
     */
    public function ban(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$ban_details)
                ->fetch('admin/log/detect_ban.tpl')
        );
    }

    public function ajaxRule(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $rules = DetectRule::orderBy('id', 'desc')->get();

        foreach ($rules as $rule) {
            $rule->op = '<button type="button" class="btn btn-red" id="delete-rule-' . $rule->id . '" 
            onclick="deleteRule(' . $rule->id . ')">حذف</button>';
            $rule->type = $rule->type();
        }

        return $response->withJson([
            'rules' => $rules,
        ]);
    }

    public function ajaxLog(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
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

    public function ajaxBan(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $length = $request->getParam('length');
        $page = $request->getParam('start') / $length + 1;
        $draw = $request->getParam('draw');

        $bans = DetectBanLog::orderBy('id', 'desc')->paginate($length, '*', '', $page);
        $total = DetectBanLog::count();

        foreach ($bans as $ban) {
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

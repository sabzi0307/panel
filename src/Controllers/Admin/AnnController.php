<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Ann;
use App\Models\Config;
use App\Models\EmailQueue;
use App\Models\User;
use App\Services\IM\Telegram;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Telegram\Bot\Exceptions\TelegramSDKException;
use function str_replace;
use function strip_tags;
use function time;
use const PHP_EOL;

final class AnnController extends BaseController
{
    private static array $details =
        [
            'field' => [
                'op' => 'operate',
                'id' => 'Announcement ID',
                'date' => 'date',
                'content' => 'Announcement content',
            ],
        ];

    private static array $update_field = [
        'email_notify_class',
    ];

    /**
     * 后台公告页面
     *
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('admin/announcement/index.tpl')
        );
    }

    /**
     * 后台公告创建页面
     *
     * @throws Exception
     */
    public function create(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('update_field', self::$update_field)
                ->fetch('admin/announcement/create.tpl')
        );
    }

    /**
     * 后台添加公告
     *
     * @throws TelegramSDKException
     */
    public function add(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $email_notify_class = (int) $request->getParam('email_notify_class');
        $email_notify = $request->getParam('email_notify') === 'true' ? 1 : 0;

        $content = strip_tags(
            str_replace(
                ['<p>','</p>'],
                ['','<br><br>'],
                $request->getParam('content')
            ),
            ['br', 'a', 'strong']
        );
        $subject = $_ENV['appName'] . ' - اطلاعیه جدید منتشر شد';

        if ($content !== '') {
            $ann = new Ann();
            $ann->date = Tools::toDateTime(time());
            $ann->content = $content;

            if (! $ann->save()) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'اطلاعیه ذخیره نشد',
                ]);
            }
        }

        if ($email_notify) {
            $users = User::where('class', '>=', $email_notify_class)
                ->get();

            foreach ($users as $user) {
                (new EmailQueue())->add(
                    $user->email,
                    $subject,
                    'warn.tpl',
                    [
                        'user' => $user,
                        'text' => $content,
                    ]
                );
            }
        }

        if (Config::obtain('enable_telegram')) {
            try {
                (new Telegram())->sendHtml(0, 'اطلاعیه جدید：' . PHP_EOL . $content);
            } catch (TelegramSDKException $e) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => $email_notify === 1 ? 'اعلان با موفقیت اضافه شد، ایمیل با موفقیت ارسال شد، ارسال تلگرام ناموفق بود' : 'اعلان با موفقیت اضافه شد، ارسال تلگرام ناموفق بود',
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => $email_notify === 1 ? 'اعلان با موفقیت افزوده شد، ایمیل با موفقیت ارسال شد' : 'اعلان با موفقیت اضافه شد',
        ]);
    }

    /**
     * 后台编辑公告页面
     *
     * @throws Exception
     */
    public function edit(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $ann = Ann::find($args['id']);
        return $response->write(
            $this->view()
                ->assign('ann', $ann)
                ->fetch('admin/announcement/edit.tpl')
        );
    }

    /**
     * 后台编辑公告提交
     */
    public function update(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $ann = Ann::find($args['id']);
        $ann->content = (string) $request->getParam('content');
        $ann->date = Tools::toDateTime(time());

        if (! $ann->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'به روز رسانی بولتن ناموفق بود',
            ]);
        }

        if (Config::obtain('enable_telegram')) {
            try {
                (new Telegram())->sendHtml(0, 'به روز رسانی اطلاعیه：' . PHP_EOL . $request->getParam('content'));
            } catch (TelegramSDKException $e) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'اطلاعیه با موفقیت به روز شد، ارسال تلگرام ناموفق بود',
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'اطلاعیه با موفقیت به روز شد',
        ]);
    }

    /**
     * 后台删除公告
     */
    public function delete(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $ann = Ann::find($args['id']);
        if (! $ann->delete()) {
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
     * 后台公告页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $anns = Ann::orderBy('id', 'asc')->get();

        foreach ($anns as $ann) {
            $ann->op = '<button type="button" class="btn btn-red" id="delete-announcement-' . $ann->id . '" 
            onclick="deleteAnn(' . $ann->id . ')">حذف</button>
            <a class="btn btn-blue" href="/admin/announcement/' . $ann->id . '/edit">ویرایش کنید</a>';
        }

        return $response->withJson([
            'anns' => $anns,
        ]);
    }
}

<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Ann;
use App\Models\User;
use App\Utils\Telegram;
use League\HTMLToMarkdown\HtmlConverter;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class AnnController extends BaseController
{
    public static $details =
    [
        'field' => [
            'op' => 'operate',
            'id' => 'Announcement ID',
            'date' => 'date',
            'content' => 'Announcement content',
        ],
    ];

    public static $update_field = [
        'email_notify_class',
    ];

    /**
     * 后台公告页面
     *
     * @param array     $args
     */
    public function index(ServerRequest $request, Response $response, array $args)
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
     * @param array     $args
     */
    public function create(ServerRequest $request, Response $response, array $args)
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
     * @param array     $args
     */
    public function add(ServerRequest $request, Response $response, array $args)
    {
        $email_notify_class = (int) $request->getParam('email_notify_class');
        $email_notify = (int) $request->getParam('email_notify');
        $content = (string) $request->getParam('content');
        $subject = $_ENV['appName'] . ' - اطلاعیه';

        if ($content !== '') {
            $ann = new Ann();
            $ann->date = date('Y-m-d H:i:s');
            $ann->content = $content;

            if (! $ann->save()) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'اطلاعیه ذخیره نشد',
                ]);
            }
        }
        if ($email_notify === 1) {
            $users = User::where('class', '>=', $email_notify_class)
                ->get();

            foreach ($users as $user) {
                $user->sendMail(
                    $subject,
                    'news/warn.tpl',
                    [
                        'user' => $user,
                        'text' => $content,
                    ],
                    [],
                    true
                );
            }
        }

        $converter = new HtmlConverter();

        if ($_ENV['enable_telegram']) {
            Telegram::sendMarkdown('اعلان جدید：' . PHP_EOL . $converter->convert($request->getParam('content')));
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => $email_notify === 1 ? 'اعلان با موفقیت افزوده شد، ایمیل با موفقیت ارسال شد' : 'اعلان با موفقیت اضافه شد',
        ]);
    }

    /**
     * 后台编辑公告页面
     *
     * @param array     $args
     */
    public function edit(ServerRequest $request, Response $response, array $args)
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
     *
     * @param array     $args
     */
    public function update(ServerRequest $request, Response $response, array $args)
    {
        $ann = Ann::find($args['id']);
        $ann->content = $request->getParam('content');
        $ann->date = date('Y-m-d H:i:s');
        if (! $ann->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'موفق به ویرایش نمی شوند',
            ]);
        }
        Telegram::sendMarkdown('به روز رسانی اعلان：' . PHP_EOL . $request->getParam('markdown'));
        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت اصلاح شد',
        ]);
    }

    /**
     * 后台删除公告
     *
     * @param array     $args
     */
    public function delete(ServerRequest $request, Response $response, array $args)
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
     *
     * @param array     $args
     */
    public function ajax(ServerRequest $request, Response $response, array $args)
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

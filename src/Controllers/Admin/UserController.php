<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\AuthController;
use App\Controllers\BaseController;
use App\Models\User;
use App\Models\UserMoneyLog;
use App\Utils\Hash;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function str_replace;
use const PHP_EOL;

final class UserController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'شرح عملیات',
            'id' => 'شناسه کاربر',
            'user_name' => 'نام مستعار',
            'email' => 'ایمیل',
            'money' => 'اعتبار',
            'ref_by' => 'دعوت شده',
            'transfer_enable' => 'محدودیت های ترافیکی',
            'transfer_used' => 'مصرف کنونی',
            'class' => 'درجه',
            'is_admin' => 'آیا شما مدیر هستید',
            'is_banned' => 'دلیل ممنوعیت',
            'is_inactive' => 'غیرفعال',
            'reg_date' => 'زمان ثبت نام',
            'class_expire' => 'درجه منقضی شده',
        ],
        'create_dialog' => [
            [
                'id' => 'email',
                'info' => 'ایمیل ورود',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'password',
                'info' => 'رمز عبور',
                'type' => 'input',
                'placeholder' => 'خالی بگذارید تا به صورت تصادفی تولید شود',
            ],
            [
                'id' => 'ref_by',
                'info' => 'کاربر دعوت کننده',
                'type' => 'input',
                'placeholder' => 'شناسه کاربر دعوت کننده، می تواند خالی بماند',
            ],
            [
                'id' => 'balance',
                'info' => 'موجودی حساب',
                'type' => 'input',
                'placeholder' => 'به طور پیش فرض ۱- تنظیم شده است،',
            ],
        ],
    ];

    private static array $update_field = [
        'email',
        'user_name',
        'remark',
        'pass',
        'money',
        'is_admin',
        'ga_enable',
        'is_banned',
        'banned_reason',
        'is_shadow_banned',
        'transfer_enable',
        'ref_by',
        'class_expire',
        'node_group',
        'class',
        'auto_reset_day',
        'auto_reset_bandwidth',
        'node_speedlimit',
        'node_iplimit',
        'port',
        'passwd',
        'method',
        'forbidden_ip',
        'forbidden_port',
    ];

    /**
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('admin/user/index.tpl')
        );
    }

    /**
     * @param ServerRequest $request
     * @param Response $response
     * @param array $args
     *
     * @return Response|ResponseInterface
     *
     * @throws Exception
     */
    public function create(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $email = $request->getParam('email');
        $ref_by = $request->getParam('ref_by');
        $password = $request->getParam('password');
        $balance = $request->getParam('balance');

        if ($email === '' || ! Tools::isEmailLegal($email)) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'اشکال در قالب ایمیل',
            ]);
        }

        $exist = (new User())->where('email', $email)->first();

        if ($exist !== null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'صندوق پستی از قبل وجود دارد',
            ]);
        }

        if ($password === '') {
            $password = Tools::genRandomChar(16);
        }

        (new AuthController())->registerHelper($response, 'user', $email, $password, '', 0, '', $balance, 1);
        $user = (new User())->where('email', $email)->first();

        if ($ref_by !== '') {
            $user->ref_by = (int) $ref_by;
            $user->save();
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت اضافه شد، ایمیل کاربر：'.$email.' کلمه عبور：'.$password,
        ]);
    }

    /**
     * @throws Exception
     */
    public function edit(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $user = (new User())->find($args['id']);

        return $response->write(
            $this->view()
                ->assign('update_field', self::$update_field)
                ->assign('edit_user', $user)
                ->fetch('admin/user/edit.tpl')
        );
    }

    public function update(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $id = (int) $args['id'];
        $user = (new User())->find($id);

        if ($request->getParam('pass') !== '' && $request->getParam('pass') !== null) {
            $user->pass = Hash::passwordHash($request->getParam('pass'));
            $user->cleanLink();
        }

        if ($request->getParam('money') !== '' &&
            $request->getParam('money') !== null &&
            (float) $request->getParam('money') !== $user->money
        ) {
            $money = (float) $request->getParam('money');
            $diff = $money - $user->money;
            $remark = ($diff > 0 ? 'ادمین افزودن ترافیک' : 'ادمین کسر موجودی');
            (new UserMoneyLog())->add($id, (float) $user->money, $money, $diff, $remark);
            $user->money = $money;
        }

        $user->email = $request->getParam('email');
        $user->user_name = $request->getParam('user_name');
        $user->remark = $request->getParam('remark');
        $user->is_admin = $request->getParam('is_admin') === 'true' ? 1 : 0;
        $user->ga_enable = $request->getParam('ga_enable') === 'true' ? 1 : 0;
        $user->is_banned = $request->getParam('is_banned') === 'true' ? 1 : 0;
        $user->banned_reason = $request->getParam('banned_reason');
        $user->is_shadow_banned = $request->getParam('is_shadow_banned') === 'true' ? 1 : 0;
        $user->transfer_enable = Tools::autoBytesR($request->getParam('transfer_enable'));
        $user->ref_by = $request->getParam('ref_by');
        $user->class_expire = $request->getParam('class_expire');
        $user->node_group = $request->getParam('node_group');
        $user->class = $request->getParam('class');
        $user->auto_reset_day = $request->getParam('auto_reset_day');
        $user->auto_reset_bandwidth = $request->getParam('auto_reset_bandwidth');
        $user->node_speedlimit = $request->getParam('node_speedlimit');
        $user->node_iplimit = $request->getParam('node_iplimit');
        $user->port = $request->getParam('port');
        $user->passwd = $request->getParam('passwd');
        $user->method = $request->getParam('method');
        $user->forbidden_ip = str_replace(PHP_EOL, ',', $request->getParam('forbidden_ip'));
        $user->forbidden_port = str_replace(PHP_EOL, ',', $request->getParam('forbidden_port'));

        if (! $user->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'موفق به ویرایش نشدن',
            ]);
        }
        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت اصلاح شد',
        ]);
    }

    public function delete(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $id = $args['id'];
        $user = (new User())->find((int) $id);

        if (! $user->kill()) {
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

    public function ajax(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $users = (new User())->orderBy('id', 'desc')->get();

        foreach ($users as $user) {
            $user->op = '<button type="button" class="btn btn-red" id="delete-user-' . $user->id . '" 
            onclick="deleteUser(' . $user->id . ')">حذف</button>
            <a class="btn btn-blue" href="/admin/user/' . $user->id . '/edit">ویرایش</a>';
            $user->transfer_enable = $user->enableTraffic();
            $user->transfer_used = $user->usedTraffic();
            $user->is_admin = $user->is_admin === 1 ? 'بله' : 'خیر';
            $user->is_banned = $user->is_banned === 1 ? 'بله' : 'خیر';
            $user->is_inactive = $user->is_inactive === 1 ? 'بله' : 'خیر';
        }

        return $response->withJson([
            'users' => $users,
        ]);
    }
}

<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Payback;
use App\Models\User;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function is_numeric;

final class InviteController extends BaseController
{
    private static array $details =
        [
            'field' => [
                'id' => 'شناسه رویداد',
                'total' => 'مقدار اصلی',
                'userid' => 'شروع شناسه کاربری',
                'user_name' => 'شروع نام کاربری',
                'ref_by' => 'شناسه کاربری پاداش',
                'ref_user_name' => 'نام کاربری پاداش',
                'ref_get' => 'مقدار پاداش',
                'datetime' => 'زمان',
            ],
            'update_dialog' => [
                [
                    'id' => 'userid',
                    'info' => 'کاربر تغییر یافته',
                    'type' => 'input',
                    'placeholder' => 'شناسه کاربری یا ایمیل دعوت کننده باید اصلاح شود',
                ],
                [
                    'id' => 'refid',
                    'info' => 'شناسه دعوت کننده',
                    'type' => 'input',
                    'placeholder' => 'شناسه کاربری دعوت کننده مورد نظر',
                ],
            ],
            'add_dialog' => [
                [
                    'id' => 'userid',
                    'info' => 'کاربر تغییر یافته',
                    'type' => 'input',
                    'placeholder' => 'شناسه کاربری یا ایمیل برای تعداد دعوت نامه های مورد نیاز',
                ],
                [
                    'id' => 'invite_num',
                    'info' => 'تعداد دعوت نامه ها',
                    'type' => 'input',
                    'placeholder' => 'تعداد دعوت‌نامه‌ها برای اضافه کردن',
                ],
            ],
        ];

    /**
     * 后台邀请记录页面
     *
     * @throws Exception
     */
    public function invite(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('admin/log/invite.tpl')
        );
    }

    /**
     * 更改用户邀请者
     */
    public function update(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $userid = $request->getParam('userid');

        if ($userid === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطا در پارامتر',
            ]);
        }

        if (str_contains($userid, '@')) {
            $user = User::where('email', '=', $userid)->first();
        } else {
            $user = User::find((int) $userid);
        }

        if ($user === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'دعوت کننده تغییر نکرد، بررسی کنید که آیا شناسه/ایمیل کاربر به درستی وارد شده است یا خیر',
            ]);
        }

        $user->ref_by = $request->getParam('refid', 0);  //如未提供，则删除用户的邀请者
        $user->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'دعوت کننده با موفقیت تغییر کرد',
        ]);
    }

    /**
     * 为用户添加邀请次数
     */
    public function add(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $invite_num = (int) $request->getParam('invite_num');

        if (! is_numeric($invite_num)) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'تعداد دعوت نامه ها اشتباه است',
            ]);
        }

        if (str_contains($request->getParam('userid'), '@')) {
            $user = User::where('email', '=', $request->getParam('userid'))->first();
        } else {
            $user = User::find((int) $request->getParam('userid'));
        }

        if ($user === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'تعداد دعوت‌نامه‌ها اضافه نشد، بررسی کنید که آیا شناسه/ایمیل کاربر به درستی وارد شده است',
            ]);
        }

        $user->addInviteNum($invite_num);

        return $response->withJson([
            'ret' => 1,
            'msg' => 'دعوت نامه ها با موفقیت اضافه شد',
        ]);
    }

    /**
     * 后台登录记录页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $paybacks = Payback::orderBy('id', 'desc')->get();

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

<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Models\User;
use App\Services\Analytics;
use App\Services\Config;
use App\Utils\ResponseHelper;
use App\Utils\Tools;
use Ozdemir\Datatables\Datatables;
use Ozdemir\Datatables\DB\MySQL;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

/*
 *  Admin Controller
 */
final class AdminController extends BaseController
{
    /**
     * 后台首页
     *
     * @param array     $args
     */
    public function index(ServerRequest $request, Response $response, array $args)
    {
        return $response->write(
            $this->view()
                ->assign('sts', new Analytics())
                ->fetch('admin/index.tpl')
        );
    }

    /**
     * 后台邀请返利页面
     *
     * @param array     $args
     */
    public function invite(ServerRequest $request, Response $response, array $args)
    {
        return $response->write(
            $this->view()
                ->assign('table_config', ResponseHelper::buildTableConfig([
                    'id' => 'ID',
                    'total' => 'مقدار اصلی',
                    'event_user_id' => 'شروع شناسه کاربر',
                    'event_user_name' => 'شروع نام کاربری',
                    'ref_user_id' => 'شناسه کاربری پاداش',
                    'ref_user_name' => 'نام کاربری پاداش',
                    'ref_get' => 'مقدار پاداش',
                    'datetime' => 'زمان',
                ], 'payback/ajax'))
                ->fetch('admin/invite.tpl')
        );
    }

    /**
     * 后台邀请返利页面 AJAX
     *
     * @param array     $args
     */
    public function ajaxPayback(ServerRequest $request, Response $response, array $args)
    {
        $datatables = new Datatables(new MySQL(Config::getDbConfig()));
        $datatables->query('Select payback.id,payback.total,payback.userid as event_user_id,event_user.user_name as event_user_name,payback.ref_by as ref_user_id,ref_user.user_name as ref_user_name,payback.ref_get,payback.datetime from payback,user as event_user,user as ref_user where event_user.id = payback.userid and ref_user.id = payback.ref_by');
        $datatables->edit('datetime', static function ($data) {
            return date('Y-m-d H:i:s', $data['datetime']);
        });
        return $response->write(
            (string) $datatables->generate()
        );
    }

    /**
     * 更改用户邀请者
     *
     * @param array     $args
     */
    public function chgInvite(ServerRequest $request, Response $response, array $args)
    {
        $userid = $request->getParam('userid');
        if ($userid === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'دعوت کننده تغییر نکرد، بررسی کنید که آیا شناسه کاربری به درستی وارد شده است یا خیر',
            ]);
        }
        if (strpos($userid, '@') !== false) {
            $user = User::where('email', '=', $userid)->first();
        } else {
            $user = User::find((int) $userid);
        }
        if ($user === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'دعوت کننده تغییر نکرد، بررسی کنید که آیا شناسه کاربری به درستی وارد شده است یا خیر',
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
     *
     * @param array     $args
     */
    public function addInvite(ServerRequest $request, Response $response, array $args)
    {
        $num = $request->getParam('num');
        if (Tools::isInt($num) === false) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'درخواست غیر مجاز',
            ]);
        }
        if ($request->getParam('uid') === '0') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'تعداد دعوت‌نامه‌ها اضافه نشد، بررسی کنید که آیا شناسه کاربری یا ایمیل کاربر به درستی وارد شده است',
            ]);
        }
        if (strpos($request->getParam('uid'), '@') !== false) {
            $user = User::where('email', '=', $request->getParam('uid'))->first();
        } else {
            $user = User::find((int) $request->getParam('uid'));
        }
        if ($user === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'تعداد دعوت‌نامه‌ها اضافه نشد، بررسی کنید که آیا شناسه کاربری یا ایمیل کاربر به درستی وارد شده است',
            ]);
        }
        $user->addInviteNum((int) $num);
        return $response->withJson([
            'ret' => 1,
            'msg' => 'دعوت‌نامه‌ها با موفقیت اضافه شدند',
        ]);
    }
}

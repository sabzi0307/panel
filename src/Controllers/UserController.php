<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Models\Ann;
use App\Models\Bought;
use App\Models\Code;
use App\Models\Docs;
use App\Models\EmailVerify;
use App\Models\InviteCode;
use App\Models\LoginIp;
use App\Models\Node;
use App\Models\Payback;
use App\Models\Setting;
use App\Models\StreamMedia;
use App\Models\User;
use App\Services\Auth;
use App\Services\Captcha;
use App\Services\Config;
use App\Services\DB;
use App\Services\MFA;
use App\Services\Payment;
use App\Utils\Check;
use App\Utils\Cookie;
use App\Utils\Hash;
use App\Utils\ResponseHelper;
use App\Utils\TelegramSessionManager;
use App\Utils\Tools;
use Ramsey\Uuid\Uuid;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use voku\helper\AntiXSS;

/**
 *  HomeController
 */
final class UserController extends BaseController
{
    /**
     * @param array     $args
     */
    public function index(ServerRequest $request, Response $response, array $args)
    {
        $captcha = [];

        if (Setting::obtain('enable_checkin_captcha') === true) {
            $captcha = Captcha::generate();
        }

        $data = [
            'today_traffic_usage' => (int) $this->user->transfer_enable === 0 ? 0 : ($this->user->u + $this->user->d - $this->user->last_day_t) / $this->user->transfer_enable * 100,
            'past_traffic_usage' => (int) $this->user->transfer_enable === 0 ? 0 : $this->user->last_day_t / $this->user->transfer_enable * 100,
            'residual_flow' => (int) $this->user->transfer_enable === 0 ? 0 : ($this->user->transfer_enable - ($this->user->u + $this->user->d)) / $this->user->transfer_enable * 100,
        ];

        return $response->write(
            $this->view()
                ->assign('ann', Ann::orderBy('date', 'desc')->first())
                ->assign('getUniversalSub', SubController::getUniversalSub($this->user))
                ->assign('getTraditionalSub', LinkController::getTraditionalSub($this->user))
                ->assign('data', $data)
                ->assign('captcha', $captcha)
                ->fetch('user/index.tpl')
        );
    }

    /**
     * @param array     $args
     */
    public function code(ServerRequest $request, Response $response, array $args)
    {
        $pageNum = $request->getQueryParams()['page'] ?? 1;
        $codes = Code::where('type', '<>', '-2')
            ->where('userid', '=', $this->user->id)
            ->orderBy('id', 'desc')
            ->paginate(15, ['*'], 'page', $pageNum);

        $render = Tools::paginateRender($codes);

        return $response->write(
            $this->view()
                ->assign('codes', $codes)
                ->assign('payments', Payment::getPaymentsEnabled())
                ->assign('render', $render)
                ->fetch('user/code.tpl')
        );
    }

    /**
     * @param array     $args
     */
    public function codeCheck(ServerRequest $request, Response $response, array $args)
    {
        $time = $request->getQueryParams()['time'];
        $codes = Code::where('userid', '=', $this->user->id)
            ->where('usedatetime', '>', date('Y-m-d H:i:s', $time))
            ->first();

        if ($codes !== null && strpos($codes->code, 'شارژ مجدد') !== false) {
            return $response->withJson([
                'ret' => 1,
            ]);
        }
        return $response->withJson([
            'ret' => 0,
        ]);
    }

    /**
     * @param array     $args
     */
    public function codePost(ServerRequest $request, Response $response, array $args)
    {
        $code = trim($request->getParam('code'));
        if ($code === '') {
            return ResponseHelper::error($response, 'لطفا کد شارژ را وارد کنید');
        }

        $codeq = Code::where('code', $code)->where('isused', 0)->first();
        if ($codeq === null) {
            return ResponseHelper::error($response, 'بدون کد شارژ');
        }

        $user = $this->user;
        $codeq->isused = 1;
        $codeq->usedatetime = date('Y-m-d H:i:s');
        $codeq->userid = $user->id;
        $codeq->save();

        if ($codeq->type === -1) {
            $user->money += $codeq->number;
            $user->save();

            // 返利
            if ($user->ref_by > 0 && Setting::obtain('invitation_mode') === 'after_recharge') {
                Payback::rebate($user->id, $codeq->number);
            }

            return $response->withJson([
                'ret' => 1,
                'msg' => 'مبادله موفقیت آمیز بود، مقدار آن برابر با ' . $codeq->number . ' تومان',
            ]);
        }

        if ($codeq->type === 10001) {
            $user->transfer_enable += $codeq->number * 1024 * 1024 * 1024;
            $user->save();
        }

        if ($codeq->type === 10002) {
            if (\time() > strtotime($user->expire_in)) {
                $user->expire_in = date('Y-m-d H:i:s', \time() + (int) $codeq->number * 86400);
            } else {
                $user->expire_in = date('Y-m-d H:i:s', strtotime($user->expire_in) + (int) $codeq->number * 86400);
            }
            $user->save();
        }

        if ($codeq->type >= 1 && $codeq->type <= 10000) {
            if ($user->class === 0 || $user->class !== $codeq->type) {
                $user->class_expire = date('Y-m-d H:i:s', \time());
                $user->save();
            }
            $user->class_expire = date('Y-m-d H:i:s', strtotime($user->class_expire) + (int) $codeq->number * 86400);
            $user->class = $codeq->type;
            $user->save();
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => '',
        ]);
    }

    /**
     * @param array     $args
     */
    public function resetPort(ServerRequest $request, Response $response, array $args)
    {
        $temp = $this->user->resetPort();
        return $response->withJson([
            'ret' => ($temp['ok'] === true ? 1 : 0),
            'msg' => $temp['msg'],
        ]);
    }

    /**
     * @param array     $args
     */
    public function specifyPort(ServerRequest $request, Response $response, array $args)
    {
        $temp = $this->user->specifyPort((int) $request->getParam('port'));
        return $response->withJson([
            'ret' => ($temp['ok'] === true ? 1 : 0),
            'msg' => $temp['msg'],
        ]);
    }

    /**
     * @param array     $args
     */
    public function profile(ServerRequest $request, Response $response, array $args)
    {
        // 登录IP
        $loginips = LoginIp::where('userid', '=', $this->user->id)->where('type', '=', 0)->orderBy('datetime', 'desc')->take(10)->get();

        return $response->write(
            $this->view()
                ->assign('loginips', $loginips)
                ->registerClass('Tools', Tools::class)
                ->fetch('user/profile.tpl')
        );
    }

    /**
     * @param array     $args
     */
    public function announcement(ServerRequest $request, Response $response, array $args)
    {
        $Anns = Ann::orderBy('date', 'desc')->get();

        if ($request->getParam('json') === 1) {
            return $response->withJson([
                'Anns' => $Anns,
                'ret' => 1,
            ]);
        }

        return $response->write(
            $this->view()
                ->assign('anns', $Anns)
                ->fetch('user/announcement.tpl')
        );
    }

    /**
     * @param array     $args
     */
    public function docs(ServerRequest $request, Response $response, array $args)
    {
        $docs = Docs::orderBy('id', 'desc')->get();

        if ($request->getParam('json') === 1) {
            return $response->withJson([
                'docs' => $docs,
                'ret' => 1,
            ]);
        }

        return $response->write(
            $this->view()
                ->assign('docs', $docs)
                ->fetch('user/docs.tpl')
        );
    }

    /**
     * @param array     $args
     */
    public function media(ServerRequest $request, Response $response, array $args)
    {
        $results = [];
        $pdo = DB::getPdo();
        $nodes = $pdo->query('SELECT DISTINCT node_id FROM stream_media');

        foreach ($nodes as $node_id) {
            $node = Node::where('id', $node_id)->first();

            $unlock = StreamMedia::where('node_id', $node_id)
                ->orderBy('id', 'desc')
                ->where('created_at', '>', \time() - 86460) // 只获取最近一天零一分钟内上报的数据
                ->first();

            if ($unlock !== null && $node !== null) {
                $details = \json_decode($unlock->result, true);
                $details = str_replace('Originals Only', 'فقط خانگی', $details);
                $details = str_replace('Oversea Only', 'فقط در خارج از کشور', $details);

                foreach ($details as $key => $value) {
                    $info = [
                        'node_name' => $node->name,
                        'created_at' => $unlock->created_at,
                        'unlock_item' => $details,
                    ];
                }

                array_push($results, $info);
            }
        }

        if ($_ENV['streaming_media_unlock_multiplexing'] !== null) {
            foreach ($_ENV['streaming_media_unlock_multiplexing'] as $key => $value) {
                $key_node = Node::where('id', $key)->first();
                $value_node = StreamMedia::where('node_id', $value)
                    ->orderBy('id', 'desc')
                    ->where('created_at', '>', \time() - 86460) // Only get the data reported within the last day and one minute
                    ->first();

                if ($value_node !== null) {
                    $details = \json_decode($value_node->result, true);
                    $details = str_replace('Originals Only', 'فقط خانگی', $details);
                    $details = str_replace('Oversea Only', 'فقط در خارج از کشور', $details);

                    $info = [
                        'node_name' => $key_node->name,
                        'created_at' => $value_node->created_at,
                        'unlock_item' => $details,
                    ];

                    array_push($results, $info);
                }
            }
        }

        $node_names = array_column($results, 'node_name');
        array_multisort($node_names, SORT_ASC, $results);

        return $response->write($this->view()
            ->assign('results', $results)
            ->fetch('user/media.tpl'));
    }

    /**
     * @param array     $args
     */
    public function edit(ServerRequest $request, Response $response, array $args)
    {
        $themes = Tools::getDir(BASE_PATH . '/resources/views');
        $bind_token = TelegramSessionManager::addBindSession($this->user);
        $methods = Config::getSupportParam('method');
        $gaurl = MFA::getGAurl($this->user);

        return $response->write($this->view()
            ->assign('user', $this->user)
            ->assign('themes', $themes)
            ->assign('bind_token', $bind_token)
            ->assign('methods', $methods)
            ->assign('gaurl', $gaurl)
            ->assign('telegram_bot', $_ENV['telegram_bot'])
            ->registerClass('Config', Config::class)
            ->fetch('user/edit.tpl'));
    }

    /**
     * @param array     $args
     */
    public function invite(ServerRequest $request, Response $response, array $args)
    {
        $code = InviteCode::where('user_id', $this->user->id)->first();
        if ($code === null) {
            $this->user->addInviteCode();
            $code = InviteCode::where('user_id', $this->user->id)->first();
        }

        $pageNum = $request->getQueryParams()['page'] ?? 1;

        $paybacks = Payback::where('ref_by', $this->user->id)
            ->orderBy('id', 'desc')
            ->paginate(15, ['*'], 'page', $pageNum);

        $paybacks_sum = Payback::where('ref_by', $this->user->id)->sum('ref_get');
        if (! $paybacks_sum) {
            $paybacks_sum = 0;
        }

        $render = Tools::paginateRender($paybacks);

        $invite_url = $_ENV['baseUrl'] . '/auth/register?code=' . $code->code;

        return $response->write($this->view()
            ->assign('code', $code)
            ->assign('render', $render)
            ->assign('paybacks', $paybacks)
            ->assign('invite_url', $invite_url)
            ->assign('paybacks_sum', $paybacks_sum)
            ->fetch('user/invite.tpl'));
    }

    /**
     * @param array     $args
     */
    public function updatePassword(ServerRequest $request, Response $response, array $args)
    {
        $oldpwd = $request->getParam('oldpwd');
        $pwd = $request->getParam('pwd');
        $repwd = $request->getParam('repwd');
        $user = $this->user;
        if (! Hash::checkPassword($user->pass, $oldpwd)) {
            return ResponseHelper::error($response, 'خطای رمز قدیمی');
        }
        if ($pwd !== $repwd) {
            return ResponseHelper::error($response, 'این دو ورودی مطابقت ندارند');
        }

        if (strlen($pwd) < 8) {
            return ResponseHelper::error($response, 'رمز عبور خیلی کوتاه است');
        }
        $hashPwd = Hash::passwordHash($pwd);
        $user->pass = $hashPwd;
        $user->save();

        if ($_ENV['enable_forced_replacement'] === true) {
            $user->cleanLink();
        }

        return ResponseHelper::successfully($response, 'با موفقیت اصلاح شد');
    }

    /**
     * @param array     $args
     */
    public function updateEmail(ServerRequest $request, Response $response, array $args)
    {
        $antiXss = new AntiXSS();

        $user = $this->user;
        $newemail = $antiXss->xss_clean($request->getParam('newemail'));
        $oldemail = $user->email;
        $otheruser = User::where('email', $newemail)->first();

        if ($_ENV['enable_change_email'] !== true) {
            return ResponseHelper::error($response, 'این مورد مجاز به تغییر توسط خودتان نیست، لطفاً برای عملیات با مدیر تماس بگیرید');
        }

        if (Setting::obtain('reg_email_verify')) {
            $emailcode = $request->getParam('emailcode');
            $mailcount = EmailVerify::where('email', '=', $newemail)->where('code', '=', $emailcode)->where('expire_in', '>', \time())->first();
            if ($mailcount === null) {
                return ResponseHelper::error($response, 'کد تأیید ایمیل شما نادرست است');
            }
        }

        if ($newemail === '') {
            return ResponseHelper::error($response, 'آدرس ایمیل پر نشده است');
        }

        $check_res = Check::isEmailLegal($newemail);
        if ($check_res['ret'] === 0) {
            return $response->withJson($check_res);
        }

        if ($otheruser !== null) {
            return ResponseHelper::error($response, 'ایمیل در حال حاضر در حال استفاده می باشد');
        }

        if ($newemail === $oldemail) {
            return ResponseHelper::error($response, 'ایمیل جدید نمی تواند مانند ایمیل قبلی باشد');
        }

        $user->email = $newemail;
        $user->save();

        return ResponseHelper::successfully($response, '修改成功');
    }

    /**
     * @param array     $args
     */
    public function updateUsername(ServerRequest $request, Response $response, array $args)
    {
        $antiXss = new AntiXSS();

        $newusername = $antiXss->xss_clean($request->getParam('newusername'));
        $user = $this->user;

        $user->user_name = $newusername;
        $user->save();

        return ResponseHelper::successfully($response, 'با موفقیت اصلاح شد');
    }

    /**
     * @param array     $args
     */
    public function bought(ServerRequest $request, Response $response, array $args)
    {
        $pageNum = $request->getQueryParams()['page'] ?? 1;
        $shops = Bought::where('userid', $this->user->id)->orderBy('id', 'desc')->paginate(15, ['*'], 'page', $pageNum);
        if ($request->getParam('json') === 1) {
            foreach ($shops as $shop) {
                $shop->datetime = $shop->datetime();
                $shop->name = $shop->shop()->name;
                $shop->content = $shop->shop()->content();
            }
            return $response->withJson([
                'ret' => 1,
                'shops' => $shops,
            ]);
        }
        $render = Tools::paginateRender($shops);
        return $response->write($this->view()
            ->assign('shops', $shops)
            ->assign('render', $render)
            ->fetch('user/bought.tpl'));
    }

    /**
     * @param array     $args
     */
    public function deleteBoughtGet(ServerRequest $request, Response $response, array $args)
    {
        $id = $request->getParam('id');
        $shop = Bought::where('id', $id)->where('userid', $this->user->id)->first();

        if ($shop === null) {
            return ResponseHelper::error($response, 'تمدید خودکار خاموش نشد، سفارش وجود ندارد.');
        }

        if ($this->user->id === $shop->userid) {
            $shop->renew = 0;
        }

        if (! $shop->save()) {
            return ResponseHelper::error($response, 'تمدید خودکار خاموش نشد');
        }
        return ResponseHelper::successfully($response, 'تمدید خودکار را با موفقیت خاموش شد');
    }

    /**
     * @param array     $args
     */
    public function updateContact(ServerRequest $request, Response $response, array $args)
    {
        $antiXss = new AntiXSS();

        $type = $antiXss->xss_clean($request->getParam('imtype'));
        $value = $antiXss->xss_clean($request->getParam('imvalue'));

        $user = $this->user;

        if ($user->telegram_id !== null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'حساب شما به تلگرام متصل است، بنابراین این مورد قابل تغییر نیست',
            ]);
        }

        if ($value === '' || $type === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'اطلاعات تماس نمی تواند خالی باشد',
            ]);
        }

        $user_exist = User::where('im_value', $value)->where('im_type', $type)->first();
        if ($user_exist !== null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'این مخاطب قبلاً ثبت شده است',
            ]);
        }

        $user->im_type = $type;
        $user->im_value = $value;
        $user->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت اصلاح شد',
        ]);
    }

    /**
     * @param array     $args
     */
    public function updateTheme(ServerRequest $request, Response $response, array $args)
    {
        $antiXss = new AntiXSS();
        $theme = $antiXss->xss_clean($request->getParam('theme'));

        $user = $this->user;

        if ($theme === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'موضوع نمی تواند خالی باشد',
            ]);
        }

        $user->theme = $theme;
        $user->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت اصلاح شد',
        ]);
    }

    /**
     * @param array     $args
     */
    public function updateMail(ServerRequest $request, Response $response, array $args)
    {
        $value = (int) $request->getParam('mail');
        if (\in_array($value, [0, 1, 2])) {
            $user = $this->user;
            if ($value === 2 && $_ENV['enable_telegram'] === false) {
                return ResponseHelper::error(
                    $response,
                    'ویرایش انجام نشد، در حال حاضر نمی‌توان گزارش‌های روزانه را با استفاده از تلگرام دریافت کرد'
                );
            }
            $user->sendDailyMail = $value;
            $user->save();
            return ResponseHelper::successfully($response, 'با موفقیت اصلاح شد');
        }
        return ResponseHelper::error($response, 'ورودی غیرمجاز');
    }

    /**
     * @param array     $args
     */
    public function resetPasswd(ServerRequest $request, Response $response, array $args)
    {
        $user = $this->user;
        $pwd = Tools::genRandomChar(16);
        $current_timestamp = \time();
        $new_uuid = Uuid::uuid3(Uuid::NAMESPACE_DNS, $user->email . '|' . $current_timestamp);
        $existing_uuid = User::where('uuid', $new_uuid)->first();

        if ($existing_uuid !== null) {
            return ResponseHelper::error($response, 'در حال حاضر مشکلاتی وجود دارد، لطفاً بعداً دوباره امتحان کنید');
        }

        $user->uuid = $new_uuid;
        $user->passwd = $pwd;
        $user->save();

        return ResponseHelper::successfully($response, 'با موفقیت اصلاح شد');
    }

    /**
     * @param array     $args
     */
    public function updateMethod(ServerRequest $request, Response $response, array $args)
    {
        $antiXss = new AntiXSS();

        $user = $this->user;

        $method = strtolower($antiXss->xss_clean($request->getParam('method')));

        if ($method === '') {
            ResponseHelper::error($response, 'ورودی غیرمجاز');
        }
        if (! Tools::isParamValidate('method', $method)) {
            ResponseHelper::error($response, 'رمزگذاری نامعتبر است');
        }

        $user->method = $method;
        $user->save();

        return ResponseHelper::successfully($response, 'با موفقیت اصلاح شد');
    }

    /**
     * @param array     $args
     */
    public function logout(ServerRequest $request, Response $response, array $args)
    {
        Auth::logout();
        return $response->withStatus(302)->withHeader('Location', '/');
    }

    /**
     * @param array     $args
     */
    public function doCheckIn(ServerRequest $request, Response $response, array $args)
    {
        if ($_ENV['enable_checkin'] === false) {
            return ResponseHelper::error($response, 'هنوز قادر به ورود به سیستم نیست');
        }

        if (Setting::obtain('enable_checkin_captcha') === true) {
            $ret = Captcha::verify($request->getParams());
            if (! $ret) {
                return ResponseHelper::error($response, 'سیستم نمی‌تواند نتیجه تأیید شما را بپذیرد، لطفاً صفحه را بازخوانی کنید و دوباره امتحان کنید');
            }
        }

        if (strtotime($this->user->expire_in) < \time()) {
            return ResponseHelper::error($response, 'فقط حساب‌هایی که منقضی نشده‌اند می‌توانند وارد شوند');
        }

        $checkin = $this->user->checkin();
        if ($checkin['ok'] === false) {
            return ResponseHelper::error($response, $checkin['msg']);
        }

        return $response->withJson([
            'ret' => 1,
            'trafficInfo' => [
                'todayUsedTraffic' => $this->user->todayUsedTraffic(),
                'lastUsedTraffic' => $this->user->lastUsedTraffic(),
                'unUsedTraffic' => $this->user->unusedTraffic(),
            ],
            'traffic' => Tools::flowAutoShow($this->user->transfer_enable),
            'unflowtraffic' => $this->user->transfer_enable,
            'msg' => $checkin['msg'],
        ]);
    }

    /**
     * @param array     $args
     */
    public function kill(ServerRequest $request, Response $response, array $args)
    {
        return $response->write($this->view()->fetch('user/kill.tpl'));
    }

    /**
     * @param array     $args
     */
    public function handleKill(ServerRequest $request, Response $response, array $args)
    {
        $user = $this->user;

        $passwd = $request->getParam('passwd');

        if (! Hash::checkPassword($user->pass, $passwd)) {
            return ResponseHelper::error($response, 'رمز عبور اشتباه');
        }

        if ($_ENV['enable_kill'] === true) {
            Auth::logout();
            $user->killUser();
            return ResponseHelper::successfully($response, 'حساب شما از سیستم ما حذف شده است.');
        }
        return ResponseHelper::error($response, 'مدیر اجازه حذف را نمی دهد، لطفاً در صورت نیاز به حذف با مدیر تماس بگیرید.');
    }

    /**
     * @param array     $args
     */
    public function banned(ServerRequest $request, Response $response, array $args)
    {
        $user = $this->user;
        return $response->write($this->view()
            ->assign('banned_reason', $user->banned_reason)
            ->fetch('user/banned.tpl'));
    }

    /**
     * @param array     $args
     */
    public function resetTelegram(ServerRequest $request, Response $response, array $args)
    {
        $user = $this->user;
        $user->telegramReset();

        return ResponseHelper::successfully($response, 'بازنشانی با موفقیت انجام شد');
    }

    /**
     * @param array     $args
     */
    public function resetURL(ServerRequest $request, Response $response, array $args)
    {
        $user = $this->user;
        $user->cleanLink();

        return ResponseHelper::successfully($response, 'بازنشانی با موفقیت انجام شد');
    }

    /**
     * @param array     $args
     */
    public function resetInviteURL(ServerRequest $request, Response $response, array $args)
    {
        $user = $this->user;
        $user->clearInviteCodes();

        return ResponseHelper::successfully($response, 'بازنشانی با موفقیت انجام شد');
    }

    /**
     * @param array     $args
     */
    public function backtoadmin(ServerRequest $request, Response $response, array $args)
    {
        $userid = Cookie::get('uid');
        $adminid = Cookie::get('old_uid');
        $user = User::find($userid);
        $admin = User::find($adminid);

        if (! $admin->is_admin || ! $user) {
            Cookie::set([
                'uid' => null,
                'email' => null,
                'key' => null,
                'ip' => null,
                'expire_in' => null,
                'old_uid' => null,
                'old_email' => null,
                'old_key' => null,
                'old_ip' => null,
                'old_expire_in' => null,
                'old_local' => null,
            ], \time() - 1000);
        }
        $expire_in = Cookie::get('old_expire_in');
        $local = Cookie::get('old_local');
        Cookie::set([
            'uid' => Cookie::get('old_uid'),
            'email' => Cookie::get('old_email'),
            'key' => Cookie::get('old_key'),
            'ip' => Cookie::get('old_ip'),
            'expire_in' => $expire_in,
            'old_uid' => null,
            'old_email' => null,
            'old_key' => null,
            'old_ip' => null,
            'old_expire_in' => null,
            'old_local' => null,
        ], $expire_in);
        return $response->withStatus(302)->withHeader('Location', $local);
    }

    /**
     * @param array     $args
     */
    public function switchThemeMode(ServerRequest $request, Response $response, array $args)
    {
        $user = $this->user;
        if ($user->is_dark_mode === 1) {
            $user->is_dark_mode = 0;
        } else {
            $user->is_dark_mode = 1;
        }
        $user->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت تغییر دهید',
        ]);
    }
}

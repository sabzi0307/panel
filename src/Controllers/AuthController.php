<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Models\EmailVerify;
use App\Models\InviteCode;
use App\Models\Setting;
use App\Models\User;
use App\Services\Auth;
use App\Services\Captcha;
use App\Services\Mail;
use App\Utils\Cookie;
use App\Utils\Hash;
use App\Utils\ResponseHelper;
use App\Utils\Tools;
use Exception;
use Psr\Http\Client\ClientExceptionInterface;
use Psr\Http\Message\ResponseInterface;
use Ramsey\Uuid\Uuid;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Vectorface\GoogleAuthenticator;
use voku\helper\AntiXSS;
use function array_rand;
use function date;
use function explode;
use function strlen;
use function strtolower;
use function time;
use function trim;

/**
 *  AuthController
 */
final class AuthController extends BaseController
{
    /**
     * @throws Exception
     */
    public function login(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $captcha = [];

        if (Setting::obtain('enable_login_captcha')) {
            $captcha = Captcha::generate();
        }

        return $response->write($this->view()
            ->assign('base_url', $_ENV['baseUrl'])
            ->assign('captcha', $captcha)
            ->fetch('auth/login.tpl'));
    }

    public function loginHandle(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        if (Setting::obtain('enable_login_captcha')) {
            $ret = Captcha::verify($request->getParams());
            if (! $ret) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'سیستم نمی‌تواند نتیجه تأیید شما را بپذیرد، لطفاً صفحه را بازخوانی کنید و دوباره امتحان کنید.',
                ]);
            }
        }

        $code = $request->getParam('code');
        $passwd = $request->getParam('passwd');
        $rememberMe = $request->getParam('remember_me');
        $email = strtolower(trim($request->getParam('email')));
        $redir = Cookie::get('redir') ?? '/user';

        $user = User::where('email', $email)->first();

        if ($user === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطا در ایمیل یا رمز عبور',
            ]);
        }

        if (! Hash::checkPassword($user->pass, $passwd)) {
            // 记录登录失败
            $user->collectLoginIP($_SERVER['REMOTE_ADDR'], 1);
            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطای ایمیل یا رمز عبور',
            ]);
        }

        if ($user->ga_enable === 1) {
            if (strlen($code) !== 6) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'خطای کد تایید دو مرحله ای',
                ]);
            }

            $ga = new GoogleAuthenticator();
            $rcode = $ga->verifyCode($user->ga_token, $code);

            if (! $rcode) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'خطای کد تایید دو مرحله ای',
                ]);
            }
        }

        $time = 3600 * 24;
        if ($rememberMe) {
            $time = 3600 * 24 * ($_ENV['rememberMeDuration'] ?: 7);
        }

        Auth::login($user->id, $time);
        // 记录登录成功
        $user->collectLoginIP($_SERVER['REMOTE_ADDR']);

        return $response->withJson([
            'ret' => 1,
            'msg' => 'ورود با موفقیت',
            'redir' => $redir,
        ]);
    }

    /**
     * @throws Exception
     */
    public function register(ServerRequest $request, Response $response, $next): Response|ResponseInterface
    {
        $captcha = [];

        if (Setting::obtain('enable_reg_captcha')) {
            $captcha = Captcha::generate();
        }

        $ary = $request->getQueryParams();
        $code = '';
        if (isset($ary['code'])) {
            $antiXss = new AntiXSS();
            $code = $antiXss->xss_clean($ary['code']);
        }

        return $response->write($this->view()
            ->assign('code', $code)
            ->assign('base_url', $_ENV['baseUrl'])
            ->assign('captcha', $captcha)
            ->fetch('auth/register.tpl'));
    }

    public function sendVerify(ServerRequest $request, Response $response, $next): Response|ResponseInterface
    {
        if (Setting::obtain('reg_email_verify')) {
            $antiXss = new AntiXSS();

            $email = strtolower(trim($antiXss->xss_clean($request->getParam('email'))));

            if ($email === '') {
                return ResponseHelper::error($response, 'آدرس ایمیل پر نشده است');
            }

            // check email format
            $check_res = Tools::isEmailLegal($email);
            if ($check_res['ret'] === 0) {
                return $response->withJson($check_res);
            }

            $user = User::where('email', $email)->first();
            if ($user !== null) {
                return ResponseHelper::error($response, 'این ایمیل قبلا ذخیره شده است');
            }

            $ipcount = EmailVerify::where('ip', '=', $_SERVER['REMOTE_ADDR'])
                ->where('expire_in', '>', time())
                ->count();
            if ($ipcount > Setting::obtain('email_verify_ip_limit')) {
                return ResponseHelper::error($response, 'درخواست های این IP بسیار زیاد است');
            }

            $mailcount = EmailVerify::where('email', '=', $email)
                ->where('expire_in', '>', time())
                ->count();
            if ($mailcount > Setting::obtain('email_verify_email_limit')) {
                return ResponseHelper::error($response, 'این ایمیل بارها درخواست شده است');
            }

            $code = Tools::genRandomChar(6);
            $ev = new EmailVerify();
            $ev->expire_in = time() + Setting::obtain('email_verify_ttl');
            $ev->ip = $_SERVER['REMOTE_ADDR'];
            $ev->email = $email;
            $ev->code = $code;
            $ev->save();

            try {
                Mail::send(
                    $email,
                    $_ENV['appName'] . '- ایمیل تایید',
                    'verify_code.tpl',
                    [
                        'code' => $code,
                        'expire' => date('Y-m-d H:i:s', time() + Setting::obtain('email_verify_ttl')),
                    ]
                );
            } catch (Exception | ClientExceptionInterface $e) {
                return ResponseHelper::error($response, 'ایمیل ارسال نشد، لطفا با مدیر سایت تماس بگیرید.');
            }

            return ResponseHelper::successfully($response, 'کد تایید با موفقیت ارسال شد، لطفا ایمیل خود را بررسی کنید.');
        }
        return ResponseHelper::error($response, ' ثبت نام مجاز نیست');
    }

    /**
     * @param Response $response
     * @param $name
     * @param $email
     * @param $passwd
     * @param $code
     * @param $imtype
     * @param $imvalue
     * @param $telegram_id
     * @param $money
     * @param $is_admin_reg
     *
     * @return ResponseInterface
     *
     * @throws Exception
     */
    public static function registerHelper(
        Response $response,
        $name,
        $email,
        $passwd,
        $code,
        $imtype,
        $imvalue,
        $telegram_id,
        $money,
        $is_admin_reg
    ): ResponseInterface {
        $redir = Cookie::get('redir') ?? '/user';
        $configs = Setting::getClass('register');
        // do reg user
        $user = new User();

        $user->user_name = $name;
        $user->email = $email;
        $user->remark = '';
        $user->pass = Hash::passwordHash($passwd);
        $user->passwd = Tools::genRandomChar(16);
        $user->uuid = Uuid::uuid4();
        $user->api_token = Uuid::uuid4();
        $user->port = Tools::getAvPort();
        $user->t = 0;
        $user->u = 0;
        $user->d = 0;
        $user->method = $configs['sign_up_for_method'];
        $user->forbidden_ip = Setting::obtain('reg_forbidden_ip');
        $user->forbidden_port = Setting::obtain('reg_forbidden_port');
        $user->im_type = $imtype;
        $user->im_value = $imvalue;
        $user->telegram_id = $telegram_id;

        $user->transfer_enable = Tools::toGB($configs['sign_up_for_free_traffic']);
        $user->invite_num = $configs['sign_up_for_invitation_codes'];
        $user->auto_reset_day = Setting::obtain('free_user_reset_day');
        $user->auto_reset_bandwidth = Setting::obtain('free_user_reset_bandwidth');
        $user->sendDailyMail = $configs['sign_up_for_daily_report'];

        if ($money > 0) {
            $user->money = $money;
        } else {
            $user->money = 0;
        }

        $user->ref_by = 0;

        if ($code !== '') {
            $invite = InviteCode::where('code', $code)->first();
            $invite->reward();
            $user->ref_by = $invite->user_id;
            $user->money = Setting::obtain('invitation_to_register_balance_reward');
        }

        $ga = new GoogleAuthenticator();
        $secret = $ga->createSecret();
        $user->ga_token = $secret;
        $user->ga_enable = 0;

        $user->class_expire = date('Y-m-d H:i:s', time() + (int) $configs['sign_up_for_class_time'] * 86400);
        $user->class = $configs['sign_up_for_class'];
        $user->node_connector = 0;
        $user->node_iplimit = $configs['connection_ip_limit'];
        $user->node_speedlimit = $configs['connection_rate_limit'];
        $user->expire_in = date('Y-m-d H:i:s', time() + (int) $configs['sign_up_for_free_time'] * 86400);
        $user->reg_date = date('Y-m-d H:i:s');
        $user->reg_ip = $_SERVER['REMOTE_ADDR'];
        $user->theme = $_ENV['theme'];
        $user->use_new_shop = 1;
        $random_group = Setting::obtain('random_group');

        if ($random_group === '') {
            $user->node_group = 0;
        } else {
            $user->node_group = $random_group[array_rand(explode(',', $random_group))];
        }

        if ($user->save() && ! $is_admin_reg) {
            Auth::login($user->id, 3600);
            $user->collectLoginIP($_SERVER['REMOTE_ADDR']);

            return $response->withJson([
                'ret' => 1,
                'msg' => 'ثبت نام با موفقیت انجام شد . در حال هدایت به صفحه ورود',
                'redir' => $redir,
            ]);
        }

        return ResponseHelper::error($response, 'اشتباه ناشناخته');
    }

    /**
     * @throws Exception
     */
    public function registerHandle(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        if (Setting::obtain('reg_mode') === 'close') {
            return ResponseHelper::error($response, 'ثبت نام باز نیست');
        }

        if (Setting::obtain('reg_mode') === 'invite' && $request->getParam('code') === '') {
            return ResponseHelper::error($response, 'برای ثبت نام باید کد دعوت نامه را پر کنید');
        }

        if (Setting::obtain('enable_reg_captcha')) {
            $ret = Captcha::verify($request->getParams());
            if (! $ret) {
                return ResponseHelper::error($response, 'سیستم نمی‌تواند نتیجه تأیید شما را بپذیرد، لطفاً صفحه را بازخوانی کنید و دوباره امتحان کنید.');
            }
        }

        $antiXss = new AntiXSS();

        $tos = $request->getParam('tos') === 'true' ? 1 : 0;
        $email = strtolower(trim($antiXss->xss_clean($request->getParam('email'))));
        $name = $antiXss->xss_clean($request->getParam('name'));
        $passwd = $request->getParam('passwd');
        $repasswd = $request->getParam('repasswd');
        $code = $antiXss->xss_clean(trim($request->getParam('code')));
        // Check TOS agreement
        if (! $tos) {
            return ResponseHelper::error($response, 'لطفاً با شرایط سرویس موافقت کنید');
        }
        // Check Invite Code
        if ($code === '' && Setting::obtain('reg_mode') === 'invite') {
            return ResponseHelper::error($response, 'کد دعوت نمی تواند خالی باشد');
        }

        if ($code !== '') {
            $user_invite = InviteCode::where('code', $code)->first();

            if ($user_invite === null) {
                return ResponseHelper::error($response, 'کد دعوت نامعتبر است');
            }

            $gift_user = User::where('id', $user_invite->user_id)->first();

            if ($gift_user === null || $gift_user->invite_num === 0) {
                return ResponseHelper::error($response, 'کد دعوت نامعتبر است');
            }
        }
        // Check Invite Code
        if ($code === '' && Setting::obtain('reg_mode') === 'invite') {
            return ResponseHelper::error($response, 'کد دعوت نمی تواند خالی باشد');
        }

        if ($code !== '') {
            $user_invite = InviteCode::where('code', $code)->first();

            if ($user_invite === null) {
                return ResponseHelper::error($response, 'کد دعوت نامعتبر است');
            }

            $gift_user = User::where('id', $user_invite->user_id)->first();

            if ($gift_user === null || $gift_user->invite_num === 0) {
                return ResponseHelper::error($response, 'کد دعوت نامعتبر است');
            }
        }

        // Check IM
        if (Setting::obtain('enable_reg_im')) {
            $imtype = $antiXss->xss_clean($request->getParam('im_type'));
            $imvalue = $antiXss->xss_clean($request->getParam('im_value'));

            if ($imtype === '' || $imvalue === '') {
                return ResponseHelper::error($response, 'لطفا اطلاعات تماس خود را وارد کنید');
            }

            $user = User::where('im_value', $imvalue)->where('im_type', $imtype)->first();

            if ($user !== null) {
                return ResponseHelper::error($response, 'این مخاطب قبلاً ذخیره شده است');
            }
        } else {
            $imtype = 1;
            $imvalue = '';
        }

        // check email format
        $check_res = Tools::isEmailLegal($email);
        if ($check_res['ret'] === 0) {
            return $response->withJson($check_res);
        }
        // check email
        $user = User::where('email', $email)->first();
        if ($user !== null) {
            return ResponseHelper::error($response, 'ایمیل ذخیره شده است');
        }
        // check pwd length
        if (strlen($passwd) < 8) {
            return ResponseHelper::error($response, 'رمز عبور لطفا بزرگتر از 8 کاراکتر باشد');
        }
        // check pwd re
        if ($passwd !== $repasswd) {
            return ResponseHelper::error($response, 'دو کلمه عبور وارد شده مطابقت ندارند');
        }

        if (Setting::obtain('reg_email_verify')) {
            $email_code = trim($antiXss->xss_clean($request->getParam('emailcode')));
            $email_verify = EmailVerify::where('email', '=', $email)
                ->where('code', '=', $email_code)
                ->where('expire_in', '>', time())
                ->first();

            if ($email_verify === null) {
                return ResponseHelper::error($response, 'کد تأیید ایمیل شما نادرست است');
            }

            EmailVerify::where('email', $email)->delete();
        }

        return $this->registerHelper($response, $name, $email, $passwd, $code, $imtype, $imvalue, 0, 0, 0);
    }

    public function logout(ServerRequest $request, Response $response, $next): Response
    {
        Auth::logout();
        return $response->withStatus(302)
            ->withHeader('Location', '/auth/login');
    }
}

<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Models\Config;
use App\Models\InviteCode;
use App\Models\LoginIp;
use App\Models\User;
use App\Services\Auth;
use App\Services\Cache;
use App\Services\Captcha;
use App\Services\Mail;
use App\Services\MFA;
use App\Services\RateLimit;
use App\Utils\Cookie;
use App\Utils\Hash;
use App\Utils\ResponseHelper;
use App\Utils\Tools;
use Exception;
use GuzzleHttp\Exception\GuzzleException;
use Psr\Http\Client\ClientExceptionInterface;
use Psr\Http\Message\ResponseInterface;
use Ramsey\Uuid\Uuid;
use RedisException;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Telegram\Bot\Exceptions\TelegramSDKException;
use voku\helper\AntiXSS;
use function array_rand;
use function date;
use function explode;
use function strlen;
use function strtolower;
use function time;
use function trim;

final class AuthController extends BaseController
{
    /**
     * @throws Exception
     */
    public function login(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $captcha = [];

        if (Config::obtain('enable_login_captcha')) {
            $captcha = Captcha::generate();
        }

        return $response->write($this->view()
            ->assign('base_url', $_ENV['baseUrl'])
            ->assign('captcha', $captcha)
            ->fetch('auth/login.tpl'));
    }

    /**
     * @throws ClientExceptionInterface
     * @throws GuzzleException
     * @throws TelegramSDKException
     */
    public function loginHandle(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        if (Config::obtain('enable_login_captcha') && ! Captcha::verify($request->getParams())) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'سیستم نمی‌تواند نتیجه تأیید شما را بپذیرد، لطفاً صفحه را بازخوانی کنید و دوباره امتحان کنید.',
            ]);
        }

        $antiXss = new AntiXSS();
        $code = $antiXss->xss_clean($request->getParam('code'));
        $passwd = $request->getParam('passwd');
        $rememberMe = $request->getParam('remember_me') === 'true' ? 1 : 0;
        $email = strtolower(trim($antiXss->xss_clean($request->getParam('email'))));
        $redir = Cookie::get('redir') === '' ? $antiXss->xss_clean(Cookie::get('redir')) : '/user';
        $user = User::where('email', $email)->first();
        $loginIp = new LoginIp();

        if ($user === null) {
            $loginIp->collectLoginIP($_SERVER['REMOTE_ADDR'], 1);

            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطای ایمیل یا رمز عبور',
            ]);
        }

        if (! Hash::checkPassword($user->pass, $passwd)) {
            $loginIp->collectLoginIP($_SERVER['REMOTE_ADDR'], 1, $user->id);

            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطای ایمیل یا رمز عبور',
            ]);
        }

        if ($user->ga_enable && (strlen($code) !== 6 || ! MFA::verifyGa($user, $code))) {
            $loginIp->collectLoginIP($_SERVER['REMOTE_ADDR'], 1, $user->id);

            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطای کد تایید دو مرحله ای',
            ]);
        }

        $time = 3600;

        if ($rememberMe) {
            $time = 86400 * ($_ENV['rememberMeDuration'] ?: 7);
        }

        Auth::login($user->id, $time);
        // 记录登录成功
        $loginIp->collectLoginIP($_SERVER['REMOTE_ADDR'], 0, $user->id);
        $user->last_login_time = time();
        $user->save();

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

        if (Config::obtain('enable_reg_captcha')) {
            $captcha = Captcha::generate();
        }

        $antiXss = new AntiXSS();
        $code = $antiXss->xss_clean($request->getParam('code'));

        return $response->write(
            $this->view()
                ->assign('code', $code)
                ->assign('base_url', $_ENV['baseUrl'])
                ->assign('captcha', $captcha)
                ->fetch('auth/register.tpl')
        );
    }

    /**
     * @throws RedisException
     */
    public function sendVerify(ServerRequest $request, Response $response, $next): Response|ResponseInterface
    {
        if (Config::obtain('reg_email_verify')) {
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

            if (! RateLimit::checkEmailIpLimit($request->getServerParam('REMOTE_ADDR')) ||
                ! RateLimit::checkEmailAddressLimit($email)
            ) {
                return ResponseHelper::error($response, 'درخواست شما خیلی زیاد است، لطفاً بعداً دوباره امتحان کنید');
            }

            $user = User::where('email', $email)->first();

            if ($user !== null) {
                return ResponseHelper::error($response, 'این ایمیل قبلا ذخیره شده است');
            }

            $code = Tools::genRandomChar(6);
            $redis = Cache::initRedis();
            $redis->setex('email_verify:' . $code, Config::obtain('email_verify_code_ttl'), $email);

            try {
                Mail::send(
                    $email,
                    $_ENV['appName'] . '- ایمیل تایید',
                    'verify_code.tpl',
                    [
                        'code' => $code,
                        'expire' => date('Y-m-d H:i:s', time() + Config::obtain('email_verify_code_ttl')),
                    ]
                );
            } catch (Exception|ClientExceptionInterface $e) {
                return ResponseHelper::error($response, 'ایمیل ارسال نشد، لطفا با مدیر سایت تماس بگیرید.');
            }

            return ResponseHelper::success($response, 'کد تایید با موفقیت ارسال شد، لطفا ایمیل خود را بررسی کنید.');
        }

        return ResponseHelper::error($response, 'تایید ایمیل برای سایت فعال نیست');
    }

    /**
     * @param Response $response
     * @param $name
     * @param $email
     * @param $passwd
     * @param $code
     * @param $imtype
     * @param $imvalue
     * @param $money
     * @param $is_admin_reg
     *
     * @return ResponseInterface
     *
     * @throws ClientExceptionInterface
     * @throws GuzzleException
     * @throws TelegramSDKException
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
        $money,
        $is_admin_reg
    ): ResponseInterface {
        $redir = Cookie::get('redir') ?? '/user';
        $configs = Config::getClass('reg');
        // do reg user
        $user = new User();

        $user->user_name = $name;
        $user->email = $email;
        $user->remark = '';
        $user->pass = Hash::passwordHash($passwd);
        $user->passwd = Tools::genRandomChar(16);
        $user->uuid = Uuid::uuid4();
        $user->api_token = Uuid::uuid4();
        $user->port = Tools::getSsPort();
        $user->u = 0;
        $user->d = 0;
        $user->method = $configs['sign_up_for_method'];
        $user->forbidden_ip = Config::obtain('reg_forbidden_ip');
        $user->forbidden_port = Config::obtain('reg_forbidden_port');
        $user->im_type = $imtype;
        $user->im_value = $imvalue;
        $user->transfer_enable = Tools::toGB($configs['sign_up_for_free_traffic']);
        $user->invite_num = $configs['sign_up_for_invitation_codes'];
        $user->auto_reset_day = Config::obtain('free_user_reset_day');
        $user->auto_reset_bandwidth = Config::obtain('free_user_reset_bandwidth');
        $user->daily_mail_enable = $configs['sign_up_for_daily_report'];

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
            $user->money = Config::obtain('invitation_to_register_balance_reward');
        }

        $user->ga_token = MFA::generateGaToken();
        $user->ga_enable = 0;
        $user->class_expire = date('Y-m-d H:i:s', time() + (int) $configs['sign_up_for_class_time'] * 86400);
        $user->class = $configs['sign_up_for_class'];
        $user->node_iplimit = $configs['connection_ip_limit'];
        $user->node_speedlimit = $configs['connection_rate_limit'];
        $user->reg_date = date('Y-m-d H:i:s');
        $user->reg_ip = $_SERVER['REMOTE_ADDR'];
        $user->theme = $_ENV['theme'];
        $user->locale = $_ENV['locale'];
        $random_group = Config::obtain('random_group');

        if ($random_group === '') {
            $user->node_group = 0;
        } else {
            $user->node_group = $random_group[array_rand(explode(',', $random_group))];
        }

        if ($user->save() && ! $is_admin_reg) {
            Auth::login($user->id, 3600);
            (new LoginIp())->collectLoginIP($_SERVER['REMOTE_ADDR'], 0, $user->id);

            return $response->withJson([
                'ret' => 1,
                'msg' => 'موفقیت در ثبت نام!انتقال به صفحه ورود',
                'redir' => $redir,
            ]);
        }

        return ResponseHelper::error($response, 'اشتباه ناشناخته');
    }

    /**
     * @param ServerRequest $request
     * @param Response $response
     * @param array $args
     *
     * @return Response|ResponseInterface
     *
     * @throws ClientExceptionInterface
     * @throws GuzzleException
     * @throws RedisException
     * @throws TelegramSDKException
     */
    public function registerHandle(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        if (Config::obtain('reg_mode') === 'close') {
            return ResponseHelper::error($response, 'ثبت نام باز نیست');
        }

        if (Config::obtain('enable_reg_captcha') && ! Captcha::verify($request->getParams())) {
            return ResponseHelper::error($response, 'سیستم نمی‌تواند نتیجه تأیید شما را بپذیرد، لطفاً صفحه را بازخوانی کنید و دوباره امتحان کنید.');
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
            return ResponseHelper::error($response, 'لطفاً با شرایط خدمات موافقت کنید');
        }
        // Check Invite Code
        if ($code === '' && Config::obtain('reg_mode') === 'invite') {
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

        $imtype = 0;
        $imvalue = '';

        // check email format
        $check_res = Tools::isEmailLegal($email);

        if ($check_res['ret'] === 0) {
            return $response->withJson($check_res);
        }
        // check email
        $user = User::where('email', $email)->first();

        if ($user !== null) {
            return ResponseHelper::error($response, 'ایمیل ثبت شده است');
        }
        // check pwd length
        if (strlen($passwd) < 8) {
            return ResponseHelper::error($response, 'رمز عبور لطفا بزرگتر از 8 کاراکتر باشد');
        }
        // check pwd re
        if ($passwd !== $repasswd) {
            return ResponseHelper::error($response, 'دو کلمه عبور وارد شده مطابقت ندارند');
        }

        if (Config::obtain('reg_email_verify')) {
            $redis = Cache::initRedis();
            $email_verify_code = trim($antiXss->xss_clean($request->getParam('emailcode')));
            $email_verify = $redis->get('email_verify:' . $email_verify_code);

            if (! $email_verify) {
                return ResponseHelper::error($response, 'کد تأیید ایمیل شما نادرست است');
            }

            $redis->del('email_verify:' . $email_verify_code);
        }

        return $this->registerHelper($response, $name, $email, $passwd, $code, $imtype, $imvalue, 0, 0);
    }

    public function logout(ServerRequest $request, Response $response, $next): Response
    {
        Auth::logout();

        return $response->withStatus(302)
            ->withHeader('Location', '/auth/login');
    }
}

<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Models\Config;
use App\Models\InviteCode;
use App\Models\LoginIp;
use App\Models\User;
use App\Services\Auth;
use App\Services\Bot\Telegram\Message;
use App\Services\Cache;
use App\Services\Captcha;
use App\Services\Filter;
use App\Services\Mail;
use App\Services\MFA;
use App\Services\RateLimit;
use App\Services\Reward;
use App\Utils\Cookie;
use App\Utils\Hash;
use App\Utils\ResponseHelper;
use App\Utils\Tools;
use Exception;
use Psr\Http\Client\ClientExceptionInterface;
use Psr\Http\Message\ResponseInterface;
use Ramsey\Uuid\Uuid;
use RedisException;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function array_rand;
use function date;
use function explode;
use function strlen;
use function strtolower;
use function time;
use function trim;
use Telegram\Bot\Api;

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

    public function loginHandle(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        if (Config::obtain('enable_login_captcha') && !Captcha::verify($request->getParams())) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'سیستم نمی‌تواند نتیجه تأیید شما را بپذیرد، لطفاً صفحه را بازخوانی کنید و دوباره امتحان کنید.',
            ]);
        }
        $tu = $request->getParam('tu');
        $mfa_code = $this->antiXss->xss_clean($request->getParam('mfa_code'));
        $password = $request->getParam('password');
        $rememberMe = $request->getParam('remember_me') === 'true' ? 1 : 0;
        $email = strtolower(trim($this->antiXss->xss_clean($request->getParam('email'))));
        $redir = $this->antiXss->xss_clean(Cookie::get('redir')) ?? '/user';
        $user = (new User())->where('email', $email)->first();
        $loginIp = new LoginIp();

        if ($user === null) {
            $loginIp->collectLoginIP($_SERVER['REMOTE_ADDR'], 1);

            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطای ایمیل یا رمز عبور',
            ]);
        }

        if (!Hash::checkPassword($user->pass, $password)) {
            $loginIp->collectLoginIP($_SERVER['REMOTE_ADDR'], 1, $user->id);

            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطای ایمیل یا رمز عبور',
            ]);
        }

        if ($user->ga_enable && (strlen($mfa_code) !== 6 || !MFA::verifyGa($user, $mfa_code))) {
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
        $t = null;
        if ($tu) {
            $user->im_type = 4;
            $t = json_decode($tu);
            $user->im_value = $t->user->id;
        }
        $user->save();
        if ($t) {
            $responseMessage = [
                'type' => 'article',
                'id' => 'unique-id',
                'title' => 'Square Calculation Result',
                'input_message_content' => [
                    'message_text' => '/start'
                ]
            ];


            $requestBody = [
                'web_app_query_id' => $t->webAppQueryId,
                'result' => $responseMessage
            ];
            Message::sendPost('answerWebAppQuery', $requestBody);

            return ResponseHelper::success($response, "");
        }
        return $response->withHeader('HX-Redirect', $redir)->withJson([
            'ret' => 1,
            'msg' => 'ورود با موفقیت',
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

        $invite_code = $this->antiXss->xss_clean($request->getParam('code'));

        return $response->write(
            $this->view()
                ->assign('invite_code', $invite_code)
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
            $email = strtolower(trim($this->antiXss->xss_clean($request->getParam('email'))));

            if ($email === '') {
                return ResponseHelper::error($response, 'آدرس ایمیل پر نشده است');
            }

            // check email format
            $email_check = Filter::checkEmailFilter($email);

            if (!$email_check) {
                return ResponseHelper::error($response, 'ایمیل نامعتبر');
            }

            if (
                !RateLimit::checkEmailIpLimit($request->getServerParam('REMOTE_ADDR')) ||
                !RateLimit::checkEmailAddressLimit($email)
            ) {
                return ResponseHelper::error($response, 'درخواست شما خیلی زیاد است، لطفاً بعداً دوباره امتحان کنید');
            }

            $user = (new User())->where('email', $email)->first();

            if ($user !== null) {
                return ResponseHelper::error($response, 'این ایمیل قبلا ذخیره شده است');
            }

            $email_code = Tools::genRandomChar(6);
            $redis = (new Cache())->initRedis();
            $redis->setex('email_verify:' . $email_code, Config::obtain('email_verify_code_ttl'), $email);

            try {
                Mail::send(
                    $email,
                    $_ENV['appName'] . '- ایمیل تایید',
                    'verify_code.tpl',
                    [
                        'code' => $email_code,
                        'expire' => date('Y-m-d H:i:s', time() + Config::obtain('email_verify_code_ttl')),
                    ]
                );
            } catch (Exception | ClientExceptionInterface $e) {
                return ResponseHelper::error($response, 'ایمیل ارسال نشد، لطفا با مدیر سایت تماس بگیرید.');
            }

            return ResponseHelper::success($response, 'کد تایید با موفقیت ارسال شد، لطفا ایمیل خود را بررسی کنید. در نظر داشته باشید در صورت  نبود ایمیل در صندق ورودی تان، پوشه  span را نیز برسی کنید.');
        }

        return ResponseHelper::error($response, 'تایید ایمیل برای سایت فعال نیست');
    }

    /**
     * @throws Exception
     */
    public function registerHelper(
        Response $response,
        $name,
        $email,
        $password,
        $invite_code,
        $imtype,
        $imvalue,
        $money,
        $is_admin_reg,
        $t
    ): ResponseInterface {
        $redir = $this->antiXss->xss_clean(Cookie::get('redir')) ?? '/user';
        $configs = Config::getClass('reg');
        // do reg user
        $user = new User();

        $user->user_name = $name;
        $user->email = $email;
        $user->remark = '';
        $user->pass = Hash::passwordHash($password);
        $user->passwd = Tools::genRandomChar(16);
        $user->uuid = Uuid::uuid4();
        $user->api_token = Tools::genRandomChar(32);
        $user->port = Tools::getSsPort();
        $user->u = 0;
        $user->d = 0;
        $user->method = $configs['reg_method'];
        $user->im_type = $imtype;
        $user->im_value = $imvalue;
        $user->transfer_enable = Tools::toGB($configs['reg_traffic']);
        $user->auto_reset_day = Config::obtain('free_user_reset_day');
        $user->auto_reset_bandwidth = Config::obtain('free_user_reset_bandwidth');
        $user->daily_mail_enable = $configs['reg_daily_report'];

        if ($money > 0) {
            $user->money = $money;
        } else {
            $user->money = 0;
        }

        $user->ref_by = 0;

        if ($invite_code !== '') {
            $invite = (new InviteCode())->where('code', $invite_code)->first();

            if ($invite !== null) {
                $user->ref_by = $invite->user_id;
            }
        }

        $user->ga_token = MFA::generateGaToken();
        $user->ga_enable = 0;
        $user->class = $configs['reg_class'];
        $user->class_expire = date('Y-m-d H:i:s', time() + (int) $configs['reg_class_time'] * 86400);
        $user->node_iplimit = $configs['reg_ip_limit'];
        $user->node_speedlimit = $configs['reg_speed_limit'];
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

        if ($user->save() && !$is_admin_reg) {
            if ($user->ref_by !== 0) {
                Reward::issueRegReward($user->id, $user->ref_by);
            }

            Auth::login($user->id, 3600);
            (new LoginIp())->collectLoginIP($_SERVER['REMOTE_ADDR'], 0, $user->id);

            if ($t) {
                $responseMessage = [
                    'type' => 'article',
                    'id' => 'unique-id',
                    'title' => 'Square Calculation Result',
                    'input_message_content' => [
                        'message_text' => '/start'
                    ]
                ];


                $requestBody = [
                    'web_app_query_id' => $t->webAppQueryId,
                    'result' => $responseMessage
                ];
                Message::sendPost('answerWebAppQuery', $requestBody);

                return ResponseHelper::success($response, "");
            }
            return $response->withHeader('HX-Redirect', $redir)->withJson([
                'ret' => 1,
                'msg' => 'ثبت نام موفق!انتقال به صفحه ورود',
            ]);
        }

        return ResponseHelper::error($response, 'اشتباه ناشناخته');
    }

    /**
     * @throws RedisException
     * @throws Exception
     */
    public function registerHandle(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        if (Config::obtain('reg_mode') === 'close') {
            return ResponseHelper::error($response, 'ثبت نام باز نیست');
        }

        if (Config::obtain('enable_reg_captcha') && !Captcha::verify($request->getParams())) {
            return ResponseHelper::error($response, 'سیستم نمی‌تواند نتیجه تأیید شما را بپذیرد، لطفاً صفحه را بازخوانی کنید و دوباره امتحان کنید.');
        }

        $tos = $request->getParam('tos') === 'true' ? 1 : 0;
        $email = strtolower(trim($this->antiXss->xss_clean($request->getParam('email'))));
        $name = $this->antiXss->xss_clean($request->getParam('name'));
        $password = $request->getParam('password');
        $confirm_password = $request->getParam('confirm_password');
        $invite_code = $this->antiXss->xss_clean(trim($request->getParam('invite_code')));
        $tu = $request->getParam('tu');

        if (!$tos) {
            return ResponseHelper::error($response, 'لطفاً با شرایط خدمات موافقت کنید');
        }

        if (strlen($password) < 8) {
            return ResponseHelper::error($response, 'رمز عبور باید بیشتر از 8 کاراکتر باشد');
        }

        if ($password !== $confirm_password) {
            return ResponseHelper::error($response, 'دو ورودی رمز با هم مطابقت ندارند');
        }

        if ($invite_code === '' && Config::obtain('reg_mode') === 'invite') {
            return ResponseHelper::error($response, 'کد دعوت نمی تواند خالی باشد');
        }

        if ($invite_code !== '') {
            $invite = (new InviteCode())->where('code', $invite_code)->first();

            if ($invite === null) {
                return ResponseHelper::error($response, 'کد دعوت نامعتبر است');
            }

            $ref_user = (new User())->where('id', $invite->user_id)->first();

            if ($ref_user === null) {
                return ResponseHelper::error($response, 'کد دعوت نامعتبر است');
            }
        }

        $imtype = 0;
        $imvalue = '';
        $t = null;
        if ($tu) {
            $imtype = 4;
            $t = json_decode($tu);
            $imvalue = $t->user->id;
        }

        // check email format
        $email_check = Filter::checkEmailFilter($email);

        if (!$email_check) {
            return ResponseHelper::error($response, 'ایمیل نامعتبر');
        }
        // check email
        $user = (new User())->where('email', $email)->first();

        if ($user !== null) {
            return ResponseHelper::error($response, 'ایمیل ثبت شده است');
        }

        if (Config::obtain('reg_email_verify')) {
            $redis = (new Cache())->initRedis();
            $email_verify_code = trim($this->antiXss->xss_clean($request->getParam('emailcode')));
            $email_verify = $redis->get('email_verify:' . $email_verify_code);

            if (!$email_verify) {
                return ResponseHelper::error($response, 'کد تأیید ایمیل شما نادرست است');
            }

            $redis->del('email_verify:' . $email_verify_code);
        }

        return $this->registerHelper($response, $name, $email, $password, $invite_code, $imtype, $imvalue, 0, 0, $t);
    }

    public function logout(ServerRequest $request, Response $response, $next): Response
    {
        Auth::logout();

        return $response->withStatus(302)
            ->withHeader('Location', '/auth/login');
    }
}

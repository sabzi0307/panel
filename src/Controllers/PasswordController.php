<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Models\Config;
use App\Models\User;
use App\Services\Cache;
use App\Services\Captcha;
use App\Services\Password;
use App\Services\RateLimit;
use App\Utils\Hash;
use App\Utils\ResponseHelper;
use Exception;
use Psr\Http\Client\ClientExceptionInterface;
use Psr\Http\Message\ResponseInterface;
use RedisException;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use voku\helper\AntiXSS;
use function strlen;

final class PasswordController extends BaseController
{
    /**
     * @throws Exception
     */
    public function reset(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $captcha = [];

        if (Config::obtain('enable_reset_password_captcha')) {
            $captcha = Captcha::generate();
        }

        return $response->write(
            $this->view()
                ->assign('captcha', $captcha)
                ->fetch('password/reset.tpl')
        );
    }

    /**
     * @throws RedisException
     */
    public function handleReset(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        if (Config::obtain('enable_reset_password_captcha')) {
            $ret = Captcha::verify($request->getParams());

            if (! $ret) {
                return ResponseHelper::error($response, 'سیستم نمی‌تواند نتیجه تأیید شما را بپذیرد، لطفاً صفحه را بازخوانی کنید و دوباره امتحان کنید');
            }
        }

        $antiXss = new AntiXSS();
        $email = strtolower($antiXss->xss_clean($request->getParam('email')));

        if ($email === '') {
            return ResponseHelper::error($response, 'آدرس ایمیل پر نشده است');
        }

        if (! RateLimit::checkEmailIpLimit($request->getServerParam('REMOTE_ADDR')) ||
            ! RateLimit::checkEmailAddressLimit($email)
        ) {
            return ResponseHelper::error($response, 'درخواست شما خیلی زیاد است، لطفاً بعداً دوباره امتحان کنید');
        }

        $user = User::where('email', $email)->first();
        $msg = 'اگر حساب شما در پایگاه داده ما وجود داشته باشد، پیوندی برای بازنشانی رمز عبور شما به آدرس ایمیل مربوط به حساب شما ارسال می شود.';

        if ($user !== null) {
            try {
                Password::sendResetEmail($email);
            } catch (ClientExceptionInterface|RedisException $e) {
                $msg = 'ایمیل ارسال نشد، لطفا با مدیر سایت تماس بگیرید.';
            }
        }

        return ResponseHelper::success($response, $msg);
    }

    /**
     * @throws Exception
     */
    public function token(ServerRequest $request, Response $response, array $args)
    {
        $antiXss = new AntiXSS();
        $token = $antiXss->xss_clean($args['token']);
        $redis = Cache::initRedis();
        $email = $redis->get('password_reset:' . $token);

        if (! $email) {
            return $response->withStatus(302)->withHeader('Location', '/password/reset');
        }

        return $response->write(
            $this->view()->fetch('password/token.tpl')
        );
    }

    /**
     * @throws RedisException
     */
    public function handleToken(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $antiXss = new AntiXSS();
        $token = $antiXss->xss_clean($args['token']);
        $password = $request->getParam('password');
        $repasswd = $request->getParam('repasswd');

        if ($password !== $repasswd) {
            return ResponseHelper::error($response, 'این دو ورودی مطابقت ندارند');
        }

        if (strlen($password) < 8) {
            return ResponseHelper::error($response, 'رمز عبور خیلی کوتاه است');
        }

        $redis = Cache::initRedis();
        $email = $redis->get('password_reset:' . $token);

        if (! $email) {
            return ResponseHelper::error($response, 'لینک نامعتبر');
        }

        $user = User::where('email', $email)->first();

        if ($user === null) {
            return ResponseHelper::error($response, 'لینک منقضی شده است، لطفا دوباره امتحان کنید');
        }

        // reset password
        $hashPassword = Hash::passwordHash($password);
        $user->pass = $hashPassword;

        if (! $user->save()) {
            return ResponseHelper::error($response, 'بازنشانی انجام نشد، لطفاً دوباره امتحان کنید');
        }

        if (Config::obtain('enable_forced_replacement')) {
            $user->cleanLink();
        }

        $redis->del('password_reset:' . $token);

        return ResponseHelper::successfully($response, 'بازنشانی با موفقیت انجام شد');
    }
}

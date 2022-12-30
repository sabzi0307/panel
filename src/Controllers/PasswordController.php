<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Models\PasswordReset;
use App\Models\Setting;
use App\Models\User;
use App\Services\Captcha;
use App\Services\Password;
use App\Utils\Hash;
use App\Utils\ResponseHelper;
use Slim\Http\Request;
use Slim\Http\Response;

/*
 * Class Password
 *
 * @package App\Controllers
 * 密码重置
 */
final class PasswordController extends BaseController
{
    /**
     * @param array     $args
     */
    public function reset(Request $request, Response $response, array $args)
    {
        $captcha = [];

        if (Setting::obtain('enable_reset_password_captcha') === true) {
            $captcha = Captcha::generate();
        }

        return $response->write(
            $this->view()
                ->assign('captcha', $captcha)
                ->display('password/reset.tpl')
        );
    }

    /**
     * @param array     $args
     */
    public function handleReset(Request $request, Response $response, array $args)
    {
        if (Setting::obtain('enable_reset_password_captcha') === true) {
            $ret = Captcha::verify($request->getParams());
            if (! $ret) {
                return ResponseHelper::error($response, 'سیستم نمی‌تواند نتیجه تأیید شما را بپذیرد، لطفاً صفحه را بازخوانی کنید و دوباره امتحان کنید');
            }
        }

        $email = strtolower($request->getParam('email'));
        $user = User::where('email', $email)->first();

        if ($user === null) {
            $msg = 'اگر حساب شما در پایگاه داده ما وجود داشته باشد، پیوندی برای بازنشانی رمز عبور شما به آدرس ایمیل مربوط به حساب شما ارسال می شود.';
        }

        if (Password::sendResetEmail($email)) {
            $msg = 'اگر حساب شما در پایگاه داده ما وجود داشته باشد، پیوندی برای بازنشانی رمز عبور شما به آدرس ایمیل مربوط به حساب شما ارسال می شود.';
        } else {
            $msg = 'ایمیل ارسال نشد، لطفا با مدیر سایت تماس بگیرید.';
        }

        return ResponseHelper::successfully($response, $msg);
    }

    /**
     * @param array     $args
     */
    public function token(Request $request, Response $response, array $args)
    {
        $token = PasswordReset::where('token', $args['token'])->where('expire_time', '>', \time())->orderBy('id', 'desc')->first();
        if ($token === null) {
            return $response->withStatus(302)->withHeader('Location', '/password/reset');
        }

        return $response->write(
            $this->view()->display('password/token.tpl')
        );
    }

    /**
     * @param array     $args
     */
    public function handleToken(Request $request, Response $response, array $args)
    {
        $tokenStr = $args['token'];
        $password = $request->getParam('password');
        $repasswd = $request->getParam('repasswd');

        if ($password !== $repasswd) {
            return ResponseHelper::error($response, 'این دو ورودی مطابقت ندارند');
        }

        if (strlen($password) < 8) {
            return ResponseHelper::error($response, 'رمز عبور خیلی کوتاه است');
        }

        /** @var PasswordReset $token */
        $token = PasswordReset::where('token', $tokenStr)->where('expire_time', '>', \time())->orderBy('id', 'desc')->first();
        if ($token === null) {
            return ResponseHelper::error($response, 'لینک منقضی شده است، لطفا دوباره امتحان کنید');
        }

        $user = $token->getUser();
        if ($user === null) {
            return ResponseHelper::error($response, 'لینک منقضی شده است، لطفا دوباره امتحان کنید');
        }

        // reset password
        $hashPassword = Hash::passwordHash($password);
        $user->pass = $hashPassword;
        $user->ga_enable = 0;

        if (! $user->save()) {
            return ResponseHelper::error($response, 'بازنشانی انجام نشد، لطفاً دوباره امتحان کنید');
        }

        if ($_ENV['enable_forced_replacement'] === true) {
            $user->cleanLink();
        }

        // 禁止链接多次使用
        $token->expire_time = \time();
        $token->save();

        return ResponseHelper::successfully($response, 'بازنشانی با موفقیت انجام شد');
    }
}

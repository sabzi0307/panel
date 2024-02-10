<?php

declare(strict_types=1);

namespace App\Controllers\User;

use App\Controllers\BaseController;
use App\Models\Config;
use App\Models\InviteCode;
use App\Models\User;
use App\Services\Auth;
use App\Services\Cache;
use App\Services\MFA;
use App\Utils\Hash;
use App\Utils\ResponseHelper;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Ramsey\Uuid\Uuid;
use RedisException;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function in_array;
use function strlen;
use function strtolower;
use const BASE_PATH;

final class InfoController extends BaseController
{
    /**
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $themes = Tools::getDir(BASE_PATH . '/resources/views');
        $methods = Tools::getSsMethod('method');
        $ga_url = MFA::getGaUrl($this->user);

        return $response->write($this->view()
            ->assign('user', $this->user)
            ->assign('themes', $themes)
            ->assign('methods', $methods)
            ->assign('ga_url', $ga_url)
            ->fetch('user/edit.tpl'));
    }

    /**
     * @throws RedisException
     */
    public function updateEmail(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $new_email = $this->antiXss->xss_clean($request->getParam('newemail'));
        $user = $this->user;
        $old_email = $user->email;

        if (! $_ENV['enable_change_email'] || $user->is_shadow_banned) {
            return ResponseHelper::error($response, 'موفق به ویرایش نشد');
        }

        if ($new_email === '') {
            return ResponseHelper::error($response, 'آدرس ایمیل پر نشده است');
        }

        $check_res = Tools::isEmailLegal($new_email);

        if ($check_res['ret'] !== 1) {
            return $response->withJson($check_res);
        }

        $exist_user = (new User())->where('email', $new_email)->first();

        if ($exist_user !== null) {
            return ResponseHelper::error($response, 'ایمیل از قبل در حال استفاده است');
        }

        if ($new_email === $old_email) {
            return ResponseHelper::error($response, 'صندوق پستی جدید نمی تواند با صندوق پستی قدیمی یکسان باشد');
        }

        if (Config::obtain('reg_email_verify')) {
            $redis = (new Cache())->initRedis();
            $email_verify_code = $request->getParam('emailcode');
            $email_verify = $redis->get('email_verify:' . $email_verify_code);

            if (! $email_verify) {
                return ResponseHelper::error($response, 'کد تأیید ایمیل شما نادرست است');
            }

            $redis->del('email_verify:' . $email_verify_code);
        }

        $user->email = $new_email;

        if (! $user->save()) {
            return ResponseHelper::error($response, 'موفق به ویرایش نشد');
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت اصلاح شد',
            'data' => [
                'email' => $user->email,
            ],
        ]);
    }

    public function updateUsername(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $newusername = $this->antiXss->xss_clean($request->getParam('newusername'));
        $user = $this->user;

        if ($user->is_shadow_banned) {
            return ResponseHelper::error($response, 'موفق به ویرایش نشد');
        }

        $user->user_name = $newusername;

        if (! $user->save()) {
            return ResponseHelper::error($response, 'موفق به ویرایش نشد');
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت اصلاح شد',
            'data' => [
                'username' => $user->user_name,
            ],
        ]);
    }

    public function unbindIM(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $user = $this->user;

        if (! $user->unbindIM()) {
            return ResponseHelper::error($response, 'باز کردن پیوند انجام نشد');
        }

        return $response->withHeader('HX-Refresh', 'true')->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت بازگشایی شد',
        ]);
    }

    public function updatePassword(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $oldpwd = $request->getParam('oldpwd');
        $pwd = $request->getParam('pwd');
        $repwd = $request->getParam('repwd');
        $user = $this->user;

        if ($oldpwd === '' || $pwd === '' || $repwd === '') {
            return ResponseHelper::error($response, 'رمز عبور نمی تواند خالی باشد');
        }

        if (! Hash::checkPassword($user->pass, $oldpwd)) {
            return ResponseHelper::error($response, 'خطای رمز قدیمی');
        }

        if ($pwd !== $repwd) {
            return ResponseHelper::error($response, 'این دو ورودی مطابقت ندارند');
        }

        if (strlen($pwd) < 8) {
            return ResponseHelper::error($response, 'رمز عبور خیلی کوتاه است');
        }

        if (! $user->updatePassword($pwd)) {
            return ResponseHelper::error($response, 'موفق به ویرایش نشد');
        }

        if (Config::obtain('enable_forced_replacement')) {
            $user->cleanLink();
        }

        return ResponseHelper::success($response, 'با موفقیت اصلاح شد');
    }

    public function resetPasswd(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $user = $this->user;
        $user->passwd = Tools::genRandomChar(16);
        $user->uuid = Uuid::uuid4();

        if (! $user->save()) {
            return ResponseHelper::error($response, 'بازنشانی انجام نشد');
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'بازنشانی با موفقیت انجام شد',
            'data' => [
                'passwd' => $user->passwd,
                'uuid' => $user->uuid,
            ],
        ]);
    }

    public function resetApiToken(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $user = $this->user;
        $user->api_token = Uuid::uuid4();

        if (! $user->save()) {
            return ResponseHelper::error($response, 'بازنشانی انجام نشد');
        }

        return ResponseHelper::success($response, 'بازنشانی با موفقیت انجام شد');
    }

    public function updateMethod(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $user = $this->user;
        $method = strtolower($this->antiXss->xss_clean($request->getParam('method')));

        if ($method === '') {
            ResponseHelper::error($response, 'ورود غیرقانونی');
        }
        if (! Tools::isParamValidate('method', $method)) {
            ResponseHelper::error($response, 'رمزگذاری نامعتبر است');
        }

        $user->method = $method;

        if (! $user->save()) {
            return ResponseHelper::error($response, 'موفق به ویرایش نشد');
        }

        return ResponseHelper::success($response, 'با موفقیت اصلاح شد');
    }

    public function resetURL(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $user = $this->user;
        $user->cleanLink();

        return ResponseHelper::success($response, 'بازنشانی با موفقیت انجام شد');
    }

    public function resetInviteURL(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $user = $this->user;
        $user->clearInviteCodes();
        $code = (new InviteCode())->add($user->id);

        return $response->withJson([
            'ret' => 1,
            'msg' => 'بازنشانی با موفقیت انجام شد',
            'data' => [
                'invite-url' => $_ENV['baseUrl'] . '/auth/register?code=' . $code,
            ],
        ]);
    }

    public function updateDailyMail(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $value = (int) $request->getParam('mail');

        if (! in_array($value, [0, 1, 2])) {
            return ResponseHelper::error($response, 'خطای پارامتر');
        }

        $user = $this->user;
        $user->daily_mail_enable = $value;

        if (! $user->save()) {
            return ResponseHelper::error($response, 'موفق به ویرایش نشد');
        }

        return ResponseHelper::success($response, 'با موفقیت اصلاح شد');
    }

    public function updateContactMethod(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $value = (int) $request->getParam('contact');

        if (! in_array($value, [1, 2])) {
            return ResponseHelper::error($response, 'خطای پارامتر');
        }

        $user = $this->user;
        $user->contact_method = $value;

        if (! $user->save()) {
            return ResponseHelper::error($response, 'موفق به ویرایش نشد');
        }

        return ResponseHelper::success($response, 'با موفقیت اصلاح شد');
    }

    public function updateTheme(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $theme = $this->antiXss->xss_clean($request->getParam('theme'));
        $user = $this->user;

        if ($theme === '') {
            return ResponseHelper::error($response, 'موضوع نمی‌تواند خالی باشد');
        }

        $user->theme = $theme;

        if (! $user->save()) {
            return ResponseHelper::error($response, 'موفق به ویرایش نشد');
        }

        return $response->withHeader('HX-Refresh', 'true')->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت اصلاح شد',
        ]);
    }

    public function sendToGulag(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $user = $this->user;
        $passwd = $request->getParam('passwd');

        if ($passwd === '') {
            return ResponseHelper::error($response, 'رمز عبور نمی تواند خالی باشد');
        }

        if (! Hash::checkPassword($user->pass, $passwd)) {
            return ResponseHelper::error($response, 'رمز عبور اشتباه');
        }

        if ($_ENV['enable_kill']) {
            Auth::logout();
            $user->kill();

            return $response->withHeader('HX-Refresh', 'true')->withJson([
                'ret' => 1,
                'msg' => 'حساب شما برای اصلاحات کار به گولاگ فرستاده شد، خداحافظ',
            ]);
        }

        return ResponseHelper::error($response, 'حذف اکانت سلف سرویس فعال نیست');
    }
}

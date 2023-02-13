<?php

declare(strict_types=1);

namespace App\Controllers\User;

use App\Controllers\BaseController;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Vectorface\GoogleAuthenticator;

/**
 *  MFAController
 */
final class MFAController extends BaseController
{
    /**
     * @param array     $args
     */
    public function checkGa(ServerRequest $request, Response $response, array $args)
    {
        $code = $request->getParam('code');
        if ($code === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'کد QR نمی تواند خالی باشد',
            ]);
        }
        $user = $this->user;
        $ga = new GoogleAuthenticator();
        $rcode = $ga->verifyCode($user->ga_token, $code);
        if (! $rcode) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطا در تست',
            ]);
        }
        return $response->withJson([
            'ret' => 1,
            'msg' => 'تست موفق',
        ]);
    }

    /**
     * @param array     $args
     */
    public function setGa(ServerRequest $request, Response $response, array $args)
    {
        $enable = $request->getParam('enable');
        if ($enable === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'گزینه نامعتبر است',
            ]);
        }
        $user = $this->user;
        $user->ga_enable = $enable;
        $user->save();
        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت تنظیم شد',
        ]);
    }

    /**
     * @param array     $args
     */
    public function resetGa(ServerRequest $request, Response $response, array $args)
    {
        $ga = new GoogleAuthenticator();
        $secret = $ga->createSecret();
        $user = $this->user;
        $user->ga_token = $secret;
        if ($user->save()) {
            return $response->withJson([
                'ret' => 1,
                'msg' => 'تنظیم مجدد با موفقیت انجام شد',
            ]);
        }
        return $response->withJson([
            'ret' => 0,
            'msg' => 'تنظیم مجدد انجام نشد',
        ]);
    }
}

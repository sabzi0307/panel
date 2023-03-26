<?php

declare(strict_types=1);

namespace App\Controllers\User;

use App\Controllers\BaseController;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Vectorface\GoogleAuthenticator;

/**
 *  MFAController
 */
final class MFAController extends BaseController
{
    public function checkGa(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
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

    public function setGa(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
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

    public function resetGa(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $ga = new GoogleAuthenticator();
        $secret = '';

        try {
            $secret = $ga->createSecret();
        } catch (Exception $e) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'تنظیم مجدد انجام نشد',
            ]);
        }

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

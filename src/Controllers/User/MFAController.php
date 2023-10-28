<?php

declare(strict_types=1);

namespace App\Controllers\User;

use App\Controllers\BaseController;
use App\Services\MFA;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

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

        if (! MFA::verifyGa($this->user, $code)) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطای تست',
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'موفقیت در تست',
        ]);
    }

    public function setGa(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $enable = $request->getParam('enable');

        if ($enable === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'گزینه نامعتبر',
            ]);
        }

        $user = $this->user;
        $user->ga_enable = $enable;
        $user->save();

        if ($user->save()) {
            return $response->withJson([
                'ret' => 1,
                'msg' => 'با موفقیت تنظیم شد',
            ]);
        }

        return $response->withJson([
            'ret' => 0,
            'msg' => 'راه اندازی ناموفق بود',
        ]);
    }

    /**
     * @throws Exception
     */
    public function resetGa(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $user = $this->user;
        $user->ga_token = MFA::generateGaToken();

        if ($user->save()) {
            return $response->withJson([
                'ret' => 1,
                'msg' => 'بازنشانی با موفقیت انجام شد',
                'data' => [
                    'ga-token' => $user->ga_token,
                    'ga-url' => MFA::getGaUrl($user),
                ],
            ]);
        }

        return $response->withJson([
            'ret' => 0,
            'msg' => 'بازنشانی انجام نشد',
        ]);
    }
}

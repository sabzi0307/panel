<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Models\Config;
use App\Models\Link;
use App\Models\SharedAccount;
use App\Models\SubscribeLog;
use App\Services\RateLimit;
use App\Services\Subscribe;
use App\Utils\ResponseHelper;
use GuzzleHttp\Exception\GuzzleException;
use Psr\Http\Client\ClientExceptionInterface;
use Psr\Http\Message\ResponseInterface;
use RedisException;
use Telegram\Bot\Exceptions\TelegramSDKException;
use function in_array;
use function strtotime;

final class SubController extends BaseController
{
    /**
     * @param $request
     * @param $response
     * @param $args
     *
     * @return ResponseInterface
     *
     * @throws ClientExceptionInterface
     * @throws GuzzleException
     * @throws RedisException
     * @throws TelegramSDKException
     */
    public function index($request, $response, $args): ResponseInterface
    {
        $err_msg = 'پیوند اشتراک نامعتبر است';
        $subtype = $args['subtype'];
        $subtype_list = ['json', 'clash', 'sip008', 'singbox', 'v2rayjson', 'sip002', 'ss', 'v2ray', 'trojan'];

        if (! $_ENV['Subscribe'] ||
            ! in_array($subtype, $subtype_list) ||
            'https://' . $request->getHeaderLine('Host') !== $_ENV['subUrl']
        ) {
            return ResponseHelper::error($response, $err_msg);
        }

        $token = $this->antiXss->xss_clean($args['token']);

        if ($_ENV['enable_rate_limit'] &&
            (! RateLimit::checkIPLimit($request->getServerParam('REMOTE_ADDR')) ||
            ! RateLimit::checkSubLimit($token))
        ) {
            return ResponseHelper::error($response, $err_msg);
        }

        $link = (new Link())->where('token', $token)->first();

        if ($link === null || ! $link->isValid()) {
            return ResponseHelper::error($response, $err_msg);
        }

        $user = $link->user();
        $sub_info = Subscribe::getContent($user, $subtype);

        $content_type = match ($subtype) {
            'clash' => 'application/yaml',
            'json','sip008','singbox', 'v2rayjson' => 'application/json',
            default => 'text/plain',
        };

        $sub_details = ' upload=' . $user->u
        . '; download=' . $user->d
        . '; total=' . $user->transfer_enable
        . '; expire=' . strtotime($user->class_expire);

        if (Config::obtain('subscribe_log')) {
            (new SubscribeLog())->add($user, $subtype, $this->antiXss->xss_clean($request->getHeaderLine('User-Agent')));
        }

        return $response->withHeader('Subscription-Userinfo', $sub_details)
            ->withHeader('Content-Type', $content_type)
            ->write($sub_info);
    }

    public static function getSharedAccounts($user): array
    {
        $results = [];
        $accounts = SharedAccount::where('updated_at', '>', time() - 1200);

        foreach ($accounts as $id) {
            // $id = SharedAccount::where('account', $user_id)
            //     ->where('updated_at', '>', time() - 1200) // 只获取最近一天内上报的数据
            //     ->first();

            if ($id !== null) {
                $info = [];
                $info = [
                    'priority' => $id->priority,
                    'status' => $id->status,
                    'created_at' => $id->created_at,
                    'updated_at' => $id->updated_at,
                    'account' => $id->account,
                    'password' => $id->password,
                ];
                $results[] = $info;
            }
        }

        $node_names = array_column($results, 'updated_at');
        array_multisort($node_names, SORT_ASC, $results);

        // $userid = $user->id;
        // $token = Link::where('userid', $userid)->first();
        return $results;
    }
}

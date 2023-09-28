<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Models\Link;
use App\Models\Setting;
use App\Models\SharedAccount;
use App\Models\SubscribeLog;
use App\Services\DB;
use App\Services\RateLimit;
use App\Services\Subscribe;
use App\Utils\ResponseHelper;
use App\Utils\Tools;
use GuzzleHttp\Exception\GuzzleException;
use Psr\Http\Client\ClientExceptionInterface;
use Psr\Http\Message\ResponseInterface;
use RedisException;
use Telegram\Bot\Exceptions\TelegramSDKException;
use voku\helper\AntiXSS;
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
    public static function getUniversalSubContent($request, $response, $args): ResponseInterface
    {
        $err_msg = 'پیوند اشتراک نامعتبر است';

        $subtype = $args['subtype'];
        $subtype_list = ['json', 'clash', 'sip008', 'singbox'];

        if (! $_ENV['Subscribe'] ||
            ! in_array($subtype, $subtype_list) ||
            'https://' . $request->getHeaderLine('Host') !== $_ENV['subUrl']
        ) {
            return ResponseHelper::error($response, $err_msg);
        }

        $antiXss = new AntiXSS();
        $token = $antiXss->xss_clean($args['token']);

        if ($_ENV['enable_rate_limit'] &&
            (! RateLimit::checkIPLimit($request->getServerParam('REMOTE_ADDR')) ||
            ! RateLimit::checkSubLimit($token))
        ) {
            return ResponseHelper::error($response, $err_msg);
        }

        $link = Link::where('token', $token)->first();

        if ($link === null || ! $link->isValid()) {
            return ResponseHelper::error($response, $err_msg);
        }

        $user = $link->user();
        $sub_info = Subscribe::getContent($user, $subtype);

        $content_type = match ($subtype) {
            'clash' => 'application/yaml',
            default => 'application/json',
        };

        $sub_details = ' upload=' . $user->u
        . '; download=' . $user->d
        . '; total=' . $user->transfer_enable
        . '; expire=' . strtotime($user->class_expire);

        if (Setting::obtain('subscribe_log')) {
            (new SubscribeLog())->add($user, $subtype, $request->getHeaderLine('User-Agent'));
        }

        return $response->withHeader('Subscription-Userinfo', $sub_details)
            ->withHeader('Content-Type', $content_type)
            ->write($sub_info);
    }

    /**
     * @param $request
     * @param $response
     * @param $args
     *
     * @return ResponseInterface
     *
     * @throws RedisException
     * @throws GuzzleException
     * @throws ClientExceptionInterface
     * @throws TelegramSDKException
     */
    public static function getTraditionalSubContent($request, $response, $args): ResponseInterface
    {
        $err_msg = '订阅链接无效';

        if (! $_ENV['Subscribe'] ||
            ! Setting::obtain('enable_traditional_sub') ||
            'https://' . $request->getHeaderLine('Host') !== $_ENV['subUrl']
        ) {
            return ResponseHelper::error($response, $err_msg);
        }

        $antiXss = new AntiXSS();
        $token = $antiXss->xss_clean($args['token']);

        if ($_ENV['enable_rate_limit'] &&
            (! RateLimit::checkIPLimit($request->getServerParam('REMOTE_ADDR')) ||
                ! RateLimit::checkSubLimit($token))
        ) {
            return ResponseHelper::error($response, $err_msg);
        }

        $link = Link::where('token', $token)->first();

        if ($link === null || ! $link->isValid()) {
            return ResponseHelper::error($response, $err_msg);
        }

        $user = $link->user();
        $params = $request->getQueryParams();

        $sub_types = [
            'sip002',
            'ss',
            'v2ray',
            'trojan',
        ];

        $sub_type = '';
        $sub_info = '';

        foreach ($params as $key => $value) {
            if (in_array($key, $sub_types) && $value === '1') {
                $sub_type = $key;
                $sub_info = Subscribe::getContent($user, $sub_type);
                break;
            }
        }

        // 记录订阅日志
        if (Setting::obtain('subscribe_log')) {
            (new SubscribeLog())->add($user, $sub_type, $request->getHeaderLine('User-Agent'));
        }

        $sub_details = ' upload=' . $user->u
            . '; download=' . $user->d
            . '; total=' . $user->transfer_enable
            . '; expire=' . strtotime($user->class_expire);

        return $response->withHeader('Subscription-Userinfo', $sub_details)->write(
            $sub_info
        );
    }

    public static function getUniversalSubLink($user): string
    {
        $userid = $user->id;
        $token = Link::where('userid', $userid)->first();

        if ($token === null) {
            $token = new Link();
            $token->userid = $userid;
            $token->token = Tools::genSubToken();
            $token->save();
        }

        return $_ENV['subUrl'] . '/sub/' . $token->token;
    }

    public static function getTraditionalSubLink($user): string
    {
        $userid = $user->id;
        $token = Link::where('userid', $userid)->first();

        return $_ENV['subUrl'] . '/link/' . $token->token;
    }

    public static function getSharedAccounts($user): array
    {
        $results = [];
        $pdo = DB::getPdo();
        $accounts = $pdo->query('SELECT DISTINCT account FROM shared_account');

        foreach ($accounts as $user_id) {
            $id = SharedAccount::where('account', $user_id)
                ->where('updated_at', '>', time() - 1200) // 只获取最近一天内上报的数据
                ->first();

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

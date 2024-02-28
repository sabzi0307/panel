<?php

declare(strict_types=1);

namespace App\Controllers\Admin\Setting;
use App\Controllers\BaseController;

use App\Models\Fastly;
use App\Services\IM\Telegram;
use App\Services\Fastly as FastlyClient;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use stdClass;
use voku\helper\AntiXSS;
use function trim;


final class FastlyController extends BaseController
{
    private static array $details = [
        'field' => [
            'ip' => 'آدرس IP',
            'details' => 'مشخصات IP',
            'updated_at' => 'زمان به روز رسانی',
        ],
    ];


    /**
     * Pull a particular property from each assoc. array in a numeric array, 
     * returning and array of the property values from each item.
     *
     *  @param  array  $a    Array to get data from
     *  @param  string $prop Property to read
     *  @return array        Array of property values
     */
    public static function pluck($a, $prop)
    {
        $out = [];

        for ($i = 0, $len = count($a); $i < $len; $i++) {
            if (empty($a[$i][$prop]) && $a[$i][$prop] !== 0) {
                continue;
            }

            //removing the $out array index confuses the filter method in doing proper binding,
            //adding it ensures that the array data are mapped correctly
            $out[$i] = $a[$i][$prop];
        }

        return $out;
    }


    /**
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write($this->view()
            ->assign('smarts', "[1]")
            ->assign('ip', "127.0.0.1")
            ->fetch('admin/setting/fastly.tpl'));
    }


    public function add(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $antiXss = new AntiXSS();
        $data = $antiXss->xss_clean($request->getParam('data'));

        if (count($data) > 1) {
            return $response->withStatus(400)
                ->withJson([
                    'ret' => 0,
                    'msg' => 'فقط یک گزینه را انتخاب کنید.',
                    'error' => 'فقط یک گزینه را انتخاب کنید.'
                ]);
        }

        $username = $antiXss->xss_clean(trim($data[0]['username']));
        $password = $antiXss->xss_clean(trim($data[0]['password']));
        $fastlyClient = new FastlyClient();
        [$login, $error] = $fastlyClient::Login($username, $password);
        if ($error) {
            return $response->withStatus(500)
                ->withJson([
                    'ret' => 0,
                    'msg' => $error,
                ]);
        }

        $access = json_decode($login, true);
        $token = $access['access_token'];
        [$userToken, $error] = $fastlyClient::addToken($username, $password);
        if ($error) {
            return $response->withStatus(500)
                ->withJson([
                    'ret' => 0,
                    'msg' => $error,
                ]);
        }

        [$currentUser, $error] = $fastlyClient::getUserFromToken($token);
        if ($error) {
            return $response->withStatus(500)
                ->withJson([
                    'ret' => 0,
                    'msg' => $error,
                ]);
        }

        $dupplicate = Fastly::where('customer_id', $currentUser['customer_id'])->count();
        if ($dupplicate !== 0) {
            return $response->withStatus(500)
                ->withJson([
                    'ret' => 0,
                    'msg' => 'این اکانت قبلا ثبت شده.',
                ]);
        }

        [$trial, $error] = fastlyClient::validateTrials($token);
        if ($error) {
            return $response->withStatus(500)
                ->withJson([
                    'ret' => 0,
                    'msg' => $error,
                ]);
        }

        // [$fanout, $error] = fastlyClient::isValidFanout();
        // if ($error) {
        //     return $response->withStatus(500)
        //         ->withJson([
        //             'ret' => 0,
        //             'msg' => $error,
        //         ]);
        // }
        // $entitled['fanout'] = $fanout;

        [$ws, $error] = fastlyClient::isValidWebSockets($token);
        if ($error) {
            return $response->withStatus(500)
                ->withJson([
                    'ret' => 0,
                    'msg' => $error,
                ]);
        }
        $entitled['websocket'] = $ws;

        [$Service, $error] = $fastlyClient->ServicesCreate([
            'name' => 'tunnel-passthrough',
            'type' => 'wasm',
            'comment' => 'WebSocket Passthrough',
          ]);
        if ($error) {
            return $response->withStatus(500)
                ->withJson([
                    'ret' => 0,
                    'msg' => $error,
                ]);
        }

        [$Domains, $error] = $fastlyClient->addDomainToService([
            'service_id' => $Service['id'],
            'version_id' => 1,
            'name' => $fastlyClient::newDomainName(),
          ]);
        if ($error) {
            return $response->withStatus(500)
                ->withJson([
                    'ret' => 0,
                    'msg' => $error,
                ]);
        }

        // $wasm = $fastlyClient::getComputeWasm($accessToken['customer_id']);
        $Package = $fastlyClient::PackageUpload($userToken['customer_id'], 1, BASE_PATH . '/resources/extra/fastly/Tunnel-passthrough.tar.gz');
        
        // y8lgLTDnMjICwM8REnJx61
        $fastly = new Fastly();
        $fastly->login = $login;
        $fastly->token = $userToken;
        $fastly->customer_id = $userToken['customer_id'];
        $fastly->user = $currentUser;
        $fastly->entitled = $entitled;
        $fastly->trial = $trial;
        $fastly->service = $Service;
        $fastly->domains = $Domains;
        $fastly->package = $Package;
        $fastly->created_at = time();
        $fastly->updated_at = time();

        if (!$fastly->save()) {
            return $response->withStatus(500)
                ->withJson([
                    'ret' => 0,
                    'msg' => 'اکانت اضافه نشد',
                ]);
        }

        return $response->withStatus(200)
            ->withJson([
                'ret' => 1,
                'msg' => 'اکانت با موفقیت اضافه شد'
            ]);
    }

    /**
     * 后台更新指定节点内容
     */
    public function update(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $antiXss = new AntiXSS();
        $id = $antiXss->xss_clean($args['id']);
        $dns = Fastly::find($id);

        $data = $antiXss->xss_clean($request->getParam('data'));

        if (count($data) > 1) {
            return $response->withStatus(400)
                ->withJson([
                    'ret' => 0,
                    'msg' => 'فقط یک گزینه را انتخاب کنید.',
                    'error' => 'فقط یک گزینه را انتخاب کنید.'
                ]);
        }
        if (isset($data[$id]['ip'])) {
            $ip = $antiXss->xss_clean(trim($data[$id]['ip']));
            $dupplicate = Fastly::where('ip', $ip)->count();
            if ($dupplicate !== 0) {
                return $response->withStatus(400)
                    ->withJson([
                        'ret' => 0,
                        'msg' => 'این آدرس قبلا ثبت شده و نیازی به ثبت مجدد نیست.',
                        'error' => 'این آدرس قبلا ثبت شده و نیازی به ثبت مجدد نیست.',
                    ]);
            }
            $dns->ip = $ip;
        }

        if (isset($data[$id]['node'])) {
            $node = $antiXss->xss_clean($data[$id]['node']);
            $dns->node = $node['id'];
        }

        $dns->updated_at = time();


        if (!$dns->save()) {
            return $response->withStatus(500)
                ->withJson([
                    'ret' => 0,
                    'msg' => 'خطا در اصلاح اطلاعات',
                    'error' => 'خطا در اصلاح اطلاعات',
                ]);
        }

        $rdns = json_decode(Subscribe::getContent($this->user, "smartdns"));
        foreach ($rdns as $rd) {
            $value = $rd->id;
            if ($value === $dns->node) {
                $dns->node = $rd;
                break;
            }
        }

        $ret = new stdClass();
        $ret->ip = $dns->ip;
        $ret->node = $dns->node;

        return $response->withStatus(200)
            ->withJson([
                $id => $ret,
                'ret' => 1,
                'msg' => 'با موفقیت اصلاح شد',
            ]);
    }

    /**
     * 后台删除指定节点
     */
    public function delete(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $dns = Fastly::find($id);

        if (!$dns->delete()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'حذف نشد',
                'error' => 'حذف نشد',
            ]);
        }

        return $response->withJson([
            'data' => [],
            'ret' => 1,
            'msg' => 'با موفقیت حذف شد',
        ]);
    }

    /**
     * 后台节点页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $accounts = Fastly::all();

        // foreach ($accounts as $account) {
        //     foreach ($account as $rd) {
        //         $id = $rd->id;
        //         if ($account->token === $id) {
        //             $userdns->node = $rd;
        //             break;
        //         }
        //     }
        // }

        return $response->withStatus(200)
            ->withJson([
                'data' => $accounts,
                'ret' => 1,
                'msg' => 'success'
            ]);
    }
}

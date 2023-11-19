<?php

declare(strict_types=1);

namespace App\Controllers\User;

use App\Controllers\BaseController;
use App\Models\Node;
use App\Models\Setting;
use App\Models\SmartDns;
use App\Services\Cloudflare;
use App\Services\IM\Telegram;
use App\Services\Subscribe;
use App\Utils\Tools;
use Cloudflare\API\Endpoints\EndpointException;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use stdClass;
use voku\helper\AntiXSS;
use function trim;

final class SmartDnsController extends BaseController
{
    private static array $details = [
        'field' => [
            'ip' => 'آدرس IP',
            'details' => 'مشخصات IP',
            'updated_at' => 'زمان به روز رسانی',
        ],
    ];

    private static array $update_field = [
        'name',
        'server',
        'traffic_rate',
        'info',
        'node_group',
        'node_speedlimit',
        'sort',
        'node_ip',
        'node_class',
        'node_bandwidth_limit',
        'bandwidthlimit_resetday',
    ];



    /**
     * Pull a particular property from each assoc. array in a numeric array, 
     * returning and array of the property values from each item.
     *
     *  @param  array  $a    Array to get data from
     *  @param  string $prop Property to read
     *  @return array        Array of property values
     */
    static function pluck($a, $prop)
    {
        $out = array();

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
    public function dns(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write($this->view()
            ->fetch('user/smart_dns.tpl'));
    }


    /**
     * 后台节点页面
     *
     * @throws Exception
     */
    public function check(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        // $_SERVER['REMOTE_ADDR']
        return $response->withStatus(200)
            ->withHeader('Access-Control-Allow-Origin', '*')
            ->withJson([
                'ret' => 1,
            ]);
    }

    /**
     * 后台添加节点
     *
     * @throws EndpointException
     */
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

        $ip = $antiXss->xss_clean(trim($data[0]['ip']));
        if (!(Tools::isIPv4($ip) || Tools::isIPv6($ip))) {
            return $response->withStatus(200)
                ->withJson([
                    'ret' => 0,
                    'error' => 'مقدار IP صحیح نیست.'
                ]);
        }


        $user = $this->user;
        $count = SmartDns::where('userid', $user->id)->count();

        if ($user->smart_dns === null) {
            return $response->withStatus(200)
                ->withJson([
                    'ret' => 0,
                    'error' => 'دسترسی به این سرویس برای شما فعال نیست',
                ]);
        }

        $dupplicate = SmartDns::where('ip', $ip)->count();
        if ($dupplicate !== 0) {
            return $response->withStatus(200)
                ->withJson([
                    'ret' => 0,
                    'error' => 'این آدرس قبلا ثبت شده و نیازی به ثبت مجدد نیست.',
                ]);
        }

        if ($user->smart_dns !== 0 && ($count === $user->smart_dns || $count > $user->smart_dns)) {
            return $response->withStatus(200)
                ->withJson([
                    'ret' => 0,
                    'error' => 'در حال حاضر شما از حداکثر میزان مجاز تعداد آدرس استفاده کرده اید.',
                ]);
        }

        $dns = new SmartDns();
        $dns->ip = $ip;
        $dns->created_at = time();
        $dns->updated_at = time();
        $dns->mark = (string) Tools::getIpLocation($ip);
        $dns->userid = $user->id;

        if (!$dns->save()) {
            return $response->withStatus(500)
                ->withJson([
                    'ret' => 0,
                    'msg' => 'گره اضافه نشد',
                ]);
        }

        return $response->withStatus(200)
            ->withJson([
                'ret' => 1,
                'msg' => 'سرور با موفقیت اضافه شد'
            ]);
    }

    /**
     * 后台更新指定节点内容
     */
    public function update(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $antiXss = new AntiXSS();
        $id = $antiXss->xss_clean($args['id']);
        $dns = SmartDns::find($id);

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
            $dupplicate = SmartDns::where('ip', $ip)->count();
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
        ;

        if (isset($data[$id]['node'])) {
            $node = $antiXss->xss_clean($data[$id]['node']);
            $dns->node = $node['id'];
        }
        ;

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
            if ($value == $dns->node) {
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
        $dns = SmartDns::find($id);

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

        $user = $this->user;
        $userdnss = SmartDns::where('userid', $user->id)->orderBy('id', 'desc')->get();
        $rdns = json_decode(Subscribe::getContent($this->user, "smartdns"));

        foreach ($userdnss as $userdns) {
            foreach ($rdns as $rd) {
                $id = $rd->id;
                if ($userdns->node == $id) {
                    $userdns->node = $rd;
                    break;
                };
            }
        }

        return $response->withStatus(200)
            ->withJson([
                'data' => $userdnss,
                'ret' => 1,
                'msg' => 'success'
            ]);
    }
}
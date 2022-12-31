<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Node;
use App\Models\Setting;
use App\Utils\CloudflareDriver;
use App\Utils\Telegram;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Request;
use Slim\Http\Response;

final class NodeController extends BaseController
{
    public static $details = [
        'field' => [
            'op' => 'شرح عملیات',
            'id' => 'شناسه نود',
            'name' => 'نام',
            'server' => 'نشانی',
            'type' => 'وضعیت',
            'sort' => 'نوع',
            'traffic_rate' => 'بزرگنمایی',
            'node_class' => 'درجه',
            'node_group' => 'گروه',
            'node_bandwidth_limit' => 'محدودیت های ترافیکی/GB',
            'node_bandwidth' => 'ترافیک استفاده شده/GB',
            'bandwidthlimit_resetday' => 'تاریخ تنظیم مجدد',
        ],
    ];

    public static $update_field = [
        'name',
        'server',
        'mu_only',
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
     * 后台节点页面
     *
     * @param array     $args
     */
    public function index(Request $request, Response $response, array $args): ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->display('admin/node/index.tpl')
        );
    }

    /**
     * 后台创建节点页面
     *
     * @param array     $args
     */
    public function create(Request $request, Response $response, array $args): ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('update_field', self::$update_field)
                ->display('admin/node/create.tpl')
        );
    }

    /**
     * 后台添加节点
     *
     * @param array     $args
     */
    public function add(Request $request, Response $response, array $args): ResponseInterface
    {
        $node = new Node();
        $node->name = $request->getParam('name');
        $node->server = trim($request->getParam('server'));
        $node->traffic_rate = $request->getParam('traffic_rate');
        $node->info = $request->getParam('info');
        $node->type = $request->getParam('type') === 'true' ? 1 : 0;
        $node->node_group = $request->getParam('node_group');
        $node->node_speedlimit = $request->getParam('node_speedlimit');
        $node->status = '';
        $node->sort = $request->getParam('sort');

        if ($request->getParam('custom_config') !== null) {
            $node->custom_config = $request->getParam('custom_config');
        } else {
            $node->custom_config = '{}';
        }

        $req_node_ip = trim($request->getParam('node_ip'));
        $success = true;
        $server_list = explode(';', $node->server);

        if (Tools::isIPv4($req_node_ip)) {
            $success = $node->changeNodeIp($req_node_ip);
        } else {
            $success = $node->changeNodeIp($server_list[0]);
        }

        if (! $success) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'دریافت IP نود ناموفق بود، لطفاً بررسی کنید که آیا آدرس نود وارد شده صحیح است یا خیر！',
            ]);
        }

        $node->node_class = $request->getParam('node_class');

        if ($request->getParam('node_bandwidth_limit') === null || $request->getParam('node_bandwidth_limit') === '') {
            $node->node_bandwidth_limit = 0;
        } else {
            $node->node_bandwidth_limit = $request->getParam('node_bandwidth_limit') * 1024 * 1024 * 1024;
        }

        $node->bandwidthlimit_resetday = $request->getParam('bandwidthlimit_resetday');
        $node->password = Tools::genRandomChar(32);

        $node->save();

        if ($_ENV['cloudflare_enable'] === true) {
            $domain_name = explode('.' . $_ENV['cloudflare_name'], $node->server);
            CloudflareDriver::updateRecord($domain_name[0], $node->node_ip);
        }

        if (Setting::obtain('telegram_add_node')) {
            try {
                Telegram::send(
                    str_replace(
                        '%node_name%',
                        $request->getParam('name'),
                        Setting::obtain('telegram_add_node_text')
                    )
                );
            } catch (Exception $e) {
                return $response->withJson([
                    'ret' => 1,
                    'msg' => 'نود با موفقیت اضافه شد، اما اعلان تلگرام ناموفق بود',
                    'node_id' => $node->id,
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'نود با موفقیت اضافه شد',
            'node_id' => $node->id,
        ]);
    }

    /**
     * 后台编辑指定节点页面
     *
     * @param array     $args
     */
    public function edit(Request $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $node = Node::find($id);
        return $response->write(
            $this->view()
                ->assign('node', $node)
                ->assign('update_field', self::$update_field)
                ->display('admin/node/edit.tpl')
        );
    }

    /**
     * 后台更新指定节点内容
     *
     * @param array     $args
     */
    public function update(Request $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $node = Node::find($id);
        $node->name = $request->getParam('name');
        $node->node_group = $request->getParam('node_group');
        $node->server = trim($request->getParam('server'));
        $node->traffic_rate = $request->getParam('traffic_rate');
        $node->info = $request->getParam('info');
        $node->node_speedlimit = $request->getParam('node_speedlimit');
        $node->type = $request->getParam('type') === 'true' ? 1 : 0;
        $node->sort = $request->getParam('sort');

        if ($request->getParam('custom_config') !== null) {
            $node->custom_config = $request->getParam('custom_config');
        } else {
            $node->custom_config = '{}';
        }

        $req_node_ip = trim($request->getParam('node_ip'));

        $success = true;
        $server_list = explode(';', $node->server);

        if (Tools::isIPv4($req_node_ip)) {
            $success = $node->changeNodeIp($req_node_ip);
        } else {
            $success = $node->changeNodeIp($server_list[0]);
        }

        if (! $success) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'به روز رسانی IP نود انجام نشد، لطفاً بررسی کنید که آیا آدرس نود وارد شده صحیح است یا خیر！',
            ]);
        }

        $node->status = '';
        $node->node_class = $request->getParam('node_class');
        $node->node_bandwidth_limit = $request->getParam('node_bandwidth_limit') * 1024 * 1024 * 1024;
        $node->bandwidthlimit_resetday = $request->getParam('bandwidthlimit_resetday');

        $node->save();

        if (Setting::obtain('telegram_update_node')) {
            try {
                Telegram::send(
                    str_replace(
                        '%node_name%',
                        $request->getParam('name'),
                        Setting::obtain('telegram_update_node_text')
                    )
                );
            } catch (Exception $e) {
                return $response->withJson([
                    'ret' => 1,
                    'msg' => 'اصلاح با موفقیت انجام شد، اما اعلان تلگرام ناموفق بود',
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت اصلاح شد',
        ]);
    }

    /**
     * @param array     $args
     */
    public function resetNodePassword(Request $request, Response $response, array $args)
    {
        $id = $args['id'];
        $node = Node::find($id);
        $password = Tools::genRandomChar(32);

        $node->password = $password;

        $node->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'کلید ارتباطی با موفقیت بازنشانی شد',
        ]);
    }

    /**
     * 后台删除指定节点
     *
     * @param array     $args
     */
    public function delete(Request $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $node = Node::find($id);

        if (! $node->delete()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'حذف نشد',
            ]);
        }

        if (Setting::obtain('telegram_delete_node')) {
            try {
                Telegram::send(
                    str_replace(
                        '%node_name%',
                        $node->name,
                        Setting::obtain('telegram_delete_node_text')
                    )
                );
            } catch (Exception $e) {
                return $response->withJson([
                    'ret' => 1,
                    'msg' => 'حذف با موفقیت انجام شد، اما اعلان تلگرام ناموفق بود',
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت حذف شد',
        ]);
    }

    public function copy($request, $response, $args)
    {
        try {
            $old_node_id = $args['id'];
            $old_node = Node::find($old_node_id);
            $new_node = new Node();
            // https://laravel.com/docs/9.x/eloquent#replicating-models
            $new_node = $old_node->replicate([
                'node_bandwidth',
            ]);
            $new_node->name .= ' (کپی)';
            $new_node->node_bandwidth = 0;
            $new_node->save();
        } catch (\Exception $e) {
            return $response->withJson([
                'ret' => 0,
                'msg' => $e->getMessage(),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت کپی کنید',
        ]);
    }

    /**
     * 后台节点页面 AJAX
     *
     * @param array     $args
     */
    public function ajax(Request $request, Response $response, array $args): ResponseInterface
    {
        $nodes = Node::orderBy('id', 'desc')->get();

        foreach ($nodes as $node) {
            $node->op = '<button type="button" class="btn btn-red" id="delete-node-' . $node->id . '" 
            onclick="deleteNode(' . $node->id . ')">حذف</button>
            <button type="button" class="btn btn-orange" id="copy-node-' . $node->id . '" 
            onclick="copyNode(' . $node->id . ')">کپی</button>
            <a class="btn btn-blue" href="/admin/node/' . $node->id . '/edit">ویرایش کنید</a>';
            $node->type = Tools::getNodeType($node);
            $node->sort = Tools::getNodeSort($node);
            $node->node_bandwidth = round(Tools::flowToGB($node->node_bandwidth), 2);
            $node->node_bandwidth_limit = Tools::flowToGB($node->node_bandwidth_limit);
        }

        return $response->withJson([
            'nodes' => $nodes,
        ]);
    }
}

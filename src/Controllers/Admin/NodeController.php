<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Node;
use App\Models\Setting;
use App\Services\Cloudflare;
use App\Utils\Telegram;
use App\Utils\Tools;
use Cloudflare\API\Endpoints\EndpointException;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function trim;

final class NodeController extends BaseController
{
    public static array $details = [
        'field' => [
            'op' => 'شرح عملیات',
            'id' => 'شناسه سرور',
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

    public static array $update_field = [
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
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('admin/node/index.tpl')
        );
    }

    /**
     * 后台创建节点页面
     *
     * @throws Exception
     */
    public function create(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('update_field', self::$update_field)
                ->fetch('admin/node/create.tpl')
        );
    }

    /**
     * 后台添加节点
     *
     * @throws EndpointException
     */
    public function add(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $name = $request->getParam('name') ?? '';
        $server = trim($request->getParam('server'));
        $traffic_rate = $request->getParam('traffic_rate') ?? 1;
        $custom_config = $request->getParam('custom_config') ?? '{}';
        $info = $request->getParam('info') ?? '';
        $type = $request->getParam('type') === 'true' ? 1 : 0;
        $node_group = $request->getParam('node_group') ?? 0;
        $node_speedlimit = $request->getParam('node_speedlimit') ?? 0;
        $sort = $request->getParam('sort') ?? 0;
        $req_node_ip = trim($request->getParam('node_ip'));
        $node_class = $request->getParam('node_class') ?? 0;
        $node_bandwidth_limit = $request->getParam('node_bandwidth_limit') ?? 0;
        $bandwidthlimit_resetday = $request->getParam('bandwidthlimit_resetday') ?? 0;

        if ($name === '' ||
            $server === '' ||
            $traffic_rate === '' ||
            $node_group === '' ||
            $node_speedlimit === '' ||
            $sort === '' ||
            $node_class === '' ||
            $node_bandwidth_limit === '' ||
            $bandwidthlimit_resetday === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'لطفاً مطمئن شوید که هیچ کدام از موارد خالی نباشند',
            ]);
        }

        $node = new Node();
        $node->name = $name;
        $node->server = $server;
        $node->traffic_rate = $traffic_rate;

        if ($custom_config !== '') {
            $node->custom_config = $custom_config;
        } else {
            $node->custom_config = '{}';
        }

        $node->info = $info;
        $node->type = $type;
        $node->node_group = $node_group;
        $node->node_speedlimit = $node_speedlimit;
        $node->status = '';
        $node->sort = $sort;
        $node->node_class = $node_class;
        $node->node_bandwidth_limit = $node_bandwidth_limit * 1024 * 1024 * 1024;
        $node->bandwidthlimit_resetday = $bandwidthlimit_resetday;

        if (Tools::isIPv4($req_node_ip) || Tools::isIPv6($req_node_ip)) {
            $node->changeNodeIp($req_node_ip);
        } else {
            $node->changeNodeIp($server);
        }

        $node->password = Tools::genRandomChar(32);

        if (! $node->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'گره اضافه نشد',
            ]);
        }

        if ($_ENV['cloudflare_enable']) {
            $domain_name = explode('.' . $_ENV['cloudflare_name'], $node->server);
            Cloudflare::updateRecord($domain_name[0], $node->node_ip, $_ENV['cloudflare_email'], $_ENV['cloudflare_key'], $_ENV['cloudflare_name']);
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
                    'msg' => 'سرور با موفقیت اضافه شد، اما اعلان تلگرام ناموفق بود',
                    'node_id' => $node->id,
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'سرور با موفقیت اضافه شد',
            'node_id' => $node->id,
        ]);
    }

    /**
     * 后台编辑指定节点页面
     *
     * @throws Exception
     */
    public function edit(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $node = Node::find($id);

        return $response->write(
            $this->view()
                ->assign('node', $node)
                ->assign('update_field', self::$update_field)
                ->fetch('admin/node/edit.tpl')
        );
    }

    /**
     * 后台更新指定节点内容
     */
    public function update(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $node = Node::find($id);

        $custom_config = $request->getParam('custom_config') ?? '{}';

        $node->name = $request->getParam('name');
        $node->node_group = $request->getParam('node_group');
        $node->server = trim($request->getParam('server'));
        $node->traffic_rate = $request->getParam('traffic_rate');
        $node->info = $request->getParam('info');
        $node->node_speedlimit = $request->getParam('node_speedlimit');
        $node->type = $request->getParam('type') === 'true' ? 1 : 0;
        $node->sort = $request->getParam('sort');

        if ($custom_config !== '') {
            $node->custom_config = $custom_config;
        } else {
            $node->custom_config = '{}';
        }

        $req_node_ip = trim($request->getParam('node_ip'));

        if (Tools::isIPv4($req_node_ip) || Tools::isIPv6($req_node_ip)) {
            $node->changeNodeIp($req_node_ip);
        } else {
            $node->changeNodeIp($node->server);
        }

        $node->status = '';
        $node->node_class = $request->getParam('node_class');
        $node->node_bandwidth_limit = $request->getParam('node_bandwidth_limit') * 1024 * 1024 * 1024;
        $node->bandwidthlimit_resetday = $request->getParam('bandwidthlimit_resetday');

        if (! $node->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'ویرایش موفقیت آمیز نبود',
            ]);
        }

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

    public function resetNodePassword(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $id = $args['id'];
        $node = Node::find($id);
        $password = Tools::genRandomChar(32);

        $node->password = $password;

        $node->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'کلید ارتباطی گره با موفقیت بازنشانی شد',
        ]);
    }

    /**
     * 后台删除指定节点
     */
    public function delete(ServerRequest $request, Response $response, array $args): ResponseInterface
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
        } catch (Exception $e) {
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
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $nodes = Node::orderBy('id', 'desc')->get();

        foreach ($nodes as $node) {
            $node->op = '<button type="button" class="btn btn-red" id="delete-node-' . $node->id . '" 
            onclick="deleteNode(' . $node->id . ')">حذف</button>
            <button type="button" class="btn btn-orange" id="copy-node-' . $node->id . '" 
            onclick="copyNode(' . $node->id . ')">کپی</button>
            <a class="btn btn-blue" href="/admin/node/' . $node->id . '/edit">ویرایش کنید</a>';
            $node->type = $node->type();
            $node->sort = $node->sort();
            $node->node_bandwidth = round(Tools::flowToGB($node->node_bandwidth), 2);
            $node->node_bandwidth_limit = Tools::flowToGB($node->node_bandwidth_limit);
        }

        return $response->withJson([
            'nodes' => $nodes,
        ]);
    }
}

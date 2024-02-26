<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Config;
use App\Models\Node;
use App\Services\IM\Telegram;
use App\Utils\Tools;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use SmartyException;
use Telegram\Bot\Exceptions\TelegramSDKException;
use function json_decode;
use function json_encode;
use function round;
use function str_replace;
use function trim;

final class NodeController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'شرح عملیات',
            'id' => 'شناسه سرور',
            'name' => 'نام',
            'server' => 'نشانی',
            'type' => 'وضعیت',
            'sort' => 'نوع',
            'traffic_rate' => 'ضریب ترافیک',
            'is_dynamic_rate' => 'فعال کردن ضریب ترافیک پویا',
            'dynamic_rate_type' => 'روش محاسبه پویا',
            'node_class' => 'درجه',
            'node_group' => 'گروه',
            'node_bandwidth_limit' => 'محدودیت های ترافیکی/GB',
            'node_bandwidth' => 'ترافیک استفاده شده/GB',
            'bandwidthlimit_resetday' => 'تاریخ تنظیم مجدد',
        ],
    ];

    private static array $update_field = [
        'name',
        'server',
        'traffic_rate',
        'is_dynamic_rate',
        'dynamic_rate_type',
        'max_rate',
        'max_rate_time',
        'min_rate',
        'min_rate_time',
        'node_group',
        'node_speedlimit',
        'sort',
        'node_class',
        'node_bandwidth_limit',
        'bandwidthlimit_resetday',
    ];

    /**
     * 后台节点页面
     *
     * @throws SmartyException
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
     * @throws SmartyException
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
     */
    public function add(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node = new Node();

        $node->name = $request->getParam('name');
        $node->node_group = $request->getParam('node_group');
        $node->server = trim($request->getParam('server'));
        $node->traffic_rate = $request->getParam('traffic_rate') ?? 1;
        $node->is_dynamic_rate = $request->getParam('is_dynamic_rate') === 'true' ? 1 : 0;
        $node->dynamic_rate_type = $request->getParam('dynamic_rate_type') ?? 0;
        $node->dynamic_rate_config = json_encode([
            'max_rate' => $request->getParam('max_rate') ?? 1,
            'max_rate_time' => $request->getParam('max_rate_time') ?? 22,
            'min_rate' => $request->getParam('min_rate') ?? 1,
            'min_rate_time' => $request->getParam('min_rate_time') ?? 3,
        ]);

        $custom_config = $request->getParam('custom_config') ?? '{}';

        if ($custom_config !== '') {
            $node->custom_config = $custom_config;
        } else {
            $node->custom_config = '{}';
        }

        $enable_vless = $request->getParam('enable_vless') === 'true' ? true : false;
        $node->enable_vless = $enable_vless;
        if ($enable_vless) {
            $temp_conf = [];
            $temp_conf['enable_reality'] = $request->getParam('enable_reality') === 'true' ? true : false;
            $reality_dest = $request->getParam('reality_dest');
            if (($reality_dest == null) || ($reality_dest == "")) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'مقدار dest مجاز نیست',
                ]);
            }
            $reality_dest = trim($reality_dest);

            $ServerNames = $request->getParam('server_names');
            if (($ServerNames == null) || ($ServerNames == "")) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'مقدار dest مجاز نیست',
                ]);
            }
            $ServerNames = explode(",", trim($ServerNames, '"'));

            $temp_conf['reality_opts'] = $request->getParam('enable_reality') === 'true' ? $this->initReality($ServerNames, $reality_dest) : "{}"; 
        }
        $node->reality_opts = $temp_conf != null ? json_encode($temp_conf) : '{}';
        

        $node->is_route_dns = $request->getParam('is_route_dns') === 'true' ? 1 : 0;        
        $node->node_speedlimit = $request->getParam('node_speedlimit');
        $node->type = $request->getParam('type') === 'true' ? 1 : 0;
        $node->sort = $request->getParam('sort');
        $node->node_class = $request->getParam('node_class');
        $node->node_bandwidth_limit = Tools::toGB($request->getParam('node_bandwidth_limit'));
        $node->bandwidthlimit_resetday = $request->getParam('bandwidthlimit_resetday');
        $node->password = Tools::genRandomChar(32);

        if (! $node->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'گره اضافه نشد',
            ]);
        }

        if (Config::obtain('telegram_add_node')) {
            try {
                (new Telegram())->send(
                    0,
                    str_replace(
                        '%node_name%',
                        $request->getParam('name'),
                        Config::obtain('telegram_add_node_text')
                    )
                );
            } catch (TelegramSDKException $e) {
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
     * @throws SmartyException
     */
    public function edit(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node = (new Node())->find($args['id']);

        $dynamic_rate_config = json_decode($node->dynamic_rate_config);
        $node->max_rate = $dynamic_rate_config?->max_rate ?? 1;
        $node->max_rate_time = $dynamic_rate_config?->max_rate_time ?? 22;
        $node->min_rate = $dynamic_rate_config?->min_rate ?? 1;
        $node->min_rate_time = $dynamic_rate_config?->min_rate_time ?? 3;

        $node->is_reality = false;
        if ($node->reality_opts != '{}') {
        
            $reality_opts = json_decode($node->reality_opts);
            if ($reality_opts->reality_opts !== '{}') {
                $node->is_reality = true;
                $node->private_key = $reality_opts->private_key;
                $node->public_key = $reality_opts->public_key;
                $node->ShortIds = implode(',', $reality_opts->ShortIds);
                $node->ServerNames = implode(',', $reality_opts->ServerNames);
                $node->Dest = $reality_opts->Dest;
                $node->ProxyProtocolVer = $reality_opts->ProxyProtocolVer ?? 0;
                // $node->is_reality = true;
            }
        }
        // $node->max_rate = $dynamic_rate_config?->max_rate ?? 1;
        // $node->max_rate_time = $dynamic_rate_config?->max_rate_time ?? 22;
        // $node->min_rate = $dynamic_rate_config?->min_rate ?? 1;
        // $node->min_rate_time = $dynamic_rate_config?->min_rate_time ?? 3;

        $node->node_bandwidth = Tools::autoBytes($node->node_bandwidth);
        $node->node_bandwidth_limit = Tools::flowToGB($node->node_bandwidth_limit);

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
        $node = (new Node())->find($args['id']);

        $node->name = $request->getParam('name');
        $node->node_group = $request->getParam('node_group') ?? 0;
        $node->server = trim($request->getParam('server'));
        $node->traffic_rate = $request->getParam('traffic_rate') ?? 1;
        $node->is_dynamic_rate = $request->getParam('is_dynamic_rate') === 'true' ? 1 : 0;
        $node->dynamic_rate_type = $request->getParam('dynamic_rate_type') ?? 0;
        $node->dynamic_rate_config = json_encode([
            'max_rate' => $request->getParam('max_rate') ?? 1,
            'max_rate_time' => $request->getParam('max_rate_time') ?? 0,
            'min_rate' => $request->getParam('min_rate') ?? 1,
            'min_rate_time' => $request->getParam('min_rate_time') ?? 0,
        ]);

        $custom_config = $request->getParam('custom_config') ?? '{}';

        if ($custom_config !== '') {
            $node->custom_config = $custom_config;
        } else {
            $node->custom_config = '{}';
        }

        $enable_vless = $request->getParam('enable_vless') === 'true' ? 1 : 0;
        $node->enable_vless = $enable_vless;
        if ($enable_vless == 0) {
            $node->reality_opts = json_encode([
                'enable_reality' => false,
                'reality_opts' => '{}',
            ]);
        } else {
            $reality_opts = json_decode($node->reality_opts, true);
            if ($reality_opts['enable_reality']) {
                
                $reality_dest = $request->getParam('reality_dest');
                if (($reality_dest == null) || ($reality_dest == "")) {
                    return $response->withJson([
                        'ret' => 0,
                        'msg' => 'مقدار dest مجاز نیست',
                    ]);
                }
                $reality_dest = trim($reality_dest);

                $ServerNames = $request->getParam('server_names');
                if (($ServerNames == null) || ($ServerNames == "")) {
                    return $response->withJson([
                        'ret' => 0,
                        'msg' => 'مقدار dest مجاز نیست',
                    ]);
                }
                $ServerNames = explode(",", trim($ServerNames));
                
                $sIds = explode(",", trim($request->getParam('short_ids'), '"'));
                if (! Tools::validateShortIds($sIds)) {
                    return $response->withJson([
                        'ret' => 0,
                        'msg' => 'خطا در مقدار short_ids',
                    ]);
                }

                $reality_opts['reality_opts']['ServerNames'] = $ServerNames;
                $reality_opts['reality_opts']['Dest'] = $reality_dest;
                $reality_opts['reality_opts']['ShortIds'] = $sIds;
                $node->reality_opts = json_encode($reality_opts);
            }
        }
        
        $node->node_speedlimit = $request->getParam('node_speedlimit');
        $node->type = $request->getParam('type') === 'true' ? 1 : 0;
        $node->sort = $request->getParam('sort');

        $node->is_route_dns = $request->getParam('is_route_dns') === 'true' ? 1 : 0;
        $node->node_class = $request->getParam('node_class');
        $node->node_bandwidth_limit = Tools::toGB($request->getParam('node_bandwidth_limit'));
        $node->bandwidthlimit_resetday = $request->getParam('bandwidthlimit_resetday');

        if (! $node->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'ویرایش موفقیت آمیز نبود',
            ]);
        }

        if (Config::obtain('telegram_update_node')) {
            try {
                (new Telegram())->send(
                    0,
                    str_replace(
                        '%node_name%',
                        $request->getParam('name'),
                        Config::obtain('telegram_update_node_text')
                    )
                );
            } catch (TelegramSDKException $e) {
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

    public function resetPassword(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $node = (new Node())->find($args['id']);
        $node->password = Tools::genRandomChar(32);
        if (! $node->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطا در بازنشانی کلید ارتباطی',
            ]);
        }

        if (Config::obtain('telegram_update_node')) {
            try {
                (new Telegram())->send(
                    0,
                    str_replace(
                        '%node_name%',
                        $node->name,
                        Config::obtain('telegram_update_node_text')
                    )
                );
            } catch (TelegramSDKException $e) {
                return $response->withJson([
                    'ret' => 1,
                    'msg' => 'اصلاح با موفقیت انجام شد، اما اعلان تلگرام ناموفق بود',
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'کلید ارتباطی گره با موفقیت بازنشانی شد',
        ]);
    }

    function initReality($ServerNames, $reality_dest): array|bool
    {

        // Generate KeyPair
        $keys = Tools::x25519();
        if ($keys == false) {
            return false;
        }

        $REALITYConfig['private_key'] = $keys['private_key'];
        $REALITYConfig['public_key'] = $keys['public_key'];

        // if (($ids !== null) && ($ids !== "")) {
        //     $ShortIds = explode(',', $ids);
        //     $REALITYConfig['ShortIds'] = $ShortIds;
        // } else {
            $REALITYConfig['ShortIds'] = Tools::randomShortId(5) ?? [];
        // }

        $REALITYConfig['MinClientVer'] = '';
        $REALITYConfig['MaxClientVer'] = '';
        $REALITYConfig['MaxTimeDiff'] = 0;
        $REALITYConfig['ProxyProtocolVer'] = 0;

        // // Todo
        $REALITYConfig['Dest'] = $reality_dest ? $reality_dest : '';
        $REALITYConfig['ServerNames'] = $ServerNames ? $ServerNames : [];
        
        return $REALITYConfig;
    }


    
    public function reality(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $node = (new Node())->find($args['id']);
        $temp_conf = [];
        $temp_conf['enable_reality'] = true; 

        $reality_dest = $request->getParam('reality_dest');
        if (($reality_dest == null) || ($reality_dest == "")) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'مقدار dest مجاز نیست',
            ]);
        }
        $reality_dest = trim($reality_dest);

        $ServerNames = $request->getParam('server_names');
        if (($ServerNames == null) || ($ServerNames == "")) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'مقدار dest مجاز نیست',
            ]);
        }
        $ServerNames = explode(",", trim($ServerNames));
                
        $temp_conf['reality_opts'] = $this->initReality($ServerNames, $reality_dest); 
        $node->enable_vless = true;
        $node->reality_opts = $temp_conf != null ? json_encode($temp_conf) : json_encode([
            'enable_reality' => false,
            'reality_opts' => '{}',
        ]);
        if (! $node->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطا در فعالسازی',
            ]);
        }

        if (Config::obtain('telegram_update_node')) {
            try {
                (new Telegram())->send(
                    0,
                    str_replace(
                        '%node_name%',
                        $node->name,
                        Config::obtain('telegram_update_node_text')
                    )
                );
            } catch (TelegramSDKException $e) {
                return $response->withJson([
                    'ret' => 1,
                    'msg' => 'اصلاح با موفقیت انجام شد، اما اعلان تلگرام ناموفق بود',
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت فعال شد',
        ]);

    }
    public function disableReality(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $node = (new Node())->find($args['id']);
        $node->reality_opts = '{}';
        if (! $node->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطا در غیر فعال کردن',
            ]);
        }

        if (Config::obtain('telegram_update_node')) {
            try {
                (new Telegram())->send(
                    0,
                    str_replace(
                        '%node_name%',
                        $node->name,
                        Config::obtain('telegram_update_node_text')
                    )
                );
            } catch (TelegramSDKException $e) {
                return $response->withJson([
                    'ret' => 1,
                    'msg' => 'اصلاح با موفقیت انجام شد، اما اعلان تلگرام ناموفق بود',
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت غیر فعال شد',
        ]);

    }

    public function resetKey(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {

        $node = (new Node())->find($args['id']);
        $REALITYConfig = json_decode($node->reality_opts, true);

        $pbk = $request->getParam('pbk') ?? null;

        // Generate KeyPair
        $keys = Tools::x25519($pbk);
        if ($keys == false) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطا در تولید کلید جدید',
            ]);
        }

        $REALITYConfig['public_key'] = $keys['public_key'];
        $REALITYConfig['private_key'] = $keys['private_key'];

        $node->reality_opts = json_encode($REALITYConfig);
        if (! $node->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطا در بازنشانی کلید',
            ]);
        }

        if (Config::obtain('telegram_update_node')) {
            try {
                (new Telegram())->send(
                    0,
                    str_replace(
                        '%node_name%',
                        $node->name,
                        Config::obtain('telegram_update_node_text')
                    )
                );
            } catch (TelegramSDKException $e) {
                return $response->withJson([
                    'ret' => 1,
                    'msg' => 'اصلاح با موفقیت انجام شد، اما اعلان تلگرام ناموفق بود',
                ]);
            }
        }
        
        return $response->withJson([
            'ret' => 1,
            'msg' => 'کلید با موفقیت بازنشانی شد',
        ]);
    }

    public function resetBandwidth(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $node = (new Node())->find($args['id']);
        $node->node_bandwidth = 0;
        $node->save();
        if (! $node->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'خطا در ریست ترافیک گره',
            ]);
        }

        if (Config::obtain('telegram_update_node')) {
            try {
                (new Telegram())->send(
                    0,
                    str_replace(
                        '%node_name%',
                        $node->name,
                        Config::obtain('telegram_update_node_text')
                    )
                );
            } catch (TelegramSDKException $e) {
                return $response->withJson([
                    'ret' => 1,
                    'msg' => 'اصلاح با موفقیت انجام شد، اما اعلان تلگرام ناموفق بود',
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'ریست ترافیک گره با موفقیت انجام شد',
        ]);
    }

    /**
     * 后台删除指定节点
     */
    public function delete(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node = (new Node())->find($args['id']);

        if (! $node->delete()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'حذف نشد',
            ]);
        }

        if (Config::obtain('telegram_delete_node')) {
            try {
                (new Telegram())->send(
                    0,
                    str_replace(
                        '%node_name%',
                        $node->name,
                        Config::obtain('telegram_delete_node_text')
                    )
                );
            } catch (TelegramSDKException $e) {
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
        $old_node = (new Node())->find($args['id']);
        $new_node = $old_node->replicate([
            'node_bandwidth',
        ]);
        $new_node->name .= ' (کپی)';
        $new_node->node_bandwidth = 0;
        $new_node->password = Tools::genRandomChar(32);

        if (! $new_node->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'کپی ناموفق بود',
            ]);
        }

        if (Config::obtain('telegram_add_node')) {
            try {
                (new Telegram())->send(
                    0,
                    str_replace(
                        '%node_name%',
                        $new_node->name,
                        Config::obtain('telegram_add_node_text')
                    )
                );
            } catch (TelegramSDKException $e) {
                return $response->withJson([
                    'ret' => 1,
                    'msg' => 'سرور با موفقیت اضافه شد، اما اعلان تلگرام ناموفق بود',
                    'node_id' => $new_node->id,
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت کپی شد',
        ]);
    }

    /**
     * 后台节点页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $nodes = (new Node())->orderBy('id', 'desc')->get();

        foreach ($nodes as $node) {
            $node->op = '<button type="button" class="btn btn-red" id="delete-node-' . $node->id . '" 
            onclick="deleteNode(' . $node->id . ')">حذف</button>
            <button type="button" class="btn btn-orange" id="copy-node-' . $node->id . '" 
            onclick="copyNode(' . $node->id . ')">کپی</button>
            <a class="btn btn-blue" href="/admin/node/' . $node->id . '/edit">ویرایش</a>';
            $node->type = $node->type();
            $node->sort = $node->sort();
            $node->is_dynamic_rate = $node->isDynamicRate();
            $node->node_bandwidth = round(Tools::flowToGB($node->node_bandwidth), 2);
            $node->node_bandwidth_limit = Tools::flowToGB($node->node_bandwidth_limit);
        }

        return $response->withJson([
            'nodes' => $nodes,
        ]);
    }
}

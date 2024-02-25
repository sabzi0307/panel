<?php

declare(strict_types=1);

namespace App\Controllers\WebAPI;

use App\Controllers\BaseController;
use App\Models\Node;
use App\Models\SharedAccount;
use App\Models\StreamMedia;
use App\Utils\ResponseHelper;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function json_decode;
use const JSON_UNESCAPED_SLASHES;
use const VERSION;

final class NodeController extends BaseController
{
    public function saveSharedIds(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $body = $request->getBody()->getContents();
        $details = json_decode($body, true);
        foreach ($details as $item) {
            $ids = new SharedAccount();
            $ids->priority = $item['priority'];
            $ids->status = $item['status'];
            $ids->create_time = time();
            $ids->update_time = $item['updated_at'];
            $ids->account = $item['account'];
            $ids->password = $item['password'];
            $ids->save();
        }

        return $response->withJson([
            'ret' => 1,
            'data' => 'ok',
        ]);
    }
    public function saveReport(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node_id = $request->getParam('node_id');
        $content = $request->getParam('content');
        $result = json_decode(base64_decode($content), true);
        $report = new StreamMedia();
        $report->node_id = $node_id;
        $report->result = json_encode($result);
        $report->create_time = time();
        $report->save();

        return $response->withJson([
            'ret' => 1,
            'data' => 'ok',
        ]);
    }

    public function getInfo(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node_id = $args['id'];
        $node = (new Node())->find($node_id);

        if ($node === null) {
            return ResponseHelper::error($response, 'Node not found.');
        }

        if ($node->type === 0) {
            return ResponseHelper::error($response, 'Node is not enabled.');
        }

        $custom_config = json_decode($node->custom_config, true, JSON_UNESCAPED_SLASHES);

        $custom_config['enable_vless'] = $node->enable_vless == true ? 'true' : 'false';
        if ($node->enable_vless && $node->reality_opts != '{}') {
                $reality = json_decode($node->reality_opts, true);
                $custom_config["enable_reality"] = $reality["enable_reality"];
                if ($custom_config["enable_reality"] == true) {
                    $newReality = json_encode([
                        "dest" => $reality["reality_opts"]["Dest"],
                        "proxy_protocol_ver" => $reality["reality_opts"]["ProxyProtocolVer"],
                        "server_names" => $reality["reality_opts"]["ServerNames"],
                        "private_key" => $reality["reality_opts"]["private_key"],
                        "min_client_ver" => $reality["reality_opts"]["MinClientVer"],
                        "max_client_ver" => $reality["reality_opts"]["MaxClientVer"],
                        "max_time_diff" => $reality["reality_opts"]["MaxTimeDiff"],
                        "short_ids" => $reality["reality_opts"]["ShortIds"],
                    ]);

                    $custom_config['reality-opts'] = json_decode($newReality, true);
                }
        }
        if ($node->sort === 3) {
            $port = $custom_config["offset_port_node"];
            if ($port === "") {
                return $response->withJson([
                    'ret' => 0,
                    'data' => 'offset_port_node must set.',
                ]);
            }
            $port += 1;
            $custom_config["route_dns"]["socks"]["username"] = "smartdns-socks-id-" . $node->id;
            $custom_config["route_dns"]["socks"]["password"] = $node->password;
            $custom_config["route_dns"]["socks"]["address"] = $node->server . ":" . $port;
        }



        $data = [
            'node_speedlimit' => $node->node_speedlimit,
            'sort' => $node->sort,
            'server' => $node->server,
            'custom_config' => $custom_config,
            'type' => 'SSPanel-UIM',
            'version' => VERSION,
        ];

        return ResponseHelper::successWithDataEtag($request, $response, $data);
    }
}

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
            $ids->created_at = time();
            $ids->updated_at = $item['updated_at'];
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
        $report->created_at = time();
        $report->save();

        return $response->withJson([
            'ret' => 1,
            'data' => 'ok',
        ]);
    }

    public function getInfo(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node_id = $args['id'];
        $node = Node::find($node_id);

        if ($node === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'Node not found.',
            ]);
        }

        $custom_config = json_decode($node->custom_config, true, JSON_UNESCAPED_SLASHES);
        
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
            'node_group' => $node->node_group,
            'node_class' => $node->node_class,
            'node_speedlimit' => $node->node_speedlimit,
            'traffic_rate' => $node->traffic_rate,
            'sort' => $node->sort,
            'server' => $node->server,
            'custom_config' => $custom_config,
            'type' => 'SSPanel-UIM',
            'version' => VERSION,
        ];

        return ResponseHelper::successWithDataEtag($request, $response, [
            'ret' => 1,
            'data' => $data,
        ]);
    }
}

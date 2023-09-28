<?php

declare(strict_types=1);

namespace App\Controllers\WebAPI;

use App\Controllers\BaseController;
use App\Models\Node;
use App\Models\StreamMedia;
use App\Models\SharedAccount;
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
        foreach($details as $item) { //foreach element in $arr
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
                'data' => 'Node not found.',
            ]);
        }

        $data = [
            'node_group' => $node->node_group,
            'node_class' => $node->node_class,
            'node_speedlimit' => $node->node_speedlimit,
            'traffic_rate' => $node->traffic_rate,
            'mu_only' => 0,
            'sort' => $node->sort,
            'server' => $node->server,
            'custom_config' => json_decode($node->custom_config, true, JSON_UNESCAPED_SLASHES),
            'type' => 'SSPanel-UIM',
            'version' => VERSION,
        ];

        return ResponseHelper::successWithDataEtag($request, $response, [
            'ret' => 1,
            'data' => $data,
        ]);
    }
}

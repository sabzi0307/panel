<?php

declare(strict_types=1);

namespace App\Services\Subscribe;

use App\Models\Config;
use App\Services\Subscribe;
use function base64_encode;
use function json_decode;
use function json_encode;
use const PHP_EOL;

final class V2Ray extends Base
{
    public function getContent($user): string
    {
        $links = '';
        //判断是否开启V2Ray订阅
        if (! Config::obtain('enable_v2_sub')) {
            return $links;
        }

        $nodes_raw = Subscribe::getUserNodes($user);

        foreach ($nodes_raw as $node_raw) {
            $node_custom_config = json_decode($node_raw->custom_config, true);

            if ((int) $node_raw->sort === 11) {
                $v2_port = $node_custom_config['offset_port_user'] ?? ($node_custom_config['offset_port_node'] ?? 443);
                $security = $node_custom_config['security'] ?? 'none';
                $network = $node_custom_config['network'] ?? '';
                $pbk = $node_custom_config['pbk'] ?? '';
                $flow = $node_custom_config['flow'] ?? '';
				// $transit_address = $node_custom_config['transit_address'] ?? '';
				// $transit_port = $node_custom_config['transit_port'] ?? '';
                $header = $node_custom_config['header'] ?? ['type' => 'none'];
                $header_type = $header['type'] ?? '';
                $host = $node_custom_config['host'] ?? $node_custom_config['header']['request']['headers']['Host'][0] ?? '';
                $path = $node_custom_config['header']['request']['path'][0] ?? $node_custom_config['path'] ?? '/';
                $client_fingerprint = $node_custom_config['client_fingerprint'] ?? 'chrome';
                
                $v2rayn_array = [
                    'v' => '2',
                    'ps' => $node_raw->name,
                    'add' => $node_raw->server,
                    'port' => $v2_port,
                    'id' => $user->uuid,
                    'aid' => 0,
                    'fp' => $client_fingerprint,
                    'net' => $network,
                    'type' => $header_type,
                    'host' => $host,
                    'path' => $path,
                    'tls' => $security,
                    'sni' => $host,
                ];

                if (($node_custom_config['enable_vless'] ?? '0') === '1'){
					$links .= 'vless://' . $user->uuid . '@' . $node_raw->server . ':' . $v2_port . '?encryption=none&flow=' . $flow . '&security=' . $security . '&sni=' . $host . '&fp=' . $client_fingerprint . '&pbk=' . $pbk . '&type=' . $network . '&headerType=' . $header_type . '#' . $node_raw->name . PHP_EOL;
                } else {
                    $links .= 'vmess://' . base64_encode(json_encode($v2rayn_array)) . PHP_EOL;
                }

            }
        }

        return $links;
    }
}

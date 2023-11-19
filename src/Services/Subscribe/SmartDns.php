<?php

declare(strict_types=1);

namespace App\Services\Subscribe;

use App\Services\Subscribe;
use function array_merge;
use function json_decode;
use function yaml_emit;
use const YAML_UTF8_ENCODING;

final class SmartDns extends Base
{
    public function getContent($user): string
    {
        $nodes = [];
        $nodes_raw = Subscribe::getSubNodes($user);

        foreach ($nodes_raw as $node_raw) {
            $node_custom_config = json_decode($node_raw->custom_config, true);

            switch ((int) $node_raw->sort) {
                case 3:
                    $dns = $node_custom_config['dns'] ?? null;
                    $doh = $node_custom_config['doh'] ?? null;
                    $dot = $node_custom_config['dot'] ?? null;
                    $doq = $node_custom_config['doq'] ?? null;
                    $dtls = $node_custom_config['dtls'] ?? null;

                    $node = [
                        'id' => $node_raw->id,
                        'name' => $node_raw->name,
                        'dns' => $dns,
                        'doh' => $doh,
                        'dot' => $dot,
                        'doq' => $doq,
                        'dtls' => $dtls,
                    ];

                    break;
                default:
                    $node = [];
                    break;
            }

            if ($node === []) {
                continue;
            }

            $nodes[] = $node;
        }

        return json_encode($nodes);
    }
}

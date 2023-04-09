<?php

declare(strict_types=1);

namespace App\Models;

use function array_key_exists;
use function count;
use function time;

final class Node extends Model
{
    protected $connection = 'default';
    protected $table = 'node';

    protected $casts = [
        'traffic_rate' => 'float',
        'node_heartbeat' => 'int',
    ];

    /**
     * 节点是否显示和隐藏
     */
    public function type(): string
    {
        return $this->type ? 'نشان دادن' : 'پنهان شدن';
    }

    /**
     * 节点类型
     */
    public function sort(): string
    {
        return match ($this->sort) {
            0 => 'Shadowsocks',
            11 => 'V2Ray',
            14 => 'Trojan',
            default => 'ناشناخته',
        };
    }

    /**
     * 节点最后活跃时间
     */
    public function nodeHeartbeat(): string
    {
        return date('Y-m-d H:i:s', $this->node_heartbeat);
    }

    /**
     * Get node online status
     *
     * @return int 0 = new node OR -1 = offline OR 1 = online
     */
    public function getNodeOnlineStatus(): int
    {
        // Type 9 or heartbeat 0
        if ($this->node_heartbeat === 0) {
            return 0;
        }

        return $this->node_heartbeat + 300 > time() ? 1 : -1;
    }

    /**
     * 获取节点速率文本信息
     */
    public function getNodeSpeedlimit(): string
    {
        if ($this->node_speedlimit === 0.0) {
            return '0';
        }
        if ($this->node_speedlimit >= 1024.00) {
            return round($this->node_speedlimit / 1024.00, 1) . 'Gbps';
        }

        return $this->node_speedlimit . 'Mbps';
    }

    /**
     * 节点流量已耗尽
     */
    public function isNodeTrafficOut(): bool
    {
        return ! ($this->node_bandwidth_limit === 0 || $this->node_bandwidth < $this->node_bandwidth_limit);
    }

    /**
     * 更新节点 IP
     */
    public function changeNodeIp(string $server_name): void
    {
        $result = dns_get_record($server_name, DNS_A + DNS_AAAA);
        $dns = [];

        if ($result !== false && count($result) > 0) {
            $dns = $result[0];
        }

        if (array_key_exists('ip', $dns)) {
            $ip = $dns['ip'];
        } elseif (array_key_exists('ipv6', $dns)) {
            $ip = $dns['ipv6'];
        } else {
            $ip = $server_name;
        }

        $this->node_ip = $ip;
    }
}

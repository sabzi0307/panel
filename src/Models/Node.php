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
        'mu_only' => 'int',
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
            1 => 'ShadowsocksR',
            11 => 'V2Ray سرور',
            14 => 'Trojan',
            default => 'سیستم رزرو شده',
        };
    }

    /**
     * Single port multi-user enable type
     */
    public function muOnly(): string
    {
        return match ($this->mu_only) {
            -1 => 'فقط پورت های معمولی فعال هستند',
            0 => 'همزیستی چند کاربر در یک پورت واحد و پورت های مشترک',
            1 => 'تنها چند کاربر تک پورت را فعال کنید',
            default => 'نوع خطا',
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
        if ($this->node_heartbeat === 0 || $this->sort === 9) {
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
     * 节点是在线的
     */
    public function isNodeOnline(): ?bool
    {
        if ($this->node_heartbeat === 0) {
            return false;
        }
        return $this->node_heartbeat > time() - 300;
    }

    /**
     * 节点流量已耗尽
     */
    public function isNodeTrafficOut(): bool
    {
        return ! ($this->node_bandwidth_limit === 0 || $this->node_bandwidth < $this->node_bandwidth_limit);
    }

    /**
     * 节点是可用的，即流量未耗尽并且在线
     */
    public function isNodeAccessable(): bool
    {
        return $this->isNodeTrafficOut() === false && $this->isNodeOnline() === true;
    }

    /**
     * 更新节点 IP
     */
    public function changeNodeIp(string $server_name): void
    {
        $result = dns_get_record($server_name, DNS_A + DNS_AAAA);
        $dns = [];
        if (count($result) > 0) {
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

    /**
     * 获取节点 IP
     */
    public function getNodeIp(): string
    {
        $node_ip_str = $this->node_ip;
        $node_ip_array = explode(',', $node_ip_str);
        return $node_ip_array[0];
    }
}

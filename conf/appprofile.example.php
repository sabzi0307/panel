<?php

declare(strict_types=1);

$_ENV['V2RayJson_Config'] = [
    'log' => [
        'error' => [
            'level' => 'error',
            'type' => 'console',
        ],
        'access' => [
            'type' => 'none',
        ],
    ],
    'dns' => [
        'nameServer' => [
            [
                'address' => '1.1.1.1',
            ],
            [
                'address' => '1.0.0.1',
            ],
        ],
    ],
    'inbounds' => [
        [
            'protocol' => 'socks',
            'settings' => [
                'udpEnabled' => true,
                'address' => '127.0.0.1',
                'packetEncoding' => 'packet',
            ],
            'port' => 7892,
            'listen' => '127.0.0.1',
        ],
        [
            'protocol' => 'http',
            'settings' => [],
            'port' => 7893,
            'listen' => '127.0.0.1',
        ],
    ],
    'outbounds' => [],
];

#Cloudflare
$_ENV['Internet_Service_Providers'] = array(
    array(
        'AsName' => "Mobin Net Communication Company",
        'AsNum' => array("47330", "50810"),
        "Name" => "مبین‌نت",
    ),
    array(
        'AsName' => "Andishe SABZ Khazar Co P.j.s",
        'AsNum' => array("39308"),
        "Name" => "اندیشه‌سبز",
    ),
    array(
        'AsName' => "Mobile Communication Company of Iran PLC",
        'AsNum' => array("197207"),
        "Name" => "همراه‌اول",
    ),
    array(
        'AsName' => "Iran Cell Service and Communication Company",
        'AsNum' => array("44244"),
        "Name" => "ایرانسل",
    ),
    array(
        'AsName' => "Iran Telecommunication Company PJS",
        'AsNum' => array("58224"),
        "Name" => "مخابرات",
    ),
    array(
        'AsName' => "Rightel Communication Service Company PJS",
        'AsNum' => array("197206", "57218"),
        "Name" => "رایتل",
    ),
    array(
        'AsName' => "Aria Shatel Company Ltd",
        'AsNum' => array("31549"),
        "Name" => "شاتل",
    ),
    array(
        'AsName' => "Pars Online PJS",
        'AsNum' => array("16322", "60976"),
        "Name" => "پارس‌آنلاین",
    ),
    array(
        'AsName' => "Asiatech Data Transmission company",
        'AsNum' => array("43754", "51433", "211421"),
        "Name" => "آسیاتک",
    ),
    array(
        'AsName' => "Afranet",
        'AsNum' => array("25184"),
        "Name" => "افرانت",
    ),
    array(
        'AsName' => "Respina Networks & Beyond PJSC",
        'AsNum' => array("42337", "205207"),
        "Name" => "رسپینا",
    ),
    array(
        'AsName' => "Rayaneh Danesh Golestan Complex P.J.S. Co.",
        'AsNum' => array("42440"),
        "Name" => "های‌وب",
    ),
    array(
        'AsName' => "Pishgaman Toseeh Ertebatat Company",
        'AsNum' => array("3263", "34918", "49100", "56660", "57755", "57831", "58216", "59481", "208828"),
        "Name" => "پیشگامان",
    ),
    array(
        'AsName' => "Farabord Dadeh Haye Iranian Co.",
        'AsNum' => array("206065"),
        "Name" => "زیتل",
    ),
    array(
        'AsName' => "Tose'h Fanavari Ertebabat Pasargad Arian Co. PJS",
        'AsNum' => array("24631", "43343", "203558"),
        "Name" => "آراکس",
    ),
    array(
        'AsName' => "Kish Cell Pars Co. (PJS)",
        'AsNum' => array("209596"),
        "Name" => "سامانتل",
    ),
    array(
        'AsName' => "Fanava Group",
        'AsNum' => array("41881", "60637"),
        "Name" => "فن‌آوا",
    )
);

$_ENV['SingBox_Config'] = [
    'log' => [
        'level' => 'error',
    ],
    'dns' => [
        'servers' => [
            [
                'tag' => 'local',
                'address' => 'local',
            ],
        ],
        'rules' => [
            [
                'outbound' => 'any',
                'server' => 'local',
            ],
        ],
        'final' => 'local',
        'strategy' => 'prefer_ipv6',
    ],
    'inbounds' => [
        [
            'type' => 'tun',
            'inet4_address' => '172.19.0.1/30',
            'auto_route' => true,
            'strict_route' => true,
            'endpoint_independent_nat' => true,
            'udp_timeout' => 60,
            'platform' => [
                'http_proxy' => [
                    'enabled' => true,
                    'server' => '127.0.0.1',
                    'server_port' => 8100,
                ],
            ],
            'sniff' => true,
        ],
        [
            'type' => 'mixed',
            'listen' => '127.0.0.1',
            'listen_port' => 8100,
            'sniff' => true,
            'domain_strategy' => 'prefer_ipv4',
        ],
    ],
    'outbounds' => [
        [
            'type' => 'selector',
            'tag' => 'default',
            'outbounds' => [],
        ],
        [
            'type' => 'direct',
            'tag' => 'direct',
        ],
        [
            'type' => 'block',
            'tag' => 'block',
        ],
    ],
    'route' => [
        'rules' => [
            [
                'protocol' => 'quic',
                'port' => 443,
                'outbound' => 'block'
            ],
            [
                'clash_mode' => 'Direct',
                'outbound' => 'direct',
            ],
            [
                'clash_mode' => 'Rule',
                'outbound' => 'default',
            ],
            [
                'clash_mode' => 'Global',
                'outbound' => 'default',
            ],
            [
                'protocol' => 'stun',
                'outbound' => 'block',
            ],
[
                'ip_is_private' => true,
                'outbound' => 'direct',
            ],
            [
                'rule_set' => [
                    'geosite-category-ads-all',
                    'geosite-malware',
                    'geosite-phishing',
                    'geosite-cryptominers',
                    'geoip-malware',
                    'geoip-phishing'
                ],
                'outbound' => 'block',
            ],
            [
                'rule_set' => 'geoip-ir',
                'outbound' => 'direct',
            ],
            [
                'rule_set' => 'geosite-ir',
                'outbound' => 'direct',
            ],
        ],
        'rule_set' => [
            [
                'tag' => 'geoip-ir',
                'type' => 'remote',
                'format' => 'binary',
                'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-sing-box-rules@rule-set/geoip-ir.srs',
                'download_detour' => 'direct',
            ],
            [
                'tag' => 'geosite-ir',
                'type' => 'remote',
                'format' => 'binary',
                'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-sing-box-rules@rule-set/geosite-ir.srs',
                'download_detour' => 'direct',
            ],
            [
                'tag' => 'geosite-category-ads-all',
                'type' => 'remote',
                'format' => 'binary',
                'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-sing-box-rules@rule-set/geosite-category-ads-all.srs',
                'download_detour' => 'direct',
            ],
            [
                'tag' => 'geosite-malware',
                'type' => 'remote',
                'format' => 'binary',
                'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-sing-box-rules@rule-set/geosite-malware.srs',
                'download_detour' => 'direct',
            ],
            [
                'tag' => 'geosite-phishing',
                'type' => 'remote',
                'format' => 'binary',
                'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-sing-box-rules@rule-set/geosite-phishing.srs',
                'download_detour' => 'direct',
            ],
            [
                'tag' => 'geosite-cryptominers',
                'type' => 'remote',
                'format' => 'binary',
                'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-sing-box-rules@rule-set/geosite-cryptominers.srs',
                'download_detour' => 'direct',
            ],
            [
                'tag' => 'geoip-malware',
                'type' => 'remote',
                'format' => 'binary',
                'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-sing-box-rules@rule-set/geoip-malware.srs',
                'download_detour' => 'direct',
            ],
            [
                'tag' => 'geoip-phishing',
                'type' => 'remote',
                'format' => 'binary',
                'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-sing-box-rules@rule-set/geoip-phishing.srs',
                'download_detour' => 'direct',
            ],
        ],
        'auto_detect_interface' => true,
    ],
    'experimental' => [
        'cache_file' => [
            'enabled' => true,
            'cache_id' => '',
        ],
        'clash_api' => [
            'external_controller' => '127.0.0.1:9090',
        ],
    ],
];

$_ENV['Clash_Config'] = [
    'port' => 7890,
    'socks-port' => 7891,
    'allow-lan' => false,
    'mode' => 'Rule',
    'ipv6' => true,
    'log-level' => 'error',
    'external-controller' => '0.0.0.0:9090',
];

$_ENV['Clash_Group_Indexes'] = [0, 1, 2, 8];

$_ENV['Clash_Group_Config'] = [
    'rule-providers' => [
        'ir' => [
            'type' => 'http',
            'format' => 'yaml',
            'behavior' => 'domain',
            'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-clash-rules/releases/latest/download/ir.yaml',
            'path' => './ruleset/ir.yaml',
            'interval' => 86400
        ],
        'ads' => [
            'type' => 'http',
            'format' => 'yaml',
            'behavior' => 'domain',
            'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-clash-rules/releases/latest/download/ads.yaml',
            'path' => './ruleset/ads.yaml',
            'interval' => 86400
        ],
        'malware' => [
            'type' => 'http',
            'format' => 'yaml',
            'behavior' => 'domain',
            'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-clash-rules/releases/latest/download/malware.yaml',
            'path' => './ruleset/malware.yaml',
            'interval' => 86400
        ],
        'phishing' => [
            'type' => 'http',
            'format' => 'yaml',
            'behavior' => 'domain',
            'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-clash-rules/releases/latest/download/phishing.yaml',
            'path' => './ruleset/phishing.yaml',
            'interval' => 86400
        ],
        'cryptominers' => [
            'type' => 'http',
            'format' => 'yaml',
            'behavior' => 'domain',
            'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-clash-rules/releases/latest/download/cryptominers.yaml',
            'path' => './ruleset/cryptominers.yaml',
            'interval' => 86400
        ],
        'apps' => [
            'type' => 'http',
            'format' => 'yaml',
            'behavior' => 'classical',
            'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-clash-rules/releases/latest/download/apps.yaml',
            'path' => './ruleset/apps.yaml',
            'interval' => 86400
        ],
        'ircidr' => [
            'type' => 'http',
            'format' => 'yaml',
            'behavior' => 'ipcidr',
            'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-clash-rules/releases/latest/download/ircidr.yaml',
            'path' => './ruleset/ircidr.yaml',
            'interval' => 86400
        ],
        'private' => [
            'type' => 'http',
            'format' => 'yaml',
            'behavior' => 'ipcidr',
            'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-clash-rules/releases/latest/download/private.yaml',
            'path' => './ruleset/private.yaml',
            'interval' => 86400
        ],
        'arvancloud' => [
            'type' => 'http',
            'format' => 'yaml',
            'behavior' => 'ipcidr',
            'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-clash-rules/releases/latest/download/arvancloud.yaml',
            'path' => './ruleset/arvancloud.yaml',
            'interval' => 86400
        ],
        'derakcloud' => [
            'type' => 'http',
            'format' => 'yaml',
            'behavior' => 'ipcidr',
            'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-clash-rules/releases/latest/download/derakcloud.yaml',
            'path' => './ruleset/derakcloud.yaml',
            'interval' => 86400
        ],
        'iranserver' => [
            'type' => 'http',
            'format' => 'yaml',
            'behavior' => 'ipcidr',
            'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-clash-rules/releases/latest/download/iranserver.yaml',
            'path' => './ruleset/iranserver.yaml',
            'interval' => 86400
        ],
        'parspack' => [
            'type' => 'http',
            'format' => 'yaml',
            'behavior' => 'ipcidr',
            'url' => 'https://' . $_ENV['jsdelivr_url'] . 'gh/chocolate4u/Iran-clash-rules/releases/latest/download/parspack.yaml',
            'path' => './ruleset/parspack.yaml',
            'interval' => 86400
        ],
        
    ],
    'proxy-groups' => [
        [
            'name' => '🔰 انتخاب سرور',
            'type' => 'select',
            // درج نام سرور
            'proxies' => [
                '♻️ انتخاب هوشمند',
                '🎯 اتصال مستقیم',
            ],
        ],
        [
            'name' => '♻️ انتخاب هوشمند',
            'type' => 'url-test',
            'url' => 'https://www.facebook.com/',
            'interval' => 300,
            // درج نام سرور
            'proxies' => [],
        ],
        [
            'name' => '🎥 NETFLIX',
            'type' => 'select',
            // درج نام سرور
            'proxies' => [
                '🔰 انتخاب سرور',
                '♻️ انتخاب هوشمند',
                '🎯 اتصال مستقیم',
            ],
        ],
        [
            'name' => '⛔️ تبلیغات',
            'type' => 'select',
            'proxies' => [
                '🛑 مسدود',
                '🎯 اتصال مستقیم',
                '🔰 انتخاب سرور',
            ],
        ],
        [
            'name' => '🚫 فیشینگ و مخرب',
            'type' => 'select',
            'proxies' => [
                '🛑 مسدود',
                '🎯 اتصال مستقیم',
                '🔰 انتخاب سرور',
            ],
        ],
        [
            'name' => '🇮🇷 سایت های ایرانی',
            'type' => 'select',
            'proxies' => [
                '🎯 اتصال مستقیم',
                '♻️ انتخاب هوشمند',
                '🔰 انتخاب سرور',
            ],
        ],
        [
            'name' => '🎯 اتصال مستقیم',
            'type' => 'select',
            'proxies' => [
                'DIRECT',
            ],
        ],
        [
            'name' => '🛑 مسدود',
            'type' => 'select',
            'proxies' => [
                'REJECT',
                'DIRECT',
            ],
        ],
        [
            'name' => '🐟 اتصال پراکسی',
            'type' => 'select',
            // درج نام سرور
            'proxies' => [
                '♻️ انتخاب هوشمند',
                '🔰 انتخاب سرور',
                '🎯 اتصال مستقیم',
            ],
        ],
    ],
    'rules' => [
        'RULE-SET,private,DIRECT,no-resolve',
        'RULE-SET,ads,⛔️ تبلیغات',
        'RULE-SET,malware,🚫 فیشینگ و مخرب',
        'RULE-SET,phishing,🚫 فیشینگ و مخرب',
        'RULE-SET,cryptominers,🚫 فیشینگ و مخرب',
        'RULE-SET,ir,🇮🇷 سایت های ایرانی',
        'RULE-SET,ircidr,🇮🇷 سایت های ایرانی',
        'RULE-SET,arvancloud,🇮🇷 سایت های ایرانی',
        'RULE-SET,derakcloud,🇮🇷 سایت های ایرانی',
        'RULE-SET,iranserver,🇮🇷 سایت های ایرانی',
        'RULE-SET,parspack,🇮🇷 سایت های ایرانی',
        'MATCH,🐟 اتصال پراکسی',
    ],
];

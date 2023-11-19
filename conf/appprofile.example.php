<?php

declare(strict_types=1);

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
            [
                'tag' => 'cloudflare',
                'address' => 'tcp://1.1.1.1',
                'address_resolver' => 'local',
                'strategy' => 'prefer_ipv4',
            ],
        ],
        'rules' => [
            [
                'clash_mode' => 'Direct',
                'server' => 'local',
            ],
            [
                'clash_mode' => 'Global',
                'server' => 'cloudflare',
            ],
            [
                'geosite' => [
                    'ir',
                ],
                'server' => 'local',
            ],
        ],
        'final' => 'cloudflare',
        'strategy' => 'prefer_ipv4',
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
        [
            'type' => 'dns',
            'tag' => 'dns',
        ],
    ],
    'route' => [
        'geoip' => [
            'download_url' => 'https://github.com/Chocolate4U/Iran-sing-box-rules/releases/latest/download/geoip.db'
        ],
        'geosite' => [
            'download_url' => 'https://github.com/Chocolate4U/Iran-sing-box-rules/releases/latest/download/geosite.db'
        ],
        'rules' => [
            [
                'protocol' => 'dns',
                'outbound' => 'dns',
            ],
            [
                'network' => 'udp',
                'port' => 53,
                'outbound' => 'dns',
            ],
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
                'clash_mode' => 'Global',
                'outbound' => 'default',
            ],
            [
                'protocol' => 'stun',
                'outbound' => 'block',
            ],
            [
                'geosite' => 'ir',
                'outbound' => 'direct',
            ],
            [
                'geoip' => [
                    "ir",
                    "private",
                    "arvancloud",
                    "derakcloud",
                    "iranserver",
                    "parspack",
                ],
                'outbound' => 'direct',
            ],
            [
                'geosite' => [
                    "category-ads-all",
                    "malware",
                    "phishing",
                    "cryptominers"
                ],
                'outbound' => 'block',
            ],
            [
                'geoip' => [
                    "malware",
                    "phishing"
                ],
                'outbound' => 'block',
            ],
        ],
        'auto_detect_interface' => true,
    ],
    'experimental' => [
        'clash_api' => [
            'store_mode' => true,
            'cache_id' => '',
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

$_ENV['Clash_Group_Indexes'] = [0, 1, 2, 5, 7, 8, 9, 12];

$_ENV['Clash_Group_Config'] = [
    'geox-url' => [
        'geoip' => 'https://github.com/chocolate4u/Iran-v2ray-rules/releases/latest/download/geoip.dat',
        'geosite' => 'https://github.com/chocolate4u/Iran-v2ray-rules/releases/latest/download/geosite.dat',
        'mmdb' => 'https://github.com/chocolate4u/Iran-clash-rules/releases/latest/download/geoip.metadb'
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
        'GEOIP,private,DIRECT,no-resolve',
        'GEOSITE,category-ads-all,⛔️ تبلیغات',
        'GEOSITE,malware,🚫 فیشینگ و مخرب',
        'GEOSITE,phishing,🚫 فیشینگ و مخرب',
        'GEOSITE,cryptominers,🚫 فیشینگ و مخرب',
        'GEOIP,malware,🚫 فیشینگ و مخرب',
        'GEOIP,phishing,🚫 فیشینگ و مخرب',
        'GEOSITE,ir,🇮🇷 سایت های ایرانی',
        'GEOIP,ir,🇮🇷 سایت های ایرانی',
        'GEOIP,arvancloud,🇮🇷 سایت های ایرانی',
        'GEOIP,derakcloud,🇮🇷 سایت های ایرانی',
        'GEOIP,iranserver,🇮🇷 سایت های ایرانی',
        'GEOIP,parspack,🇮🇷 سایت های ایرانی',
        'MATCH,🐟 اتصال پراکسی',
    ],
];

<?php

declare(strict_types=1);



$_ENV['Clash_Config'] = [
    'port' => 7890,
    'socks-port' => 7891,
    'allow-lan' => false,
    'mode' => 'Global',
    'log-level' => 'error',
    'external-controller' => '0.0.0.0:9090',
];

$_ENV['Clash_Group_Indexes'] = [0, 1, 2, 5, 7, 8, 9, 12];

$_ENV['Clash_Group_Config'] = [
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
            'name' => '⛔️ مسدود کردن تبلیغات',
            'type' => 'select',
            'proxies' => [
                '🛑 مسدود',
                '🎯 اتصال مستقیم',
                '🔰 انتخاب سرور',
            ],
        ],
        [
            'name' => '🚫 هواپیماربایی عملیاتی',
            'type' => 'select',
            'proxies' => [
                '🛑 مسدود',
                '🎯 اتصال مستقیم',
                '🔰 انتخاب سرور',
            ],
        ],
        [
            'name' => '🌍 رسانه های خارجی',
            'type' => 'select',
            // درج نام سرور
            'proxies' => [
                '🔰 انتخاب سرور',
                '♻️ انتخاب هوشمند',
                '🎯 اتصال مستقیم',
            ],
        ],
        [
            'name' => '🌏 رسانه های داخلی',
            'type' => 'select',
            'proxies' => [
                '🎯 اتصال مستقیم',
                '🔰 انتخاب سرور',
            ],
        ],
        [
            'name' => 'Ⓜ️ سرویس های مایکروسافت',
            'type' => 'select',
            // درج نام سرور
            'proxies' => [
                '🎯 اتصال مستقیم',
                '🔰 انتخاب سرور',
            ],
        ],
        [
            'name' => '📲 تلگرام',
            'type' => 'select',
            // درج نام سرور
            'proxies' => [
                '🔰 انتخاب سرور',
                '🎯 اتصال مستقیم',
            ],
        ],
        [
            'name' => '🍎 سرویس های اپل',
            'type' => 'select',
            // درج نام سرور
            'proxies' => [
                '🔰 انتخاب سرور',
                '🎯 اتصال مستقیم',
                '♻️ انتخاب هوشمند',
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
                '🔰 انتخاب سرور',
                '🎯 اتصال مستقیم',
                '♻️ انتخاب هوشمند',
            ],
        ],
    ],

];

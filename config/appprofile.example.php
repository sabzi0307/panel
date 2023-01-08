<?php

declare(strict_types=1);

$_ENV['Clash_Config'] = [
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
            'proxies' => [
            ],
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
    'rule-providers' => [
        'iran' => [
            'type: http',
            'behavior: classical',
            'url: "https://proxyproviderip/public/clients/rules/iran-sites.yml',
            'path: ./ruleset/iran.yaml',
            'interval: 432000',
        ],
        'blocked' => [
            'type: http',
            'behavior: classical',
            'url: "https://proxyproviderip/public/clients/rules/blocked-sites.yml',
            'path: ./ruleset/blocked.yaml',
            'interval: 432000',
        ],
        'tmpblocked' => [
            'type: http',
            'behavior: classical',
            'url: "https://proxyproviderip/public/clients/rules/tmp-blocked-sites.yml',
            'path: ./ruleset/blocked.yaml',
            'interval: 432000',
        ],
        'open' => [
            'type: http',
            'behavior: classical',
            'url: "https://proxyproviderip/public/clients/rules/open-sites.yml',
            'path: ./ruleset/open.yaml',
            'interval: 432000',
        ],
        'ads' => [
            'type: http',
            'behavior: classical',
            'url: "https://proxyproviderip/public/clients/rules/ads-sites.yml',
            'path: ./ruleset/ads.yaml',
            'interval: 432000',
        ],
        'apple' => [
            'type: http',
            'behavior: classical',
            'url: "https://proxyproviderip/public/clients/rules/apple.yml',
            'path: ./ruleset/apple.yaml',
            'interval: 432000',
        ],
        'microsoft' => [
            'type: http',
            'behavior: classical',
            'url: "https://proxyproviderip/public/clients/rules/microsoft.yml',
            'path: ./ruleset/microsoft.yaml',
            'interval: 432000',
        ],
        'netflix' => [
            'type: http',
            'behavior: classical',
            'url: "https://proxyproviderip/public/clients/rules/netflix.yml',
            'path: ./ruleset/netflix.yaml',
            'interval: 432000',
        ],
        'irbroadcaste' => [
            'type: http',
            'behavior: classical',
            'url: "https://proxyproviderip/public/clients/rules/irbroadcaste.yml',
            'path: ./ruleset/irbroadcaste.yaml',
            'interval: 432000',
        ],
        'broadcaste' => [
            'type: http',
            'behavior: classical',
            'url: "https://proxyproviderip/public/clients/rules/broadcaste.yml',
            'path: ./ruleset/broadcaste.yaml',
            'interval: 432000',
        ],
        'telegram' => [
            'type: http',
            'behavior: classical',
            'url: "https://proxyproviderip/public/clients/rules/telegram.yml',
            'path: ./ruleset/telegram.yaml',
            'interval: 432000',
        ],
    ],
    'rules' => [
        '- RULE-SET,tmpblocked,🔰 انتخاب سرور',
        '- RULE-SET,blocked,🔰 انتخاب سرور',
        '- RULE-SET,ads,⛔️ مسدود کردن تبلیغات',
        '- RULE-SET,irbroadcaste,🌏 رسانه های داخلی',
        '- RULE-SET,iran,🎯 اتصال مستقیم',
        '- RULE-SET,open,🎯 اتصال مستقیم',
        '- RULE-SET,telegram,📲 تلگرام',
        '- RULE-SET,apple,🍎 سرویس های اپل',
        '- RULE-SET,microsoft,Ⓜ️ سرویس های مایکروسافت',
        '- RULE-SET,netflix,🎥 NETFLIX',
        '- RULE-SET,broadcaste,🌍 رسانه های خارجی',
        '- MATCH,🐟 اتصال پراکسی',
    ],
];

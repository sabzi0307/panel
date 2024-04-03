<?php

//basic settings--------------------------------------------------------------------------------------------
$_ENV['key']        = 'ChangeMe';                     //Cookie encryption key, please be sure to modify this key to a random string
$_ENV['pwdMethod']  = 'bcrypt';                       //Password encryption optional md5, sha256, bcrypt, argon2i, argon2id
$_ENV['salt']       = '';                             //Recommended for md5/sha256， bcrypt/argon2i/argon2id will ignore this

$_ENV['debug']      = false;                          //debug mode switch，The production environment should be kept as false
$_ENV['appName']    = 'SSPanel-UIM';                  // Site name
$_ENV['baseUrl']    = 'https://example.com';          // site address

// WebAPI
$_ENV['webAPI']      = true;               //是否开启WebAPI功能
$_ENV['webAPIUrl']   = $_ENV['baseUrl'];   //WebAPI地址，如需和站点名称相同，请不要修改
$_ENV['muKey']      = 'ChangeMe';                     //WebAPI Key, used for communication between the node server and the panel，Be sure to modify this key to a random string
$_ENV['checkNodeIp'] = true;               //是否webapi验证节点ip

//database settings--------------------------------------------------------------------------------------------
// db_host|db_socket Choose one of the two, if set db_socket then db_host Will be ignored, please leave blank.
// db_host example: localhost (resolvable hostname), 127.0.0.1（IP address）
// db_socket example：/var/run/mysqld/mysqld.sock（Absolute address is required
$_ENV['db_host']      = 'ss_db';
$_ENV['db_socket']    = '';
$_ENV['db_database']  = 'sspanel';           //Database name
$_ENV['db_username']  = 'sspanel';              //database username
$_ENV['db_password']  = 'sspanel';           //The password corresponding to the username
$_ENV['db_port']      = '3306';              //database port
# Read and write separation related configurations
$_ENV['enable_db_rw_split'] = false;         // turn on read-write separation
$_ENV['read_db_hosts']      = [''];          // Slave library address, multiple configurable
$_ENV['write_db_host']      = '';            // Main library address
#advanced
$_ENV['db_charset']   = 'utf8mb4';
$_ENV['db_collation'] = 'utf8mb4_unicode_ci';
$_ENV['db_prefix']    = '';

//Redis设置-------------------------------------------------------------------------------------------
$_ENV['redis_host']            = 'redis';    //Redis地址，使用unix domain socket时填写文件路径
$_ENV['redis_port']            = 6379;           //Redis端口，使用unix domain socket时填写-1
$_ENV['redis_connect_timeout'] = 2.0;            //Redis连接超时时间，单位秒
$_ENV['redis_read_timeout']    = 8.0;            //Redis读取超时时间，单位秒
$_ENV['redis_username']        = '';             //Redis用户名，留空则不使用用户名连接
$_ENV['redis_password']        = '';             //Redis密码，留空则无密码
$_ENV['redis_ssl']             = false;          //是否使用SSL连接Redis，如果使用了SSL，那么Redis端口应为Redis实例的TLS端口
$_ENV['redis_ssl_context']     = [];             //使用SSL时的上下文选项，参考 https://www.php.net/manual/zh/context.ssl.php

//Rate Limit设置--------------------------------------------------------------------------------------------
$_ENV['enable_rate_limit']    = true;            //是否开启请求限制
$_ENV['rate_limit_ip']        = 120;             //每分钟每个IP的全局请求限制
$_ENV['rate_limit_sub']       = 30;              //每分钟每个用户的订阅链接请求限制
$_ENV['rate_limit_webapi']    = 600;             //每分钟每个节点WebAPI密钥请求限制
$_ENV['rate_limit_user_api']  = 60;              //每分钟每个用户的API请求限制
$_ENV['rate_limit_admin_api'] = 60;              //每分钟每个管理员的API请求限制

//E-Mail settings--------------------------------------------------------------------------------------------
$_ENV['mail_filter']        = 0;            //0: off; 1: whitelist mode; 2; blacklist mode;
$_ENV['mail_filter_list']   = [];

#advanced
$_ENV['class_expire_reset_traffic'] = 0;            //The traffic value to reset to when the level expires, in GB, if it is less than 0, it will not be reset
$_ENV['enable_kill']                = true;         //allow users to log out of accounts
$_ENV['enable_change_email']        = true;         //allow users to change account email

#Email reminder for insufficient user data allowance
$_ENV['notify_limit_mode']          = false;         //false is closed, per is reminded according to percentage, mb is reminded according to fixed remaining traffic
$_ENV['notify_limit_value']         = 500;           //When the previous item is per, fill in the percentage here; when the previous item is mb, fill in the traffic here

//subscription settings---------------------------------------------------------------------------------------
$_ENV['Subscribe']                  = true;                         //Does this site provide a subscription function?
$_ENV['subUrl']                     = $_ENV['baseUrl'];             //Subscription address, if it needs to be the same as the site name, please do not modify
$_ENV['sub_token_len']              = 16;                           //订阅token长度

//Audit auto-ban settings--------------------------------------------------------------------------------------------
$_ENV['auto_detect_ban_allow_admin'] = true;        // Administrators are not subject to audit restrictions
$_ENV['auto_detect_ban_allow_users'] = [];          // Exception User IDs for Audit Bans
$_ENV['auto_detect_ban_number']      = 30;             // The number of procs needed to enforce a ban in mercy mode
$_ENV['auto_detect_ban_time']        = 60;             // The duration of each ban in mercy mode (minutes)

//node detection-----------------------------------------------------------------------------------------------
#GFW detection
$_ENV['detect_gfw_port']                 = 443;                                                                 //The TCP port opened by all node servers, commonly used is 22 (SSH port)
$_ENV['detect_gfw_url']                  = 'https://check-host.net/check-tcp?host={ip}:{port}&node=ir1.node.check-host.net&node=ir3.node.check-host.net&node=ir5.node.check-host.net&node=ir6.node.check-host.net'; // 'http://example.com:8080/v1/tcping?ip={ip}&port={port}' The URL of the API that detects whether the node is blocked by gfw

#offline detection
$_ENV['enable_detect_offline']           = true;

$_ENV['enable_login_bind_ip']   = true;        //bind the login thread to the IP
$_ENV['enable_login_bind_device'] = true;             //bind the login thread to the device
$_ENV['rememberMeDuration']     = 7;           //Remember the number of days of account duration when logging in
$_ENV['timeZone']               = 'Asia/Tehran';         //Requires a PHP-compatible timezone format
$_ENV['theme']                  = 'tabler';              //Default Theme
$_ENV['locale']                 = 'fa-IR';          //default language
$_ENV['jump_delay']             = 1200;                  //Jump delay, in ms, it is not recommended to be too long
$_ENV['keep_connect']           = false;               // Speed limit to 1Mbps for traffic exhausted users

$_ENV['jsdelivr_url'] = 'fastly.jsdelivr.net'; // cdn.jsdelivr.net / fastly.jsdelivr.net / testingcf.jsdelivr.net


// https://sentry.io for production debugging
$_ENV['sentry_dsn'] = '';

// Maxmind GeoIP2 database
$_ENV['maxmind_license_key'] = 'local';
$_ENV['geoip_locale'] = 'en';

// Large language model powered ticket reply and more
$_ENV['llm_backend'] = 'openai'; // openai/google-ai/huggingface/cf-workers-ai
// OpenAI ChatGPT
$_ENV['openai_api_key'] = '';
$_ENV['openai_model']   = 'gpt-4-turbo-preview';
// Google AI API
$_ENV['google_ai_api_key']  = '';
$_ENV['google_ai_model_id'] = 'gemini-1.5-pro-latest';
// Vertex AI API
$_ENV['vertex_ai_access_token']  = '';
$_ENV['vertex_ai_location'] = 'us-central1';
$_ENV['vertex_ai_model_id'] = 'gemini-1.0-pro';
$_ENV['vertex_ai_project_id'] = '';
// Hugging Face Inference API
$_ENV['huggingface_api_key'] = '';
$_ENV['huggingface_endpoint_url'] = '';
// Cloudflare Workers AI
$_ENV['cf_workers_ai_account_id'] = '';
$_ENV['cf_workers_ai_api_token']  = '';
$_ENV['cf_workers_ai_model_id']   = '@cf/meta/llama-2-7b-chat-int8';
// Anthropic
$_ENV['anthropic_api_key'] = '';
$_ENV['anthropic_model_id'] = 'claude-3-opus-20240229';

// ClientDownload command resolves the restricted use of Github access tokens due to the high frequency of API access
$_ENV['github_access_token'] = '';

// use Cloudflare R2 for clients download
$_ENV['enable_r2_client_download'] = false;
$_ENV['r2_bucket_name'] = '';
$_ENV['r2_account_id'] = '';
$_ENV['r2_access_key_id'] = '';
$_ENV['r2_access_key_secret'] = '';
$_ENV['r2_client_download_timeout'] = 10;

#Obtain the user's real ip after setting up the CDN. If you don't know what this is, please don't mess around
$_ENV['cdn_forwarded_ip'] = array('HTTP_X_FORWARDED_FOR', 'HTTP_ALI_CDN_REAL_IP', 'X-Real-IP', 'True-Client-Ip');
foreach ($_ENV['cdn_forwarded_ip'] as $cdn_forwarded_ip) {
    if (isset($_SERVER[$cdn_forwarded_ip])) {
        $list = explode(',', $_SERVER[$cdn_forwarded_ip]);
        $_SERVER['REMOTE_ADDR'] = $list[0];
        break;
    }
}
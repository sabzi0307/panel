<?php

//basic settings--------------------------------------------------------------------------------------------
$_ENV['key']        = 'ChangeMe';                     //Cookie encryption key, please be sure to modify this key to a random string
$_ENV['pwdMethod']  = 'bcrypt';                       //Password encryption optional md5, sha256, bcrypt, argon2i, argon2id
$_ENV['salt']       = '';                             //Recommended for md5/sha256， bcrypt/argon2i/argon2id will ignore this

$_ENV['debug']      = false;                          //debug mode switch，The production environment should be kept as false
$_ENV['appName']    = 'SSPanel-UIM';                  // Site name
$_ENV['baseUrl']    = 'https://example.com';          // site address
$_ENV['muKey']      = 'ChangeMe';                     //WebAPI Key, used for communication between the node server and the panel，Be sure to modify this key to a random string

//database settings--------------------------------------------------------------------------------------------
// db_host|db_socket Choose one of the two, if set db_socket then db_host Will be ignored, please leave blank. If the database is on the local machine it is recommended to use db_socket。
// db_host example: localhost (resolvable hostname), 127.0.0.1（IP address）, 10.0.0.2:4406（With port)
// db_socket example：/var/run/mysqld/mysqld.sock（Absolute address is required）
$_ENV['db_driver']    = 'mysql';
$_ENV['db_host']      = '';
$_ENV['db_socket']    = '';
$_ENV['db_database']  = 'sspanel';           //Database name
$_ENV['db_username']  = 'root';              //database username
$_ENV['db_password']  = 'sspanel';           //The password corresponding to the username
$_ENV['db_port']      = '3306';              //database port
#advanced
$_ENV['db_charset']   = 'utf8mb4';
$_ENV['db_collation'] = 'utf8mb4_unicode_ci';
$_ENV['db_prefix']    = '';

//E-Mail settings--------------------------------------------------------------------------------------------
$_ENV['mail_filter']        = 0;            //0: off; 1: whitelist mode; 2; blacklist mode;
$_ENV['mail_filter_list']   = array("qq.com", "vip.qq.com", "foxmail.com");

//Registered user settings---------------------------------------------------------------------------------------
#Base
$_ENV['enable_checkin']             = true;         // enable the sign-in function
$_ENV['checkinMin']                 = 1;            // User sign-in minimum traffic unit MB
$_ENV['checkinMax']                 = 50;           // User check-in traffic with the most traffic

#advanced
$_ENV['class_expire_reset_traffic'] = 0;            //The traffic value to reset to when the level expires, in GB, if it is less than 0, it will not be reset
$_ENV['enable_kill']                = true;         //allow users to log out of accounts
$_ENV['enable_change_email']        = true;         //allow users to change account email

#Email reminder for insufficient user data allowance
$_ENV['notify_limit_mode']          = false;         //false is closed, per is reminded according to percentage, mb is reminded according to fixed remaining traffic
$_ENV['notify_limit_value']         = 500;           //When the previous item is per, fill in the percentage here; when the previous item is mb, fill in the traffic here

//log settings---------------------------------------------------------------------------------------
$_ENV['trafficLog']               = false;                          //record the traffic used by users every hour
$_ENV['trafficLog_keep_days']     = 7;                             //Number of days to keep usage traffic records per hour

$_ENV['subscribeLog']               = false;                        //record user subscription logs
$_ENV['subscribeLog_keep_days']     = 7;                            //Number of days to keep subscription records

//subscription settings---------------------------------------------------------------------------------------
$_ENV['Subscribe']                  = true;                         //Does this site provide a subscription function?
$_ENV['subUrl']                     = $_ENV['baseUrl'];             //Subscription address, if it needs to be the same as the site name, please do not modify

//Audit auto-ban settings--------------------------------------------------------------------------------------------
$_ENV['auto_detect_ban_allow_admin'] = true;        // Administrators are not subject to audit restrictions
$_ENV['auto_detect_ban_allow_users'] = [];          // Exception User IDs for Audit Bans
$_ENV['auto_detect_ban_number']      = 30;             // The number of procs needed to enforce a ban in mercy mode
$_ENV['auto_detect_ban_time']        = 60;             // The duration of each ban in mercy mode (minutes)

//Bot set up--------------------------------------------------------------------------------------------
# Telegram bot
$_ENV['enable_telegram']                    = false;        //enable Telegram bot
$_ENV['telegram_token']                     = '';           //Telegram bot token ，with father bot Application
$_ENV['telegram_chatid']                    = -111;         //Telegram bot,Group session ID, follow the robot after pulling it into the group /ping get it in one click
$_ENV['telegram_bot']                       = '_bot';       //Telegram bot account
$_ENV['telegram_request_token']             = '';           //Webhook key, after updating this parameter please php xcat Tool setTelegram, Telegram The robot requests Key, which can be set at will, consisting of uppercase and lowercase English and numbers. After updating this parameter, please php xcat Tool setTelegram

//node detection-----------------------------------------------------------------------------------------------
#GFW detection
$_ENV['detect_gfw_port']                 = 443;                                                                 //The TCP port opened by all node servers, commonly used is 22 (SSH port)
$_ENV['detect_gfw_url']                  = 'http://example.com:8080/tcping?ip={ip}&port={port}'; //The URL of the API that detects whether the node is blocked by gfw

#offline detection
$_ENV['enable_detect_offline']           = true;

//All of the following are advanced settings (generally not used, do not need to change---------------------------------------------------------------------

// Does the master site provide WebAPI
// - For security, it is recommended to use the WebAPI mode to connect to the node and close the public network database connection.
// - Can be set to false if all your nodes use database connections or if you have a separate WebAPI site or gRPC API.
$_ENV['WebAPI']     = true;

#Misc
$_ENV['authDriver']             = 'cookie';            //optional: cookies
$_ENV['sessionDriver']          = 'cookie';            //optional: cookie
$_ENV['cacheDriver']            = 'cookie';            //optional: cookie
$_ENV['tokenDriver']            = 'db';                //optional: db

$_ENV['enable_login_bind_ip']   = false;        //bind the login thread to the IP
$_ENV['rememberMeDuration']     = 7;           //Remember the number of days of account duration when logging in

$_ENV['timeZone']               = 'Asia/Tehran';         //Requires a PHP-compatible timezone format
$_ENV['theme']                  = 'tabler';              //Default Theme
$_ENV['jump_delay']             = 1200;                  //Jump delay, in ms, it is not recommended to be too long

$_ENV['checkNodeIp']            = true;                 // webapi verifies node ip
$_ENV['keep_connect']           = false;               // Speed limit to 1Mbps for traffic exhausted users

#Cloudflare
$_ENV['cloudflare_enable']      = false;         //enable Cloudflare analysis
$_ENV['cloudflare_email']       = '';            //Cloudflare email address
$_ENV['cloudflare_key']         = '';            //Cloudflare API Key
$_ENV['cloudflare_name']        = '';            //domain name

#Whether to include statistical codes, create an analytics.tpl under resources/views/{theme name}, and use literal delimiters if necessary
$_ENV['enable_analytics_code']  = false;

#Obtain the user's real ip after setting up the CDN. If you don't know what this is, please don't mess around
$_ENV['cdn_forwarded_ip'] = array('HTTP_X_FORWARDED_FOR', 'HTTP_ALI_CDN_REAL_IP', 'X-Real-IP', 'True-Client-Ip');
foreach ($_ENV['cdn_forwarded_ip'] as $cdn_forwarded_ip) {
    if (isset($_SERVER[$cdn_forwarded_ip])) {
        $list = explode(',', $_SERVER[$cdn_forwarded_ip]);
        $_SERVER['REMOTE_ADDR'] = $list[0];
        break;
    }
}

// https://sentry.io for production debugging
$_ENV['sentry_dsn'] = '';

// Maxmind GeoIP2 database
$_ENV['maxmind_license_key'] = 'local';
$_ENV['geoip_locale'] = 'en';

// OpenAI API Key for GPT powered ticket reply and more
$_ENV['openai_api_key'] = '';
$_ENV['ai_model'] = 'gpt-3.5-turbo';

// ClientDownload command resolves the restricted use of Github access tokens due to the high frequency of API access
$_ENV['github_access_token'] = '';


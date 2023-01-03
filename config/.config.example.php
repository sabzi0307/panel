<?php

//basic settings--------------------------------------------------------------------------------------------
$_ENV['key']        = 'ChangeMe';                     //Be sure to modify this key to a random string
$_ENV['pwdMethod']  = 'bcrypt';                          //Password Encryption Optional md5, sha256, bcrypt, argon2i, argon2id（argon2i need at least php7.2）
$_ENV['salt']       = '';                             //Recommended for md5/sha256， bcrypt/argon2i/argon2id will ignore this

$_ENV['debug']      = false;                          //debug mode switch，The production environment should be kept as false
$_ENV['appName']    = 'SSPanel-UIM';                  // Site name
$_ENV['baseUrl']    = 'https://example.com';           // site address
$_ENV['muKey']      = 'SSPanel';                      //WebAPI Key, used for communication between the node server and the panel

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
#advanced
$_ENV['db_charset']   = 'utf8mb4';
$_ENV['db_collation'] = 'utf8mb4_unicode_ci';
$_ENV['db_prefix']    = '';

//Streaming media unlocking The following settings will enable nodes 397 and 297 to reuse the detection results of node 4 and remove the comment when using it //
$_ENV['streaming_media_unlock_multiplexing'] = [
    //'397' => '4',
    //'297' => '4',
];

//E-Mail settings--------------------------------------------------------------------------------------------
$_ENV['mail_filter']        = 0;            //0: off; 1: whitelist mode; 2; blacklist mode;
$_ENV['mail_filter_list']   = array("qq.com", "vip.qq.com", "foxmail.com");

//Registered user settings---------------------------------------------------------------------------------------
#Base
$_ENV['enable_checkin']             = true;         // Whether to enable the sign-in function
$_ENV['checkinMin']                 = 1;            // User sign-in minimum traffic unit MB
$_ENV['checkinMax']                 = 50;           // User check-in traffic with the most traffic

$_ENV['auto_clean_uncheck_days']    = -1;           //Automatically clean up level 0 users who have not signed in for how many days, and close when less than or equal to 0
$_ENV['auto_clean_unused_days']     = -1;           //How many days of unused level 0 users will be automatically cleared, and it will be turned off when it is less than or equal to 0
$_ENV['auto_clean_min_money']       = 1;            //Level 0 users whose balance is lower than a certain amount can be cleared

$_ENV['enable_bought_reset']        = true;         //Whether to reset traffic when purchasing
$_ENV['enable_bought_extend']       = true;         //Whether to extend the level period when purchasing (same level package)

#advanced
$_ENV['class_expire_reset_traffic'] = 0;            //The traffic value to reset to when the level expires, in GB, if it is less than 0, it will not be reset
$_ENV['account_expire_delete_days'] = -1;           //The account will be deleted a few days after the account expires, and it will not be deleted when it is less than 0

$_ENV['enable_kill']                = true;         //Whether to allow users to log out of accounts
$_ENV['enable_change_email']        = true;         //Whether to allow users to change account email

#Email reminder for insufficient user data allowance
$_ENV['notify_limit_mode']          = false;         //false is closed, per is reminded according to percentage, mb is reminded according to fixed remaining flow
$_ENV['notify_limit_value']         = 20;           //When the previous item is per, fill in the percentage here; when the previous item is mb, fill in the traffic here

//log settings---------------------------------------------------------------------------------------
$_ENV['trafficLog']               = false;                          //Whether to record the traffic used by users every hour
$_ENV['trafficLog_keep_days']     = 14;                             //Number of days to keep usage traffic records per hour

$_ENV['subscribeLog']               = false;                        //Whether to record user subscription logs
$_ENV['subscribeLog_show']          = true;                         //Whether to allow users to view subscription records
$_ENV['subscribeLog_keep_days']     = 7;                            //Number of days to keep subscription records

//subscription settings---------------------------------------------------------------------------------------
$_ENV['Subscribe']                  = true;                         //Does this site provide a subscription function?
$_ENV['subUrl']                     = $_ENV['baseUrl'];             //Subscription address, if it needs to be the same as the site name, please do not modify
$_ENV['enable_forced_replacement']  = true;                         //Whether to force the subscription address to be changed when the user modifies the account login password


//Audit auto-ban settings--------------------------------------------------------------------------------------------
$_ENV['enable_auto_detect_ban']      = false;       // Audit Auto-Ban Switch
$_ENV['auto_detect_ban_numProcess']  = 300;         // The number of audit records processed in a single scheduled task
$_ENV['auto_detect_ban_allow_admin'] = true;        // Administrators are not subject to audit restrictions
$_ENV['auto_detect_ban_allow_users'] = [];          // Exception User IDs for Audit Bans

// Judgment type of audit ban：
//   - 1 = Benevolent mode, every touch how many times to ban
//   - 2 = Crazy mode, the cumulative number of touches will be banned for different lengths of time according to the ladder
$_ENV['auto_detect_ban_type']        = 1;
$_ENV['auto_detect_ban_number']      = 30;             // The number of procs needed to enforce a ban in mercy mode
$_ENV['auto_detect_ban_time']        = 60;             // The duration of each ban in mercy mode (minutes)

// crazy mode ladder
// key is the number of triggers
// - type: optional time delete numbers by time or kill
// - time: time in minutes
$_ENV['auto_detect_ban'] = [
    100 => [
        'type' => 'time',
        'time' => 120
    ],
    300 => [
        'type' => 'time',
        'time' => 720
    ],
    600 => [
        'type' => 'time',
        'time' => 4320
    ],
    1000 => [
        'type' => 'kill',
        'time' => 0
    ]
];


//Bot set up--------------------------------------------------------------------------------------------
# Telegram bot
$_ENV['enable_telegram']                    = false;        //whether to enable Telegram bot
$_ENV['telegram_token']                     = '';           //Telegram bot,bot of token ，with father bot Application
$_ENV['telegram_chatid']                    = -111;         //Telegram bot,Group session ID, follow the robot after pulling it into the group /ping get it in one click
$_ENV['telegram_bot']                       = '_bot';       //Telegram bot account
$_ENV['telegram_group_quiet']               = false;        //Telegram Bots don't respond in groups
$_ENV['telegram_request_token']             = '';           //Telegram The robot requests Key, which can be set at will, consisting of uppercase and lowercase English and numbers. After updating this parameter, please php xcat Tool setTelegram

# general
$_ENV['finance_public']                     = true;         // Whether the financial report is open to the public
$_ENV['enable_welcome_message']             = true;         //The bot sends the welcome message

# Telegram BOT other options
$_ENV['allow_to_join_new_groups']           = true;         //Allow bots to join groups other than those configured below
$_ENV['group_id_allowed_to_join']           = [];           //IDs of groups allowed to join, formatted as a PHP array
$_ENV['telegram_admins']                    = [];           //Additional Telegram admin IDs in PHP array format
$_ENV['enable_not_admin_reply']             = true;         //Whether the administrator function of non-administrator operation is restored
$_ENV['not_admin_reply_msg']                = '!';          //Reply content of non-administrator operation administrator function
$_ENV['no_user_found']                      = '!';          //When the administrator is operating, the user's reply cannot be found.
$_ENV['no_search_value_provided']           = '!';          //When the administrator operates, there is no reply that provides the user search value
$_ENV['data_method_not_found']              = '!';          //When the administrator operates, the field for modifying the data cannot be found.
$_ENV['delete_message_time']                = 180;          //Delete the bot response triggered by the user command after the following time, unit: second, the deletion time may be different due to the timing task, 0 means this function is not enabled
$_ENV['delete_admin_message_time']          = 86400;        //Delete the bot reply triggered by the management command after the following time, unit: second, the deletion time may be different due to the timing task, 0 means this function is not enabled
$_ENV['enable_delete_user_cmd']             = false;        //Automatically delete the command sent by the user in the group, using the time configured by delete_message_time, the deletion time may vary due to the timing task
$_ENV['help_any_command']                   = false;        //Allow any unknown command to trigger a /help reply

$_ENV['remark_user_search_email']           = ['Mail'];                     //User Search Field email The alias of can be more than one, and the format is a PHP array
$_ENV['remark_user_search_port']            = ['port'];                     //User search field port The alias of can be more than one, and the format is a PHP array

$_ENV['remark_user_option_is_admin']        = ['administrator'];            //user search field is_admin The alias of can be multiple, the format is a PHP array
$_ENV['remark_user_option_enable']          = ['user enabled'];             //user search field enable alias of can be multiple, the format is a PHP array
$_ENV['remark_user_option_money']           = ['money', 'balance'];             //User Search Field money alias of can be multiple, the format is a PHP array
$_ENV['remark_user_option_port']            = ['port'];                     //User Search Field port alias of can be multiple, the format is a PHP array
$_ENV['remark_user_option_transfer_enable'] = ['traffic'];                     //User Search Field transfer_enable alias of can be multiple, the format is a PHP array
$_ENV['remark_user_option_passwd']          = ['connection password'];                 //User Search Field passwd alias of can be multiple, the format is a PHP array
$_ENV['remark_user_option_method']          = ['encryption'];                     //User Search Field method alias of can be multiple, the format is a PHP array
$_ENV['remark_user_option_invite_num']      = ['number of invites'];                 //User Search Field invite_num alias of can be multiple, the format is a PHP array
$_ENV['remark_user_option_node_group']      = ['User Group', 'User Group'];       //User Search Field node_group alias of can be multiple, the format is a PHP array
$_ENV['remark_user_option_class']           = ['level'];                     //User Search Field class alias of can be multiple, the format is a PHP array
$_ENV['remark_user_option_class_expire']    = ['Level Expiration Time'];             //User Search Field class_expire alias of can be multiple, the format is a PHP array
$_ENV['remark_user_option_expire_in']       = ['account expiration time'];             //User Search Field expire_in alias of can be multiple, the format is a PHP array
$_ENV['remark_user_option_node_speedlimit'] = ['speed limit'];                    //User Search Field node_speedlimit alias of can be multiple, the format is a PHP array
$_ENV['remark_user_option_node_connector']  = ['Connections', 'clients'];         //User Search Field node_connector alias of can be multiple, the format is a PHP array

$_ENV['enable_user_email_group_show']       = false;                      //Enable to display the user's complete email address when searching for user information in groups, and disable it to code the middle content of the email address, such as g****@gmail.com
$_ENV['user_not_bind_reply']                = 'You have not bound the account of this site, you can enter **data editing** of the website, bind your account at the bottom right.';     //Unbound account reply
$_ENV['telegram_general_pricing']           = 'product introduction.';                  //Product introduction for visitors
$_ENV['telegram_general_terms']             = 'Terms of Service.';                  //Terms of Service for Visitors

//Social login settings
#Telegram
$_ENV['enable_telegram_login']              = false;   //Please configure Telegram bot first before enabling this setting, otherwise it will not take effect

#Ticket System Settings
$_ENV['enable_ticket']        = true;        //Whether to enable the ticket system
$_ENV['mail_ticket']          = true;        //Whether to open ticket email reminder

# Server When users submit new work orders or reply to work orders, they will use WeChat to remind the airport owner https://sct.ftqq.com/
$_ENV['useScFtqq']            = false;        //Whether to enable ticket server sauce reminder
$_ENV['ScFtqq_SCKEY']         = '';           //Please fill in the SCKEY you obtained in Server sauce, please check carefully and do not paste it wrong

#Background product list Sales statistics
$_ENV['sales_period']         = 30;             //Count the sales in the specified period, the value is [expire/any integer greater than 0]

//node detection-----------------------------------------------------------------------------------------------
#GFW detection, please [enable/disable] through crontab
$_ENV['detect_gfw_interval']             = 3600;                                                               //Detection interval, unit: second, if it is lower than the recommended value, it will explode
$_ENV['detect_gfw_port']                 = 22;                                                                 //The TCP port opened by all node servers, commonly used is 22 (SSH port)
$_ENV['detect_gfw_url']                  = 'http://cn-sh-tcping.sspanel.org:8080/tcping?ip={ip}&port={port}'; //The URL of the API that detects whether the node is blocked by gfw
$_ENV['detect_gfw_count']                = '3';                                                                //number of attempts

#offline detection
$_ENV['enable_detect_offline']           = true;
#Offline detection whether to push to Server sauce Please configure the above Server configuration
$_ENV['enable_detect_offline_useScFtqq'] = false;

//All of the following are advanced settings (generally not used, do not need to change---------------------------------------------------------------------

// Whether the main site provides WebAPI
// - For security, it is recommended to use the WebAPI mode to connect to the node and close the public network database connection。
// - Can be set to false if all your nodes use database connections or if you have a separate WebAPI site or gRPC API。
$_ENV['WebAPI']     = true;

#Misc
$_ENV['authDriver']             = 'cookie';            //This item cannot be changed
$_ENV['sessionDriver']          = 'cookie';            //optional: cookie
$_ENV['cacheDriver']            = 'cookie';            //optional: cookie
$_ENV['tokenDriver']            = 'db';                //optional: db

$_ENV['enable_login_bind_ip']   = false;        //Whether to bind the login thread to the IP
$_ENV['rememberMeDuration']     = 7;           //Remember the number of days of account duration when logging in

$_ENV['timeZone']               = 'PRC';                 //PRC Chinese time UTC Green time
$_ENV['theme']                  = 'tabler';              //Default Theme
$_ENV['jump_delay']             = 1200;                  //Jump delay, in ms, it is not recommended to be too long
$_ENV['checkNodeIp']            = true;                 //Whether webapi verifies node ip
$_ENV['muKeyList']              = [];                   //Multiple key lists
$_ENV['keep_connect']           = false;               // If the traffic is exhausted, the speed limit is limited to 1Mbps
$_ENV['money_from_admin']       = false;            //Whether to enable the administrator to create a recharge record when modifying the user's balance

#Cloudflare
$_ENV['cloudflare_enable']      = false;         //Whether to enable Cloudflare analysis
$_ENV['cloudflare_email']       = '';            //Cloudflare email address
$_ENV['cloudflare_key']         = '';            //Cloudflare API Key
$_ENV['cloudflare_name']        = '';            //domain name

#Whether to include statistical codes, create an analytics.tpl under resources/views/{theme name}, and use literal delimiters if necessary
$_ENV['enable_analytics_code']  = false;

#Obtain the user's real ip after installing the CDN, if you don't know what it is, please don't mess around
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

// ClientDownload The command solves the problem that the API access frequency is high and the usage is restricted Github access token
$_ENV['github_access_token'] = '';

$_ENV['php_user_group'] = 'www:www';

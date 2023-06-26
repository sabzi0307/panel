#!/usr/bin/env bash

echo >&2 " _____ _____ _____             _ "
echo >&2 "|   __|   __|  _  |___ ___ ___| |"
echo >&2 "|__   |__   |   __| .'|   | -_| |"
echo >&2 "|_____|_____|__|  |__,|_|_|___|_|"
                                 
echo -n >&2 "\nChecking if installation exists..."

# some configurations for let's encrypt

if [ ! -f conf/.config.php ];then
    cp /var/www/html/conf/appprofile.example.php /var/www/html/conf/appprofile.php
    INIT=true
    echo >&2 "Start Init"
fi

if [ "$INIT" = true ];then

    echo -n >&2 "\nChecking environment..."

    if [ -z "$ADMIN_EMAIL" ]; then
        echo >&2 "ADMIN_EMAIL not set!"
        exit
    fi
    if [ -z "$ADMIN_PASSWORD" ]; then
        echo >&2 "ADMIN_PASSWORD not set!"
        exit
    fi
    if [ -z "$key" ]; then
        echo >&2 "key not set!"
        exit
    fi

    if [ -z "$pwdMethod" ];then
        echo >&2 "pwdMethod not set! using default (bcrypt)"
        pwdMethod="bcrypt"
    fi

    if [ -z "$salt" ];then
        echo >&2 "salt not set! "
        salt=""
    fi

    if [ -z "$debug" ];then
        echo >&2 "debug not set! using false"
        debug=false
    fi

    if [ -z "$appName" ];then
        echo >&2 "appName not set!"
        appName="IRPanel"
    fi

    if [ -z "$baseUrl" ];then
        echo >&2 "baseUrl not set!"
        exit
    fi

    if [ -z "$muKey" ];then
        echo >&2 "muKey not set!"
        exit
    fi

    if [ -z "$db_host" ] && [ -z "$db_socket" ];then
        echo >&2 "db_host or DB_SOCKET not set!"
        exit
    fi
    if [ -z "$db_driver" ];then
        echo >&2 "db_driver not set! using mysql"
        db_driver='mysql'
    fi
    if [ -z "$db_port" ];then
        echo >&2 "db_port not set! using 3306"
        db_port=3306
    fi
    if [ -z "$MYSQL_DATABASE" ];then
        echo >&2 "MYSQL_DATABASE not set! using default"
        MYSQL_DATABASE="sspanel"
    fi

    if [ -z "$MYSQL_USER" ];then
        echo >&2 "MYSQL_USER not set! using root"
        MYSQL_USER="sspanel"
    fi

    if [ -z "$MYSQL_PASSWORD" ];then
        echo >&2 "MYSQL_PASSWORD not set! using default"
        MYSQL_PASSWORD="sspanel"
    fi

    if [ -z "$db_charset" ];then
        echo >&2 "db_charset not set! using utf8mb4"
        db_charset="utf8mb4"
    fi

    if [ -z "$db_collation" ];then
        echo >&2 "db_collation not set! using utf8mb4_unicode_ci"
        db_collation="utf8mb4_unicode_ci"
    fi

    if [ -z "$db_prefix" ];then
        echo >&2 "db_prefix not set!"
        db_prefix=""
    fi

    if [ -z "$mail_filter" ];then
        echo >&2 "mail_filter not set!, using 0 (disable)"
        mail_filter=0
    fi

    if [ -z "$mail_filter_list" ];then
        echo >&2 "mail_filter_list not set!, using 0 (disable)"
        mail_filter_list=["qq.com", "vip.qq.com", "foxmail.com"]
    fi

    if [ -z "$enable_checkin" ];then
        echo >&2 "enable_checkin not set!, using true"
        enable_checkin=true
    fi

    if [ -z "$checkinMin" ];then
        echo >&2 "checkinMin not set!, using 1"
        checkinMin=1
    fi

    if [ -z "$checkinMax" ];then
        echo >&2 "checkinMax not set!, using 50"
        checkinMax=50
    fi
    if [ -z "$auto_clean_uncheck_days" ];then
        echo >&2 "auto_clean_uncheck_days not set!, using -1 (disable)"
        auto_clean_uncheck_days=-1
    fi
    if [ -z "$auto_clean_unused_days" ];then
        echo >&2 "auto_clean_unused_days not set!, using -1 (disable)"
        auto_clean_unused_days=-1
    fi
    if [ -z "$auto_clean_min_money" ];then
        echo >&2 "auto_clean_min_money not set!, using 1 "
        auto_clean_min_money=1
    fi
    if [ -z "$class_expire_reset_traffic" ];then
        echo >&2 "class_expire_reset_traffic not set!, using 0 "
        class_expire_reset_traffic=0
    fi
    if [ -z "$account_expire_delete_days" ];then
        echo >&2 "account_expire_delete_days not set!, using -1 "
        account_expire_delete_days=-1
    fi
    if [ -z "$enable_kill" ];then
        echo >&2 "enable_kill not set!, using true "
        enable_kill=true
    fi
    if [ -z "$enable_change_email" ];then
        echo >&2 "enable_change_email not set!, using true "
        enable_change_email=true
    fi
    if [ -z "$notify_limit_mode" ];then
        echo >&2 "notify_limit_mode not set!, using false "
        notify_limit_mode=false
    fi
    if [ -z "$notify_limit_value" ];then
        echo >&2 "notify_limit_value not set!, using 20 "
        notify_limit_value=20
    fi
    if [ -z "$trafficLog" ];then
        echo >&2 "trafficLog not set!, using false "
        trafficLog=false
    fi
    if [ -z "$trafficLog_keep_days" ];then
        echo >&2 "trafficLog_keep_days not set!, using 7 "
        trafficLog_keep_days=7
    fi
    if [ -z "$subscribeLog" ];then
        echo >&2 "subscribeLog not set!, using false "
        subscribeLog=false
    fi
    if [ -z "$subscribeLog_keep_days" ];then
        echo >&2 "subscribeLog_keep_days not set!, using 7 "
        subscribeLog_keep_days=7
    fi
    if [ -z "$Subscribe" ];then
        echo >&2 "Subscribe not set!, using true "
        Subscribe=true
    fi
    if [ -z "$subUrl" ];then
        echo >&2 "subUrl not set!, using ${baseUrl} "
        subUrl=$baseUrl
    fi
    if [ -z "$enable_auto_detect_ban" ];then
        echo >&2 "enable_auto_detect_ban not set!, using false "
        enable_auto_detect_ban=false
    fi
    if [ -z "$auto_detect_ban_numProcess" ];then
        echo >&2 "auto_detect_ban_numProcess not set!, using 300 "
        auto_detect_ban_numProcess=300
    fi
    if [ -z "$auto_detect_ban_allow_admin" ];then
        echo >&2 "auto_detect_ban_allow_admin not set!, using true "
        auto_detect_ban_allow_admin=true
    fi
    if [ -z "$auto_detect_ban_allow_users" ];then
        echo >&2 "auto_detect_ban_allow_users not set!, using [] "
        auto_detect_ban_allow_users=[]
    fi
    if [ -z "$auto_detect_ban_type" ];then
        echo >&2 "auto_detect_ban_type not set!, using 1 "
        auto_detect_ban_type=1
    fi
    if [ -z "$auto_detect_ban_number" ];then
        echo >&2 "auto_detect_ban_number not set!, using 30 "
        auto_detect_ban_number=30
    fi
    if [ -z "$auto_detect_ban_time" ];then
        echo >&2 "auto_detect_ban_time not set!, using 60 "
        auto_detect_ban_time=60
    fi

    if [ -z "$enable_telegram" ];then
        echo >&2 "enable_telegram not set!, using false "
        enable_telegram=false
    fi
    if [ "$enable_telegram" == true ];then
        if [ -z "$telegram_token" ];then
            echo >&2 "telegram_token not set! "
            exit
        fi
        if [ -z "$telegram_chatid" ];then
            echo >&2 "telegram_chatid not set! "
            exit
        fi
        if [ -z "$telegram_bot" ];then
            echo >&2 "telegram_bot not set! "
            exit
        fi
        if [ -z "$telegram_request_token" ];then
            echo >&2 "telegram_request_token not set! "
            exit
        fi
    fi

    if [ -z "$detect_gfw_interval" ];then
        echo >&2 "detect_gfw_interval not set! using 3600 "
        detect_gfw_interval=3600
    fi
    if [ -z "$detect_gfw_port" ];then
        echo >&2 "detect_gfw_port not set! using 443 "
        detect_gfw_port=443
    fi
    if [ -z "$detect_gfw_url" ];then
        echo >&2 "detect_gfw_url not set! using 443 "
        detect_gfw_url=http://example.com:8080/tcping?ip={ip}&port={port}
    fi
    if [ -z "$detect_gfw_count" ];then
        echo >&2 "detect_gfw_count not set! using 3 "
        detect_gfw_count=3
    fi
    if [ -z "$enable_detect_offline" ];then
        echo >&2 "enable_detect_offline not set! using true "
        enable_detect_offline=true
    fi
    if [ -z "$WebAPI" ];then
        echo >&2 "WebAPI not set! using true "
        WebAPI=true
    fi
    if [ -z "$authDriver" ];then
        echo >&2 "authDriver not set! using cookie "
        authDriver="cookie"
    fi
    if [ -z "$sessionDriver" ];then
        echo >&2 "sessionDriver not set! using cookie "
        sessionDriver="cookie"
    fi
    if [ -z "$cacheDriver" ];then
        echo >&2 "cacheDriver not set! using cookie "
        cacheDriver="cookie"
    fi
    if [ -z "$tokenDriver" ];then
        echo >&2 "tokenDriver not set! using db "
        cacheDriver="db"
    fi
    if [ -z "$enable_login_bind_ip" ];then
        echo >&2 "enable_login_bind_ip not set! using false "
        enable_login_bind_ip=false
    fi
    if [ -z "$rememberMeDuration" ];then
        echo >&2 "rememberMeDuration not set! using 7 "
        rememberMeDuration=7
    fi
    if [ -z "$timeZone" ];then
        echo >&2 "timeZone not set! using Asia/Tehran "
        timeZone="Asia/Tehran"
    fi
    if [ -z "$theme" ];then
        echo >&2 "theme not set! using Asia/Tehran "
        theme="tabler"
    fi
    if [ -z "$jump_delay" ];then
        echo >&2 "jump_delay not set! using 1200 "
        jump_delay=1200
    fi
    if [ -z "$checkNodeIp" ];then
        echo >&2 "checkNodeIp not set! using true "
        checkNodeIp=true
    fi
    if [ -z "$keep_connect" ];then
        echo >&2 "keep_connect not set! using false "
        keep_connect=false
    fi
    if [ -z "$cloudflare_enable" ];then
        echo >&2 "cloudflare_enable not set! using false "
        cloudflare_enable=false
    fi

    if [ "$cloudflare_enable" == true ];then
        if [ -z "$cloudflare_email" ];then
            echo >&2 "cloudflare_email not set! exit "
            exit
        fi
        if [ -z "$cloudflare_key" ];then
            echo >&2 "cloudflare_key not set! exit "
            exit
        fi
        if [ -z "$cloudflare_name" ];then
            echo >&2 "cloudflare_name not set! exit "
            exit
        fi

    fi

    if [ -z "$enable_analytics_code" ];then
        echo >&2 "enable_analytics_code not set! using false "
        enable_analytics_code=false
    fi
    if [ -z "$sentry_dsn" ];then
        echo >&2 "sentry_dsn not set! "
        sentry_dsn=""
    fi
    if [ -z "$maxmind_license_key" ];then
        echo >&2 "maxmind_license_key not set! "
        maxmind_license_key=""
    fi
    if [ -z "$geoip_locale" ];then
        echo >&2 "geoip_locale not set! "
        geoip_locale="en"
    fi
    if [ -z "$openai_api_key" ];then
        echo >&2 "openai_api_key not set! "
        openai_api_key=""
    fi
    if [ -z "$ai_model" ];then
        echo >&2 "ai_model not set! using gpt-3.5-turbo "
        ai_model="gpt-3.5-turbo"
    fi
    if [ -z "$github_access_token" ];then
        echo >&2 "github_access_token not set! "
        github_access_token=""
    fi
    if [ -z "$php_user_group" ];then
        echo >&2 "php_user_group not set! using nginx:nginx "
        php_user_group="nginx:nginx"
    fi


    if [ "$B2_BACKUP" = true ];then
        echo >&2 "B2_BACKUP set!"
        if [ -z "$B2_APP_KEY_ID" ];then
            echo >&2 "B2_APP_KEY_ID not set!"
            exit
        fi
        if [ -z "$B2_APP_KEY" ];then
            echo >&2 "B2_APP_KEY not set!"
            exit
        fi
        if [ -z "$B2_BUCKET_NAME" ];then
            echo >&2 "B2_BUCKET_NAME not set!"
            exit
        fi
        if [ -z "$B2_BACKUP_NAME" ];then
            echo >&2 "B2_BACKUP_NAME not set!... using default SSPANEL"
            B2_BACKUP_NAME = "SSPANEL"
        fi
        if [ -z "$B2_COMPRESS_METHOD" ];then
            echo >&2 "B2_BACKUP_NAME not set!... using default ZIP"
            B2_COMPRESS_METHOD = "zip"
        fi
    fi
    echo >&2 "All env setDone"



cat <<EOF >/var/www/html/conf/.config.php

<?php

//basic settings--------------------------------------------------------------------------------------------
\$_ENV['key']        = '$key';                      //Cookie encryption key, please be sure to modify this key to a random string
\$_ENV['pwdMethod']  = '$pwdMethod';                //Password encryption optional md5, sha256, bcrypt, argon2i, argon2id
\$_ENV['salt']       = '$salt';                     //Recommended for md5/sha256， bcrypt/argon2i/argon2id will ignore this

\$_ENV['debug']      = $debug;                       //debug mode switch，The production environment should be kept as false
\$_ENV['appName']    = '$appName';                   // Site name
\$_ENV['baseUrl']    = '$baseUrl';                   // site address
\$_ENV['muKey']      = '$muKey';                     //WebAPI Key, used for communication between the node server and the panel，请务必修改此key为随机字符串

//database settings--------------------------------------------------------------------------------------------
// db_host|db_socket Choose one of the two, if set db_socket then db_host Will be ignored, please leave blank. If the database is on the local machine it is recommended to use db_socket。
// db_host example: localhost (resolvable hostname), 127.0.0.1（IP address）, 10.0.0.2:4406（With port)
// db_socket example：/var/run/mysqld/mysqld.sock（Absolute address is required）
\$_ENV['db_driver']    = '$db_driver';
\$_ENV['db_host']      = '$db_host';
\$_ENV['db_socket']    = '$db_socket';
\$_ENV['db_database']  = '$MYSQL_DATABASE';           //Database name
\$_ENV['db_username']  = '$MYSQL_USER';           //database username
\$_ENV['db_password']  = '$MYSQL_PASSWORD';           //The password corresponding to the username
\$_ENV['db_port']      = '$db_port';               //database poprt
#advanced
\$_ENV['db_charset']   = '$db_charset';
\$_ENV['db_collation'] = '$db_collation';
\$_ENV['db_prefix']    = '$db_prefix';

//E-Mail settings--------------------------------------------------------------------------------------------
\$_ENV['mail_filter']        = $mail_filter;            //0: off; 1: whitelist mode; 2; blacklist mode;
\$_ENV['mail_filter_list']   = array($mail_filter_list);

//Registered user settings---------------------------------------------------------------------------------------
#Base
\$_ENV['enable_checkin']             = $enable_checkin;         // Whether to enable the sign-in function
\$_ENV['checkinMin']                 = $checkinMin;            // User sign-in minimum traffic unit MB
\$_ENV['checkinMax']                 = $checkinMax;           // User check-in traffic with the most traffic

\$_ENV['auto_clean_uncheck_days']    = $auto_clean_uncheck_days;           //Automatically clean up level 0 users who have not signed in for how many days, and close when less than or equal to 0
\$_ENV['auto_clean_unused_days']     = $auto_clean_unused_days;           //How many days of unused level 0 users will be automatically cleared, and it will be turned off when it is less than or equal to 0
\$_ENV['auto_clean_min_money']       = $auto_clean_min_money;            //Level 0 users whose balance is lower than a certain amount can be cleared

#advanced
\$_ENV['class_expire_reset_traffic'] = $class_expire_reset_traffic;            //The traffic value to reset to when the level expires, in GB, if it is less than 0, it will not be reset
\$_ENV['account_expire_delete_days'] = $account_expire_delete_days;           //The account will be deleted a few days after the account expires, and it will not be deleted when it is less than 0

\$_ENV['enable_kill']                = $enable_kill;         //Whether to allow users to log out of accounts
\$_ENV['enable_change_email']        = $enable_change_email;         //Whether to allow users to change account email

#Email reminder for insufficient user data allowance
\$_ENV['notify_limit_mode']          = $notify_limit_mode;         //false is closed, per is reminded according to percentage, mb is reminded according to fixed remaining flow
\$_ENV['notify_limit_value']         = $notify_limit_value;           //When the previous item is per, fill in the percentage here; when the previous item is mb, fill in the traffic here

//log settings---------------------------------------------------------------------------------------
\$_ENV['trafficLog']               = $trafficLog;                          //Whether to record the traffic used by users every hour
\$_ENV['trafficLog_keep_days']     = $trafficLog_keep_days;                             //Number of days to keep usage traffic records per hour

\$_ENV['subscribeLog']               = $subscribeLog;                        //Whether to record user subscription logs
\$_ENV['subscribeLog_keep_days']     = $subscribeLog_keep_days;                            //Number of days to keep subscription records

//subscription settings---------------------------------------------------------------------------------------
\$_ENV['Subscribe']                  = $Subscribe;                         //Does this site provide a subscription function?
\$_ENV['subUrl']                     = '$subUrl';             //Subscription address, if it needs to be the same as the site name, please do not modify

//Audit auto-ban settings--------------------------------------------------------------------------------------------
\$_ENV['enable_auto_detect_ban']      = $enable_auto_detect_ban;       // Audit Auto-Ban Switch
\$_ENV['auto_detect_ban_numProcess']  = $auto_detect_ban_numProcess;         // The number of audit records processed in a single scheduled task
\$_ENV['auto_detect_ban_allow_admin'] = $auto_detect_ban_allow_admin;        // Administrators are not subject to audit restrictions
\$_ENV['auto_detect_ban_allow_users'] = $auto_detect_ban_allow_users;          // Exception User IDs for Audit Bans

// Judgment type of audit ban：
//   - 1 = Benevolent mode, every touch how many times to ban
//   - 2 = Crazy mode, the cumulative number of touches will be banned for different lengths of time according to the ladder
\$_ENV['auto_detect_ban_type']        = $auto_detect_ban_type;
\$_ENV['auto_detect_ban_number']      = $auto_detect_ban_number;             // The number of procs needed to enforce a ban in mercy mode
\$_ENV['auto_detect_ban_time']        = $auto_detect_ban_time;             // The duration of each ban in mercy mode (minutes)

// crazy mode ladder
// key is the number of triggers
// - type: optional time delete numbers by time or kill
// - time: time in minutes
\$_ENV['auto_detect_ban'] = [
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
\$_ENV['enable_telegram']                    = $enable_telegram;        //whether to enable Telegram bot
\$_ENV['telegram_token']                     = '$telegram_token';           //Telegram bot,bot of token ，with father bot Application
\$_ENV['telegram_chatid']                    = '$telegram_chatid';         //Telegram bot,Group session ID, follow the robot after pulling it into the group /ping get it in one click
\$_ENV['telegram_bot']                       = '$telegram_bot';       //Telegram bot account
\$_ENV['telegram_request_token']             = '$telegram_request_token';           //Webhook key, after updating this parameter please php xcat Tool setTelegram, Telegram The robot requests Key, which can be set at will, consisting of uppercase and lowercase English and numbers. After updating this parameter, please php xcat Tool setTelegram

//node detection-----------------------------------------------------------------------------------------------
#GFW detection, please [enable/disable] through crontab
\$_ENV['detect_gfw_interval']             = $detect_gfw_interval;                                                               //Detection interval, unit: second, if it is lower than the recommended value, it will explode
\$_ENV['detect_gfw_port']                 = $detect_gfw_port;                                                                 //The TCP port opened by all node servers, commonly used is 22 (SSH port)
\$_ENV['detect_gfw_url']                  = '$detect_gfw_url'; //The URL of the API that detects whether the node is blocked by gfw
\$_ENV['detect_gfw_count']                = '$detect_gfw_count';                                                                //number of attempts

#offline detection
\$_ENV['enable_detect_offline']           = $enable_detect_offline;

//All of the following are advanced settings (generally not used, do not need to change---------------------------------------------------------------------

// Does the master site provide WebAPI
// - For security, it is recommended to use the WebAPI mode to connect to the node and close the public network database connection.
// - Can be set to false if all your nodes use database connections or if you have a separate WebAPI site or gRPC API.
\$_ENV['WebAPI']     = $WebAPI;

#Misc
\$_ENV['authDriver']             = '$authDriver';            //optional: cookies
\$_ENV['sessionDriver']          = '$sessionDriver';            //optional: cookie
\$_ENV['cacheDriver']            = '$cacheDriver';            //optional: cookie
\$_ENV['tokenDriver']            = '$tokenDriver';                //optional: db

\$_ENV['enable_login_bind_ip']   = $enable_login_bind_ip;        //Whether to bind the login thread to the IP
\$_ENV['rememberMeDuration']     = $rememberMeDuration;           //Remember the number of days of account duration when logging in

\$_ENV['timeZone']               = '$timeZone';         //Requires a PHP-compatible timezone format
\$_ENV['theme']                  = '$theme';              //Default Theme
\$_ENV['jump_delay']             = $jump_delay;                  //Jump delay, in ms, it is not recommended to be too long

\$_ENV['checkNodeIp']            = $checkNodeIp;                 //Whether webapi verifies node ip
\$_ENV['keep_connect']           = $keep_connect;               // Speed limit to 1Mbps for traffic exhausted users

#Cloudflare
\$_ENV['cloudflare_enable']      = $cloudflare_enable;         //Whether to enable Cloudflare analysis
\$_ENV['cloudflare_email']       = '$cloudflare_email';            //Cloudflare email address
\$_ENV['cloudflare_key']         = '$cloudflare_key';            //Cloudflare API Key
\$_ENV['cloudflare_name']        = '$cloudflare_name';            //domain name

#Whether to include statistical codes, create an analytics.tpl under resources/views/{theme name}, and use literal delimiters if necessary
\$_ENV['enable_analytics_code']  = $enable_analytics_code;

#Obtain the user's real ip after setting up the CDN. If you don't know what this is, please don't mess around
\$_ENV['cdn_forwarded_ip'] = array('HTTP_X_FORWARDED_FOR', 'HTTP_ALI_CDN_REAL_IP', 'X-Real-IP', 'True-Client-Ip');
foreach (\$_ENV['cdn_forwarded_ip'] as \$cdn_forwarded_ip) {
    if (isset(\$_SERVER[\$cdn_forwarded_ip])) {
        \$list = explode(',', \$_SERVER[\$cdn_forwarded_ip]);
        \$_SERVER['REMOTE_ADDR'] = \$list[0];
        break;
    }
}

// https://sentry.io for production debugging
\$_ENV['sentry_dsn'] = '$sentry_dsn';

// Maxmind GeoIP2 database
\$_ENV['maxmind_license_key'] = '$maxmind_license_key';
\$_ENV['geoip_locale'] = '$geoip_locale';

// OpenAI API Key for GPT powered ticket reply and more
\$_ENV['openai_api_key'] = '$openai_api_key';
\$_ENV['ai_model'] = '$ai_model';

// ClientDownload command resolves the restricted use of Github access tokens due to the high frequency of API access
\$_ENV['github_access_token'] = '$github_access_token';

\$_ENV['php_user_group'] = '$php_user_group';

EOF


fi



    WEBSITE_DIR="$WEBROOT"
    B2_CONF=b2_backup_config
    if [ "$B2_BACKUP" = true ] && [ ! -f "$B2_CONF" ];then
    tee -a $B2_CONF > /dev/null <<EOT
    backup_name="$B2_BACKUP_NAME"
    b2_app_key_id="$B2_APP_KEY_ID"
    b2_app_key="$B2_APP_KEY"
    b2_bucket_name="$B2_BUCKET_NAME"
    db_name="$MYSQL_DATABASE"
    db_password='$MYSQL_PASSWORD'
    db_user="$MYSQL_USER"
    db_host="$db_host"
    compress_method="$B2_COMPRESS_METHOD"
    website_dir="$WEBSITE_DIR"
EOT
    fi



echo -n >&2 "\nChecking connection to database..."

if [ -z "$db_host" ]; then
    if ! mysql -S $DB_SOCKET -P $db_port -u $MYSQL_USER --password=$MYSQL_PASSWORD -e "SELECT VERSION()" > /dev/null; then
        echo >&2 "Cannot connect to database!"
    fi
else
    if ! mysql -h $db_host -P $db_port -u $MYSQL_USER --password=$MYSQL_PASSWORD -e "SELECT VERSION()" > /dev/null; then
        echo >&2 "Cannot connect to database!"
        exit
    fi
fi

# if [ "$INIT" = true ];then
    echo -n >&2 "\nChecking if database exists..."
    if [ -z "$db_host" ]; then
        if [[ $(mysql -S $DB_SOCKET -P $db_port -u $MYSQL_USER --password=$MYSQL_PASSWORD -e "USE $MYSQL_DATABASE") ]]
        then
            echo "Table not exists ..."
            exit
        else
            echo "Table exists ..."
            # Check if table has records    
            if [[ $(mysql -S $DB_SOCKET -P $db_port -u $MYSQL_USER --password=$MYSQL_PASSWORD -e "SELECT user_name FROM $MYSQL_DATABASE.user WHERE user_name = 'admin';") ]]
            then
                echo "Table has records ..."
            else
                echo "Table is empty ..."
                echo >&2 "Importing config to database..."
                composer install --no-dev
                composer selfupdate
                php xcat Migration new
                php xcat Tool importAllSettings
                if [ -z "$ADMIN_EMAIL" ] || [ -z "$ADMIN_PASSWORD" ];then
                    echo >&2 "ADMIN_EMAIL or ADMIN_PASSWORD not set!"
                    exit
                else
                    echo -n >&2 "\n" 
                    printf $ADMIN_EMAIL'\n'$ADMIN_PASSWORD'\ny\n' | php xcat Tool createAdmin
                fi
                

                echo >&2 "Done"
                
            fi
        fi
    else
        echo -n >&2 "\nInitialize database..."
        if [[ $(mysql -h $db_host -P $db_port -u $MYSQL_USER --password=$MYSQL_PASSWORD -e "USE $MYSQL_DATABASE") ]]
        then
            echo "Table not exists ..."
            exit
        else
            echo "Table exists ..."
            # Check if table has records    
            if [[ $(mysql -h $db_host -P $db_port -u $MYSQL_USER --password=$MYSQL_PASSWORD -e "SELECT user_name FROM $MYSQL_DATABASE.user WHERE user_name = 'admin';") ]]
            then
                echo "Table has records ..."
            else
                echo "Table is empty ..."
                echo >&2 "Importing config to database..."
                composer install --no-dev
                composer selfupdate
                php xcat Migration new
                php xcat Tool importAllSettings
                if [ -z "$ADMIN_EMAIL" ] || [ -z "$ADMIN_PASSWORD" ];then
                    echo >&2 "ADMIN_EMAIL or ADMIN_PASSWORD not set!"
                    exit
                else
                    echo -n >&2 "\n" 
                    printf $ADMIN_EMAIL'\n'$ADMIN_PASSWORD'\ny\n' | php xcat Tool createAdmin
                fi
                

                echo >&2 "Done"
            fi
        fi
    fi
# fi

echo -n >&2 "\nChecking if client binaries exist..."

if [ ! -d "public/clients" ]; then
	echo >&2 "Not found"
	echo -n >&2 "\nDownloading client binaries...\n\n"
	php xcat ClientDownload
else
	echo >&2 "Found"
fi

current_dir=$(pwd)
crontab -l > cron.tmp
echo "*/5 * * * * php $current_dir/xcat Cron" >> cron.tmp
crontab cron.tmp
rm cron.tmp
crond -b

echo -n >&2 "\nApplying permissions..."
chown $php_user_group -R "$current_dir"/*
chmod 755 -R $current_dir/*
# chown www-data:www-data -R *
# chmod -R 777 storage

echo >&2  "\nAll set, please enjoy!\n\n"


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

    if [ -z "$WebAPI" ];then
        echo >&2 "webAPI not set!"
        WebAPI=true
    fi

    if [ -z "$muKey" ];then
        echo >&2 "muKey not set!"
        exit
    fi

    if [ -z "$checkNodeIp" ];then
        echo >&2 "checkNodeIp not set! using true "
        checkNodeIp=true
    fi
    
    if [ -z "$db_host" ] && [ -z "$db_socket" ];then
        echo >&2 "db_host or DB_SOCKET not set!"
        exit
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

    if [ -z "$enable_db_rw_split" ];then
        echo >&2 "enable_db_rw_split not set! using false"
        enable_db_rw_split=false
    fi

    if [ -z "$read_db_hosts" ];then
        echo >&2 "read_db_hosts not set! using ['']"
        read_db_hosts=['']
    fi

    if [ -z "$write_db_host" ];then
        echo >&2 "write_db_host not set! using ''"
        write_db_host=''
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

    if [ -z "$redis_host" ];then
        echo >&2 "redis_host not set! using default"
        redis_host='redis'
    fi

    if [ -z "$redis_port" ];then
        echo >&2 "redis_port not set! using default"
        redis_port=6379
    fi    

    if [ -z "$redis_connect_timeout" ];then
        echo >&2 "redis_connect_timeout not set!, using default 2.0"
        redis_connect_timeout=2.0
    fi

    if [ -z "$redis_read_timeout" ];then
        echo >&2 "redis_read_timeout not set!, using default 8.0"
        redis_read_timeout=8.0
    fi

    if [ -z "$redis_username" ];then
        echo >&2 "redis_username not set!"
        redis_username=''
    fi

    if [ -z "$redis_password" ];then
        echo >&2 "redis_password not set!"
        redis_password=''
    fi

    if [ -z "$redis_ssl" ];then
        echo >&2 "redis_ssl not set!"
        redis_ssl=false
    fi

    if [ -z "$redis_ssl_context" ];then
        echo >&2 "redis_ssl_context not set!"
        redis_ssl_context=[]
    fi

    if [ -z "$enable_rate_limit" ];then
        echo >&2 "enable_rate_limit not set!"
        enable_rate_limit=false
    fi

    if [ -z "$rate_limit_ip" ];then
        echo >&2 "rate_limit_ip not set!"
        rate_limit_ip=120
    fi

    if [ -z "$rate_limit_sub" ];then
        echo >&2 "rate_limit_sub not set!"
        rate_limit_sub=30
    fi

    if [ -z "$rate_limit_webapi" ];then
        echo >&2 "rate_limit_webapi not set!"
        rate_limit_webapi=600
    fi

    if [ -z "$rate_limit_admin_api" ];then
        echo >&2 "rate_limit_admin_api not set!"
        rate_limit_admin_api=60
    fi

    if [ -z "$rate_limit_user_api" ];then
        echo >&2 "rate_limit_user_api not set!"
        rate_limit_user_api=60
    fi

    if [ -z "$mail_filter" ];then
        echo >&2 "mail_filter not set!, using 0 (disable)"
        mail_filter=0
    fi
    if [ -z "$mail_filter_list" ];then
        echo >&2 "mail_filter_list not set!, using ["qq.com", "vip.qq.com", "foxmail.com"]"
        mail_filter_list=[]
    fi

    if [ -z "$class_expire_reset_traffic" ];then
        echo >&2 "class_expire_reset_traffic not set!, using 0 "
        class_expire_reset_traffic=0
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
    
    if [ -z "$Subscribe" ];then
        echo >&2 "Subscribe not set!, using true "
        Subscribe=true
    fi

    if [ -z "$sub_token_len" ];then
        echo >&2 "sub_token_len not set! using default 16"
        sub_token_len=16
    fi

    if [ -z "$subUrl" ];then
        echo >&2 "subUrl not set!, using ${baseUrl} "
        subUrl=$baseUrl
    fi

    if [ -z "$auto_detect_ban_allow_admin" ];then
        echo >&2 "auto_detect_ban_allow_admin not set!, using true "
        auto_detect_ban_allow_admin=true
    fi

    if [ -z "$auto_detect_ban_allow_users" ];then
        echo >&2 "auto_detect_ban_allow_users not set!, using [] "
        auto_detect_ban_allow_users=[]
    fi

    if [ -z "$auto_detect_ban_number" ];then
        echo >&2 "auto_detect_ban_number not set!, using 30 "
        auto_detect_ban_number=30
    fi
    if [ -z "$auto_detect_ban_time" ];then
        echo >&2 "auto_detect_ban_time not set!, using 60 "
        auto_detect_ban_time=60
    fi

    if [ -z "$detect_gfw_port" ];then
        echo >&2 "detect_gfw_port not set! using 443 "
        detect_gfw_port=443
    fi

    if [ -z "$detect_gfw_url" ];then
        echo >&2 "detect_gfw_url not set! using 443 "
        detect_gfw_url='https://check-host.net/check-tcp?host={ip}:{port}&node=ir1.node.check-host.net&node=ir3.node.check-host.net&node=ir5.node.check-host.net&node=ir6.node.check-host.net'
    fi

    if [ -z "$enable_detect_offline" ];then
        echo >&2 "enable_detect_offline not set! using true "
        enable_detect_offline=true
    fi

    if [ -z "$enable_login_bind_ip" ];then
        echo >&2 "enable_login_bind_ip not set! using false "
        enable_login_bind_ip=true
    fi
    if [ -z "$enable_login_bind_device" ];then
        echo >&2 "enable_login_bind_device not set! using true "
        enable_login_bind_device=true
    fi
    if [ -z "$rememberMeDuration" ];then
        echo >&2 "rememberMeDuration not set! using 7 "
        rememberMeDuration=7
    fi
    if [ -z "$timeZone" ];then
        echo >&2 "timeZone not set! using Asia/Tehran "
        timeZone="Asia/Tehran"
    fi
    if [ -z "$locale" ];then
        echo >&2 "locale not set! using fa-IR "
        locale="fa-IR"
    fi
    if [ -z "$theme" ];then
        echo >&2 "theme not set! using Asia/Tehran "
        theme="tabler"
    fi
    if [ -z "$jump_delay" ];then
        echo >&2 "jump_delay not set! using 1200 "
        jump_delay=1200
    fi
    
    if [ -z "$keep_connect" ];then
        echo >&2 "keep_connect not set! using false "
        keep_connect=false
    fi

    if [ -z "$jsdelivr_url" ];then
        echo >&2 "jsdelivr_url not set! using jsdelivr_url "
        jsdelivr_url='fastly.jsdelivr.net'
    fi

    if [ -z "$sentry_dsn" ];then
        echo >&2 "sentry_dsn not set! "
        sentry_dsn=""
    fi

    if [ -z "$maxmind_license_key" ];then
        echo >&2 "maxmind_license_key not set! "
        maxmind_license_key="local"
    fi

    if [ -z "$geoip_locale" ];then
        echo >&2 "geoip_locale not set! "
        geoip_locale="en"
    fi

    if [ -z "$llm_backend" ];then
        echo >&2 "llm_backend not set! "
        llm_backend="openai"
    fi

    if [ -z "$openai_api_key" ];then
        echo >&2 "openai_api_key not set! "
        openai_api_key=""
    fi

    if [ -z "$openai_model" ];then
        echo >&2 "openai_model not set! using gpt-4-turbo-preview "
        openai_model="gpt-4-turbo-preview"
    fi

    if [ -z "$google_ai_api_key" ];then
        echo >&2 "google_ai_api_key not set!"
        google_ai_api_key=""
    fi

    if [ -z "$google_ai_model_id" ];then
        echo >&2 "google_ai_model_id not set! using gemini-pro"
        google_ai_model_id="gemini-1.5-pro-latest"
    fi

    if [ -z "$vertex_ai_access_token" ];then
        echo >&2 "vertex_ai_access_token not set!"
        vertex_ai_access_token=""
    fi

    if [ -z "$vertex_ai_location" ];then
        echo >&2 "vertex_ai_location not set! using us-central1"
        vertex_ai_location="us-central1"
    fi

    if [ -z "$vertex_ai_model_id" ];then
        echo >&2 "vertex_ai_model_id not set! using gemini-pro"
        vertex_ai_model_id="gemini-1.0-pro"
    fi

    if [ -z "$vertex_ai_project_id" ];then
        echo >&2 "vertex_ai_project_id not set!"
        vertex_ai_project_id=""
    fi

    if [ -z "$huggingface_api_key" ];then
        echo >&2 "huggingface_api_key not set!"
        huggingface_api_key=""
    fi

    if [ -z "$huggingface_endpoint_url" ];then
        echo >&2 "huggingface_endpoint_url not set!"
        huggingface_endpoint_url=""
    fi

    if [ -z "$github_access_token" ];then
        echo >&2 "github_access_token not set! "
        github_access_token=""
    fi

    if [ -z "$cf_workers_ai_account_id" ];then
        echo >&2 "cf_workers_ai_account_id not set!"
        cf_workers_ai_account_id=""
    fi
    if [ -z "$cf_workers_ai_api_token" ];then
        echo >&2 "cf_workers_ai_api_token not set!"
        cf_workers_ai_api_token=""
    fi
    if [ -z "$cf_workers_ai_model_id" ];then
        echo >&2 "cf_workers_ai_model_id not set! using @cf/meta/llama-2-7b-chat-int8"
        cf_workers_ai_model_id="@cf/meta/llama-2-7b-chat-int8"
    fi

    if [ -z "$anthropic_api_key" ];then
        echo >&2 "anthropic_api_key not set!"
        anthropic_api_key=""
    fi
    if [ -z "$anthropic_model_id" ];then
        echo >&2 "anthropic_model_id not set! using claude-3-opus-20240229"
        anthropic_model_id="claude-3-opus-20240229"
    fi


    if [ -z "$enable_r2_client_download" ];then
        echo >&2 "r2_bucket_name not set! using false"
        enable_r2_client_download = false
    fi
    if [ -z "$r2_bucket_name" ];then
        echo >&2 "r2_bucket_name not set! "
    fi
    if [ -z "$r2_account_id" ];then
        echo >&2 "r2_account_id not set! "
    fi
    if [ -z "$r2_access_key_id" ];then
        echo >&2 "r2_access_key_id not set! "
    fi
    if [ -z "$r2_access_key_secret" ];then
        echo >&2 "r2_access_key_secret not set! "
    fi
    if [ -z "$r2_client_download_timeout" ];then
        echo >&2 "r2_client_download_timeout not set! using default "
        r2_client_download_timeout = 10
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
\$_ENV['key']           = '$key';                       //Cookie encryption key, please be sure to modify this key to a random string
\$_ENV['pwdMethod']     = '$pwdMethod';                 //Password encryption optional md5, sha256, bcrypt, argon2i, argon2id
\$_ENV['salt']          = '$salt';                      //Recommended for md5/sha256， bcrypt/argon2i/argon2id will ignore this

\$_ENV['debug']         = $debug;                       //debug mode switch，The production environment should be kept as false
\$_ENV['appName']       = '$appName';                   // Site name
\$_ENV['baseUrl']       = '$baseUrl';                   // site address

\$_ENV['webAPI']        = $WebAPI;                      // Whether to enable the WebAPI function
\$_ENV['webAPIUrl']     = \$_ENV['baseUrl'];            //WebAPI地址，如需和站点名称相同，请不要修改
\$_ENV['muKey']         = '$muKey';                     //WebAPI Key, used for communication between the node server and the panel，请务必修改此key为随机字符串
\$_ENV['checkNodeIp']   = $checkNodeIp;                 //Whether webapi verifies node ip

//database settings--------------------------------------------------------------------------------------------
// db_host|db_socket Choose one of the two, if set db_socket then db_host Will be ignored, please leave blank. If the database is on the local machine it is recommended to use db_socket。
// db_host example: localhost (resolvable hostname), 127.0.0.1（IP address）, 10.0.0.2:4406（With port)
// db_socket example：/var/run/mysqld/mysqld.sock（Absolute address is required）
\$_ENV['db_host']      = '$db_host';
\$_ENV['db_socket']    = '$db_socket';
\$_ENV['db_database']  = '$MYSQL_DATABASE';           //Database name
\$_ENV['db_username']  = '$MYSQL_USER';               //database username
\$_ENV['db_password']  = '$MYSQL_PASSWORD';           //The password corresponding to the username
\$_ENV['db_port']      = '$db_port';                  //database poprt
# Read and write separation related configurations
\$_ENV['enable_db_rw_split'] = $enable_db_rw_split;         // turn on read-write separation
\$_ENV['read_db_hosts']      = $read_db_hosts;          // Slave library address, multiple configurable
\$_ENV['write_db_host']      = '$write_db_host';            // Main library address
#advanced
\$_ENV['db_charset']   = '$db_charset';
\$_ENV['db_collation'] = '$db_collation';
\$_ENV['db_prefix']    = '$db_prefix';

//Redis settings-------------------------------------------------------------------------------------------
\$_ENV['redis_host']             = '$redis_host';             //Redis address
\$_ENV['redis_port']             = $redis_port;               //Redis port
\$_ENV['redis_connect_timeout']  = $redis_connect_timeout;    //Redis connection timeout, in seconds
\$_ENV['redis_read_timeout']     = $redis_read_timeout;       //Redis connection timeout, in seconds
\$_ENV['redis_username']         = '$redis_username';         //Redis username, leave it blank to connect without username
\$_ENV['redis_password']         = '$redis_password';         //Redis password, leave blank to have no password
\$_ENV['redis_ssl']              = $redis_ssl;                //Whether to use SSL to connect to Redis. If SSL is used, the Redis port should be the TLS port of the Redis instance.
\$_ENV['redis_ssl_context']      = $redis_ssl_context;        //Whether to use SSL to connect to Redis. If SSL is used, the Redis port should be the TLS port of the Redis instance.

//Rate Limit setting--------------------------------------------------------------------------------------------
\$_ENV['enable_rate_limit']    = $enable_rate_limit;         //Whether to enable request restriction
\$_ENV['rate_limit_ip']        = $rate_limit_ip;             //Global request limit per minute per IP
\$_ENV['rate_limit_sub']       = $rate_limit_sub;            //Subscription link request limit per user per minute
\$_ENV['rate_limit_webapi']    = $rate_limit_webapi;         //WebAPI key request limit per minute per node
\$_ENV['rate_limit_user_api']  = $rate_limit_user_api;       //API request limit per user per minute
\$_ENV['rate_limit_admin_api'] = $rate_limit_admin_api;      //API request limit per admin per minute

//E-Mail settings--------------------------------------------------------------------------------------------
\$_ENV['mail_filter']        = $mail_filter;                 //0: off; 1: whitelist mode; 2; blacklist mode;
\$_ENV['mail_filter_list']   = $mail_filter_list;

#advanced
\$_ENV['class_expire_reset_traffic'] = $class_expire_reset_traffic;  //The traffic value to reset to when the level expires, in GB, if it is less than 0, it will not be reset
\$_ENV['enable_kill']                = $enable_kill;                 //Whether to allow users to log out of accounts
\$_ENV['enable_change_email']        = $enable_change_email;         //Whether to allow users to change account email

#Email reminder for insufficient user data allowance
\$_ENV['notify_limit_mode']          = $notify_limit_mode;          //false is closed, per is reminded according to percentage, mb is reminded according to fixed remaining flow
\$_ENV['notify_limit_value']         = $notify_limit_value;         //When the previous item is per, fill in the percentage here; when the previous item is mb, fill in the traffic here

//subscription settings---------------------------------------------------------------------------------------
\$_ENV['Subscribe']                  = $Subscribe;            //Does this site provide a subscription function?
\$_ENV['subUrl']                     = '$subUrl';             //Subscription address, if it needs to be the same as the site name, please do not modify
\$_ENV['sub_token_len']              = $sub_token_len;        //订阅token长度

//Audit auto-ban settings--------------------------------------------------------------------------------------------
\$_ENV['auto_detect_ban_allow_admin'] = $auto_detect_ban_allow_admin;        // Administrators are not subject to audit restrictions
\$_ENV['auto_detect_ban_allow_users'] = $auto_detect_ban_allow_users;        // Exception User IDs for Audit Bans
\$_ENV['auto_detect_ban_number']      = $auto_detect_ban_number;             // The number of procs needed to enforce a ban in mercy mode
\$_ENV['auto_detect_ban_time']        = $auto_detect_ban_time;               // The duration of each ban in mercy mode (minutes)

//node detection-----------------------------------------------------------------------------------------------
#GFW detection, please [enable/disable] through crontab
\$_ENV['detect_gfw_port']                 = $detect_gfw_port;   //The TCP port opened by all node servers, commonly used is 22 (SSH port)
\$_ENV['detect_gfw_url']                  = '$detect_gfw_url';  //The URL of the API that detects whether the node is blocked by gfw

#offline detection
\$_ENV['enable_detect_offline']           = $enable_detect_offline;

\$_ENV['enable_login_bind_ip']   = $enable_login_bind_ip;               //Whether to bind the login thread to the IP
\$_ENV['enable_login_bind_device']     = $enable_login_bind_device;     //bind the login thread to the device
\$_ENV['rememberMeDuration']     = $rememberMeDuration;                 //Remember the number of days of account duration when logging in
\$_ENV['timeZone']               = '$timeZone';                         //Requires a PHP-compatible timezone format
\$_ENV['locale']                  = '$locale';                          //Default language
\$_ENV['theme']                  = '$theme';                            //Default Theme
\$_ENV['jump_delay']             = $jump_delay;                         //Jump delay, in ms, it is not recommended to be too long
\$_ENV['keep_connect']           = $keep_connect;                       // Speed limit to 1Mbps for traffic exhausted users

\$_ENV['jsdelivr_url'] = '$jsdelivr_url'; // cdn.jsdelivr.net / fastly.jsdelivr.net / gcore.jsdelivr.net / testingcf.jsdelivr.net

// https://sentry.io for production debugging
\$_ENV['sentry_dsn'] = '$sentry_dsn';

// Maxmind GeoIP2 database
\$_ENV['maxmind_license_key'] = '$maxmind_license_key';
\$_ENV['geoip_locale'] = '$geoip_locale';

// Large language model powered ticket reply and more
\$_ENV['llm_backend'] = '$llm_backend'; // openai/palm/huggingface/cf-workers-ai

// OpenAI API Key for GPT powered ticket reply and more
\$_ENV['openai_api_key'] = '$openai_api_key';
\$_ENV['openai_model'] = '$openai_model';
// Google PaLM API
\$_ENV['google_ai_api_key'] = '$google_ai_api_key';
\$_ENV['google_ai_model_id'] = '$google_ai_model_id';
// Vertex AI API
\$_ENV['vertex_ai_access_token'] = '$vertex_ai_access_token';
\$_ENV['vertex_ai_location'] = '$vertex_ai_location';
\$_ENV['vertex_ai_model_id'] = '$vertex_ai_model_id';
\$_ENV['vertex_ai_project_id'] = '$vertex_ai_project_id';
// Hugging Face Inference API
\$_ENV['huggingface_api_key'] = '$huggingface_api_key';
\$_ENV['huggingface_endpoint_url'] = '$huggingface_endpoint_url';
// Cloudflare Workers AI
\$_ENV['cf_workers_ai_account_id']      = '$cf_workers_ai_account_id';
\$_ENV['cf_workers_ai_api_token']       = '$cf_workers_ai_api_token';
\$_ENV['cf_workers_ai_model_id']         = '$cf_workers_ai_model_id';
// Anthropic
\$_ENV['anthropic_api_key']      = '$anthropic_api_key';
\$_ENV['anthropic_model_id']       = '$anthropic_model_id';

// ClientDownload command resolves the restricted use of Github access tokens due to the high frequency of API access
\$_ENV['github_access_token'] = '$github_access_token';

// use Cloudflare R2 for clients download
\$_ENV['enable_r2_client_download'] = '$enable_r2_client_download';
\$_ENV['r2_bucket_name'] = '$r2_bucket_name';
\$_ENV['r2_account_id'] = '$r2_account_id';
\$_ENV['r2_access_key_id'] = '$r2_access_key_id';
\$_ENV['r2_access_key_secret'] = '$r2_access_key_secret';
\$_ENV['r2_client_download_timeout'] = '$r2_client_download_timeout' ;


\$_ENV['cdn_forwarded_ip'] = array('HTTP_X_FORWARDED_FOR', 'HTTP_ALI_CDN_REAL_IP', 'X-Real-IP', 'True-Client-Ip');
foreach (\$_ENV['cdn_forwarded_ip'] as \$cdn_forwarded_ip) {
    if (isset(\$_SERVER[\$cdn_forwarded_ip])) {
        \$list = explode(',', \$_SERVER[\$cdn_forwarded_ip]);
        \$_SERVER['REMOTE_ADDR'] = \$list[0];
        break;
    }
}

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
                echo "Install Composer ..."
                composer install --no-dev
                composer selfupdate
                echo "Table is empty ..."
                echo >&2 "Importing config to database..."
                php xcat Migration new
                php xcat Tool importSettings
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
                echo "Install Composer ..."
                composer install --no-dev
                composer selfupdate
                echo "Table is empty ..."
                echo >&2 "Importing config to database..."
                php xcat Migration new
                php xcat Tool importSettings
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

current_dir=$(pwd)
crontab -l > cron.tmp
./cron.tmp
if ! grep -q "\*\/5 \* \* \* \* php /var/www/html/xcat Cron" cron.tmp; then
    echo "*/5 * * * * php $current_dir/xcat Cron" > cron.tmp
    crontab cron.tmp
fi
rm cron.tmp
crond -b

echo -n >&2 "\nApplying permissions..."
chmod 755 -R $current_dir/*
chown -R nginx:nginx *
echo -n >&2 "\nDownloading Clients..."
sudo -u nginx php xcat ClientDownload
chmod -R 755 storage
chown -R nginx:nginx *
git config core.fileMode false

echo >&2  "\nAll set, please enjoy!\n\n"


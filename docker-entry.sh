
echo >&2 " _____ _____ _____             _ "
echo >&2 "|   __|   __|  _  |___ ___ ___| |"
echo >&2 "|__   |__   |   __| .'|   | -_| |"
echo >&2 "|_____|_____|__|  |__,|_|_|___|_|"
                                 
echo -n >&2 "\nChecking if installation exists..."

# some configurations for let's encrypt

if [ ! -e public/index.php ]; then
    echo  >&2 "Not found"
    exit
else
    echo >&2 "Found"
fi

echo -n >&2 "\nChecking environment..."

if [ -z "$API_KEY" ]; then
    echo >&2 "API_KEY not set!"
    exit
fi
if [ -z "$PANEL_DOMAIN" ];then
    echo >&2 "PANEL_DOMAIN not set!"
    exit
fi
if [ -z "$APP_NAME" ];then
    echo >&2 "APP_NAME not set!"
    exit
fi
if [ -z "$MUKEY" ];then
    echo >&2 "MUKEY not set!"
    exit
fi
if [ -z "$DB_HOST" ] && [ -z "$DB_SOCKET" ];then
    echo >&2 "DB_HOST or DB_SOCKET not set!"
    exit
fi
if [ -z "$DB_PORT" ];then
    echo >&2 "DB_PORT not set!"
    exit
fi
if [ -z "$DB_DATABASE" ];then
    echo >&2 "DB_DATABASE not set!"
    exit
fi
if [ -z "$DB_PASSWORD" ] && [ -z "$DB_USERNAME" ];then
    echo >&2 "DB_USERNAME or DB_PASSWORD not set!"
    exit
fi
if [ -z "$ADMIN_EMAIL" ] && [ -z "$ADMIN_PASSWORD" ];then
    echo >&2 "ADMIN_EMAIL or ADMIN_PASSWORD not set!"
    exit
fi
if [ -z "$TIME_ZONE" ];then
    echo >&2 "DB_DATABASE not set!"
    exit
fi
if [ -z "$STREAMING_UNLOCK" ];then
    echo >&2 "STREAMING_UNLOCK not set!"
    STREAMING_UNLOCK=false
fi
if [ -z "$GITHUB_ACCESS_TOKEN" ];then
    echo >&2 "GITHUB_ACCESS_TOKEN not set!"
    GITHUB_ACCESS_TOKEN=false
fi
if [ -z "$DEBUG" ];then
    echo >&2 "DEBUG not set!"
    DEBUG=false
fi

if [ "$ENABLE_TELEGRAM" = true ];then 
    if [ -z "$TELEGRAM_CHAT_ID" ];then
        echo >&2 "TELEGRAM_CHAT_ID not set!"
        exit
    fi
    if [ -z "$TELEGRAM_BOT" ];then
        echo >&2 "TELEGRAM_BOT not set!"
        exit
    fi
    if [ -z "$TELEGRAM_TOKEN" ];then
        echo >&2 "TELEGRAM_TOKEN not set!"
        exit
    fi
fi

# if [ "$B2_BACKUP" = true ];then
#     echo >&2 "B2_BACKUP set!"
#     if [ -z "$B2_APP_KEY_ID" ];then
#         echo >&2 "B2_APP_KEY_ID not set!"
#         exit
#     fi
#     if [ -z "$B2_APP_KEY" ];then
#         echo >&2 "B2_APP_KEY not set!"
#         exit
#     fi
#     if [ -z "$B2_BUCKET_NAME" ];then
#         echo >&2 "B2_BUCKET_NAME not set!"
#         exit
#     fi
#     if [ -z "$B2_BACKUP_NAME" ];then
#         echo >&2 "B2_BACKUP_NAME not set!... using default SSPANEL"
#         B2_BACKUP_NAME = "SSPANEL"
#     fi
#     if [ -z "$B2_COMPRESS_METHOD" ];then
#         echo >&2 "B2_BACKUP_NAME not set!... using default ZIP"
#         B2_COMPRESS_METHOD = "zip"
#     fi
# fi
echo >&2 "Done"

if [ "$IS_SSL" = true ];then
    mv /etc/nginx/conf.d/site.conf /etc/nginx/conf.d/site.conf.template
    mv /etc/nginx/conf.d/site_ssl.conf.template /etc/nginx/conf.d/site_ssl.conf
    # openssl req -x509 -newkey rsa:2048 -keyout /etc/nginx/ssl/selfsigned.key -out /etc/nginx/ssl/selfsigned.crt -days 3650 -nodes -subj "/C=GB/ST=London/L=London/O=Google Trust Services LLC/CN=www.google.com"
fi

if [ ! -f config/.config.php ];then
    cp /var/www/config/.config.example.php /var/www/config/.config.php
    cp /var/www/config/appprofile.example.php /var/www/config/appprofile.php
    INIT=true
    echo >&2 "Start Init"
fi

if [ "$INIT" = true ];then
    echo "Writting configuration..."
    sed -i -e "s/\$_ENV\['key'].*=.*'ChangeMe';/\$_ENV['key']        = '$API_KEY';/g" \
    -e "s/\$_ENV\['appName'].*=.*'SSPanel-UIM';/\$_ENV['appName']        = '$APP_NAME';/g" \
    -e "s|\$_ENV\['baseUrl'].*=.*'https://example.com';|\$_ENV['baseUrl']        = 'https://$PANEL_DOMAIN';|g" \
    -e "s|\$_ENV\['muKey'].*=.*'SSPanel';|\$_ENV['muKey']        = '$MUKEY';|g" \
    -e "s|\$_ENV\['db_host'].*=.*'';|\$_ENV['db_host']        = '$DB_HOST';|g" \
    -e "s|\$_ENV\['db_database'].*=.*'sspanel';|\$_ENV['db_database']        = '$DB_DATABASE';|g" \
    -e "s|\$_ENV\['db_username'].*=.*'root';|\$_ENV['db_username']        = '$DB_USERNAME';|g" \
    -e "s|\$_ENV\['db_password'].*=.*'sspanel';|\$_ENV['db_password']        = '$DB_PASSWORD';|g" \
    -e "s|\$_ENV\['timeZone'].*=.*'PRC';|\$_ENV['timeZone']        = '$TIME_ZONE';|g" \
    -e "s|\$_ENV\['timeZone'].*=.*'PRC';|\$_ENV['timeZone']        = '$TIME_ZONE';|g" \
    -e "s|\$_ENV\['php_user_group'].*=.*'www:www';|\$_ENV['php_user_group']        = 'www-data:www-data';|g" \
    config/.config.php

    if [ "$STREAMING_UNLOCK" = true ];then
        sed -i -e "s/\/\/'397' => '4',/'397' => '4',/g" \
        -e "s/\/\/'297' => '4',/'297' => '4',/g" \
        config/.config.php
    fi

    if [ "$GITHUB_ACCESS_TOKEN" != false ];then
        sed -i -e "s/\$_ENV\['github_access_token'].*=.*false;/\$_ENV['github_access_token']        = '$GITHUB_ACCESS_TOKEN';/g" \
        config/.config.php
    fi

    if [ "$DEBUG" = true ];then
        sed -i -e "s/\$_ENV\['debug'].*=.*false;/\$_ENV['debug']        = true;/g" \
        config/.config.php
    else
        sed -i -e "s/\$_ENV\['debug'].*=.*false;/\$_ENV['debug']        = false;/g" \
        config/.config.php
    fi

    if [ "$ENABLE_TELEGRAM" = true ];then
        echo "Writting Telegram configuration..."
        sed -i -e "s/\$_ENV\['enable_telegram'].*=.*false;/\$_ENV['enable_telegram']        = '$ENABLE_TELEGRAM';/g" \
        -e "s/\$_ENV\['telegram_token'].*=.*'';/\$_ENV['telegram_token']        = '$TELEGRAM_TOKEN';/g" \
        -e "s/\$_ENV\['telegram_chatid'].*=.*-111;/\$_ENV['telegram_chatid']        = '$TELEGRAM_CHAT_ID';/g" \
        -e "s/\$_ENV\['telegram_bot'].*=.*'_bot';/\$_ENV['telegram_bot']        = '$TELEGRAM_BOT';/g" \
        -e "s/\$_ENV\['enable_telegram_login'].*=.*false;/\$_ENV['enable_telegram_login']        = $TELEGRAM_LOGIN;/g" \
        config/.config.php
    fi


#     WEBSITE_DIR=$(pwd)
#     B2_CONF=b2_backup_config
#     if [ "$B2_BACKUP" = true ] && [ ! -f "$B2_CONF" ];then
#     tee -a $B2_CONF > /dev/null <<EOT
#     backup_name="$B2_BACKUP_NAME"
#     b2_app_key_id="$B2_APP_KEY_ID"
#     b2_app_key="$B2_APP_KEY"
#     b2_bucket_name="$B2_BUCKET_NAME"
#     db_name="$DB_DATABASE"
#     db_password='$DB_PASSWORD'
#     db_user="$DB_USERNAME"
#     db_host="$DB_HOST"
#     compress_method="$B2_COMPRESS_METHOD"
#     website_dir="$WEBSITE_DIR"
# EOT
#     fi

fi

echo -n >&2 "\nChecking connection to database..."

if [ -z "$DB_HOST" ]; then
    if ! mysql -S $DB_SOCKET -P $DB_PORT -u $DB_USERNAME --password=$DB_PASSWORD -e "SELECT VERSION()" > /dev/null; then
        echo >&2 "Cannot connect to database!"
    fi
else
    if ! mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME --password=$DB_PASSWORD -e "SELECT VERSION()" > /dev/null; then
        echo >&2 "Cannot connect to database!"
        exit
    fi
fi

echo >&2 "Good"
if [ "$INIT" = true ];then
    echo -n >&2 "\nChecking if database exists..."

    if [ -z "$DB_HOST" ]; then
        if mysql -S $DB_SOCKET -P $DB_PORT -u $DB_USERNAME --password=$DB_PASSWORD -e "USE $DB_DATABASE" > /dev/null; then
            echo -n >&2 "\nInitialize database..."
            temp_sql_result=$(mysql -S $DB_SOCKET -P $DB_PORT -u $DB_USERNAME --password=$DB_PASSWORD -e "SELECT user_name FROM $DB_DATABASE.user WHERE user_name = 'admin';")
            if [ -z "$temp_sql_result" ]; then
                echo >&2 "Importing config to database..."
                php vendor/bin/phinx migrate
                php xcat Tool importAllSettings
            fi
            # mysql -S $DB_SOCKET -P $DB_PORT -u $DB_USERNAME --password=$DB_PASSWORD -e "CREATE DATABASE $DB_DATABASE CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
            echo >&2 "Done"
        else
            echo >&2 "\nCould not connect to database with Database Socket..."
            exit
        fi
    else

        if mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME --password=$DB_PASSWORD -e "USE $DB_DATABASE" > /dev/null; then
            echo -n >&2 "\nInitialize database..."
            temp_sql_result=$(mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME --password=$DB_PASSWORD -e "SELECT user_name FROM $DB_DATABASE.user WHERE user_name = 'admin';")
            if [ -z "$temp_sql_result" ]; then
                echo >&2 "Importing config to database..."
                php vendor/bin/phinx migrate
                php xcat Tool importAllSettings
            fi
            # mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME --password=$DB_PASSWORD -e "CREATE DATABASE $DB_DATABASE CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
        
            echo >&2 "Done"
        else
            echo >&2 "\nCould not connect to database with Database Host..."
        fi
    fi


    echo -n >&2 "\nApplying permissions..."
    chmod 755 -R *
    # chown www-data:www-data -R *
    chmod -R 777 storage

    echo >&2 "Done"

    echo -n >&2 "\nChecking if admin account exists..."

    if [ -z "$DB_HOST" ]; then
        temp_sql_result=$(mysql -S $DB_SOCKET -P $DB_PORT -u $DB_USERNAME --password=$DB_PASSWORD -e "SELECT user_name FROM $DB_DATABASE.user WHERE user_name = 'admin';")
    else
        temp_sql_result=$(mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME --password=$DB_PASSWORD -e "SELECT user_name FROM $DB_DATABASE.user WHERE user_name = 'admin';")
    fi

    if [ -z "$temp_sql_result" ]; then
        echo >&2 "Not found"
        echo -n >&2 "\nAttemping to create admin account..."
        if [ -z "$ADMIN_EMAIL" ] || [ -z "$ADMIN_PASSWORD" ];then
            echo >&2 "ADMIN_EMAIL or ADMIN_PASSWORD not set!"
        else
        echo -n >&2 "\n" 
            printf $ADMIN_EMAIL'\n'$ADMIN_PASSWORD'\ny\n' | php xcat Tool createAdmin
        fi
    fi
fi
echo -n >&2 "\nChecking if client binaries exist..."

if [ ! -d "public/clients" ]; then
	echo >&2 "Not found"
	echo -n >&2 "\nDownloading client binaries...\n\n"
	php xcat ClientDownload
else
	echo >&2 "Found"
fi

echo >&2  "\nAll set, please enjoy!\n\n"

/usr/bin/supervisord -c /etc/supervisord.conf -n

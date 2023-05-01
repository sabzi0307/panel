
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
if [ -z "$GITHUB_ACCESS_TOKEN" ];then
    echo >&2 "GITHUB_ACCESS_TOKEN not set!"
    GITHUB_ACCESS_TOKEN=false
fi
if [ -z "$DEBUG" ];then
    echo >&2 "DEBUG not set!"
    DEBUG=false
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

# NGINX_CONF=/etc/nginx/conf.d/site.conf

# SSLTemp=
# if [ "$IS_SSL" = true ];then
#         cat > ${NGINX_CONF} <<-EOF
# server {
#     listen [::]:80 default_server;
#     listen 80 default_server;
#     server_name _;
#     sendfile off;
#     root /var/www/public;
#     index index.php index.html;

#     return 301 https://\$host\$request_uri;
# }   

# server {
#     listen [::]:443 ssl http2 default_server;
#     listen 443 ssl http2 default_server;
#     server_name _;
#     sendfile off;
#     root /var/www/public;
#     index index.php index.html;
#     ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
#     ssl_prefer_server_ciphers on;
#     ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;

#     ssl_certificate /etc/nginx/ssl/${PANEL_DOMAIN}/fullchain.cer; 
#     ssl_certificate_key /etc/nginx/ssl/${PANEL_DOMAIN}/${PANEL_DOMAIN}.key;


#     location / {
#         # First attempt to serve request as file, then
#         # as directory, then fall back to index.php
#         try_files \$uri \$uri/ /index.php\$is_args\$args;
#     }

#     error_page 500 502 503 504 /50x.html;

#     # pass the PHP scripts to FastCGI server
#     location ~ \.php$ {
#         fastcgi_split_path_info ^(.+\.php)(/.+)\$;
#         fastcgi_pass 127.0.0.1:9000;
#         fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
#         fastcgi_param SCRIPT_NAME \$fastcgi_script_name;
#         fastcgi_index index.php;
#         include /etc/nginx/fastcgi_params;
#     }

#     location ~* \.(jpg|jpeg|gif|png|css|js|ico|xml)$ {
#         expires 5d;
#     }

#     location /clients/clash/ {
#         alias /var/www/public/rules/;
#         types { }   default_type "text/plain";
#         sub_filter_types	text/plain;
#         sub_filter_once off;
#     }

#     if (\$request_uri ~ "^/redirect/(.*)(%3A%2F%2F|://)(.*)$") {
#     return 307 \$1://\$3;
#     }


#     location /ghr/ {
#         #for proxy github raw
#         proxy_set_header Host raw.githubusercontent.com;
#         proxy_pass https://raw.githubusercontent.com:443/;
#     }

#     location /gho/ {
#         #for proxy github object
#         proxy_set_header Host objects.githubusercontent.com;
#         proxy_pass https://objects.githubusercontent.com:443/;
#     }

#     location /gh/ {
#         #for proxy github
#         proxy_set_header Host github.com;
#         proxy_pass https://github.com:443/;
#         proxy_redirect https://raw.githubusercontent.com/ https://\$host/ghr/;
#         proxy_redirect https://objects.githubusercontent.com/ https://\$host/gho/;

#         proxy_set_header Accept-Encoding "";
#         sub_filter_once off;
#         sub_filter    https://github.com/ /gh/;
#         sub_filter    href="/ href="/gh/;
#         sub_filter    src="/ src="/gh/;
#     }

#     location /defaultusersecret/dns/ {
#         # use it in your browser as https://defaultserverhost/defaultusersecret/dns/dns-query{?dns}
#         proxy_pass https://dns.google:443/; 
#     }

#     # location /defaultusersecret/speedtest/ {
#     #     client_max_body_size 10000M;
#     #     proxy_pass          http://localhost:438/;
#     # }
# }

# EOF

# else
#     cat > ${NGINX_CONF} <<-EOF
# server {
#     listen [::]:80 default_server;
#     listen 80 default_server;
#     server_name _;
#     sendfile off;
#     root /var/www/public;
#     index index.php index.html;

#     location / {
#         # First attempt to serve request as file, then
#         # as directory, then fall back to index.php
#         try_files \$uri \$uri/ /index.php\$is_args\$args;
#     }

#     error_page 500 502 503 504 /50x.html;

#     # pass the PHP scripts to FastCGI server
#     location ~ \.php$ {
#         fastcgi_split_path_info ^(.+\.php)(/.+)$;
#         fastcgi_pass 127.0.0.1:9000;
#         fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
#         fastcgi_param SCRIPT_NAME \$fastcgi_script_name;
#         fastcgi_index index.php;
#         include /etc/nginx/fastcgi_params;
#     }

#     location ~* \.(jpg|jpeg|gif|png|css|js|ico|xml)$ {
#         expires 5d;
#     }

#     location /clients/clash/ {
#         alias /var/www/public/rules/;
#         types { }   default_type "text/plain";
#         sub_filter_types	text/plain;
#         sub_filter_once off;
#     }

#     if (\$request_uri ~ "^/redirect/(.*)(%3A%2F%2F|://)(.*)$") {
#     return 307 \$1://\$3;
#     }


#     location /ghr/ {
#         #for proxy github raw
#         proxy_set_header Host raw.githubusercontent.com;
#         proxy_pass https://raw.githubusercontent.com:443/;
#     }

#     location /gho/ {
#         #for proxy github object
#         proxy_set_header Host objects.githubusercontent.com;
#         proxy_pass https://objects.githubusercontent.com:443/;
#     }

#     location /gh/ {
#         #for proxy github
#         proxy_set_header Host github.com;
#         proxy_pass https://github.com:443/;
#         proxy_redirect https://raw.githubusercontent.com/ https://\$host/ghr/;
#         proxy_redirect https://objects.githubusercontent.com/ https://\$host/gho/;

#         proxy_set_header Accept-Encoding "";
#         sub_filter_once off;
#         sub_filter    https://github.com/ /gh/;
#         sub_filter    href="/ href="/gh/;
#         sub_filter    src="/ src="/gh/;
#     }

#     location /defaultusersecret/dns/ {
#         # use it in your browser as https://defaultserverhost/defaultusersecret/dns/dns-query{?dns}
#         proxy_pass https://dns.google:443/; 
#     }

#     # location /defaultusersecret/speedtest/ {
#     #     client_max_body_size 10000M;
#     #     proxy_pass          http://localhost:438/;
#     # }
# }
# EOF

#     # mv /etc/nginx/conf.d/site.conf /etc/nginx/conf.d/site.conf.template
#     # mv /etc/nginx/conf.d/site_ssl.conf.template /etc/nginx/conf.d/site_ssl.conf
#     # openssl req -x509 -newkey rsa:2048 -keyout /etc/nginx/ssl/selfsigned.key -out /etc/nginx/ssl/selfsigned.crt -days 3650 -nodes -subj "/C=GB/ST=London/L=London/O=Google Trust Services LLC/CN=www.google.com"
# fi

if [ ! -f conf/.config.php ];then
    cp /var/www/conf/.config.example.php /var/www/conf/.config.php
    cp /var/www/conf/appprofile.example.php /var/www/conf/appprofile.php
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
    conf/.config.php

    if [ "$GITHUB_ACCESS_TOKEN" != false ];then
        sed -i -e "s/\$_ENV\['github_access_token'].*=.*false;/\$_ENV['github_access_token']        = '$GITHUB_ACCESS_TOKEN';/g" \
        conf/.config.php
    fi

    if [ "$DEBUG" = true ];then
        sed -i -e "s/\$_ENV\['debug'].*=.*false;/\$_ENV['debug']        = true;/g" \
        conf/.config.php
    else
        sed -i -e "s/\$_ENV\['debug'].*=.*false;/\$_ENV['debug']        = false;/g" \
        conf/.config.php
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
                php xcat Migration new
                php xcat Tool importAllSettings
                if [ -z "$ADMIN_EMAIL" ] || [ -z "$ADMIN_PASSWORD" ];then
                    echo >&2 "ADMIN_EMAIL or ADMIN_PASSWORD not set!"
                    exit
                else
                echo -n >&2 "\n" 
                    printf $ADMIN_EMAIL'\n'$ADMIN_PASSWORD'\ny\n' | php xcat Tool createAdmin
                fi
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
                php xcat Migration new
                php xcat Tool importAllSettings
                if [ -z "$ADMIN_EMAIL" ] || [ -z "$ADMIN_PASSWORD" ];then
                    echo >&2 "ADMIN_EMAIL or ADMIN_PASSWORD not set!"
                    exit
                else
                echo -n >&2 "\n" 
                    printf $ADMIN_EMAIL'\n'$ADMIN_PASSWORD'\ny\n' | php xcat Tool createAdmin
                fi
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

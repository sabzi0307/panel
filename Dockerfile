FROM indexyz/php

COPY . /var/www
WORKDIR /var/www

ENV DB_PORT=3306


RUN apt-get -y install wget mariadb-server && \
    cp config/appprofile.example.php config/appprofile.php && \
    cp config/b2_backup_config.example config/b2_backup_config && \
    cp config/b2_backup.sh b2_backup.sh && \
    rm -rf /entrypoint.sh && \
    cp entrypoint.sh /entrypoint.sh && \
    chmod +x /entrypoint.sh && \
    cp -r config/rules public/clients/ && \
    chmod +x b2_backup.sh && \
    chmod -R 755 storage && \
    chmod -R 777 /var/www/storage/framework/smarty/compile/ && \
    mv db/migrations/20000101000000_init_database.php.new db/migrations/20000101000000_init_database.php && \
    curl -SL https://getcomposer.org/installer -o composer.phar && \
    php composer.phar && \
    php composer.phar install && \
    wget https://cdn.jsdelivr.net/gh/sspanel-uim/qqwry.dat@latest/qqwry.dat -O storage/qqwry.dat && \
    crontab -l | { cat; echo "30 23 * * * php /var/www/xcat SendDiaryMail"; } | crontab - && \
    crontab -l | { cat; echo "0 0 * * * php /var/www/xcat Job DailyJob"; } | crontab - && \
    crontab -l | { cat; echo "*/1 * * * * php /var/www/xcat Job CheckJob"; } | crontab - && \
    crontab -l | { cat; echo "0 */1 * * * php /var/www/xcat Job UserJob"; } | crontab - && \
    crontab -l | { cat; echo "5 0 * * * php /var/www/xcat FinanceMail day "; } | crontab - && \
    crontab -l | { cat; echo "6 0 * * 0 php /var/www/xcat FinanceMail week"; } | crontab - && \
    crontab -l | { cat; echo "7 0 1 * * php /var/www/xcat FinanceMail month"; } | crontab - && \
    crontab -l | { cat; echo "1 0 * * * /usr/bin/bash /var/www/b2_backup.sh backup config/b2_backup_config"; } | crontab - && \
    { \
        echo '[program:crond]'; \
        echo 'command=cron -f'; \
        echo 'autostart=true'; \
        echo 'autorestart=true'; \
        echo 'killasgroup=true'; \
        echo 'stopasgroup=true'; \
    } | tee /etc/supervisor/crond.conf
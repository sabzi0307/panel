FROM richarvey/nginx-php-fpm:2.1.2

LABEL maintainer="kontorol <kontorol.dev@gmail.com>"

RUN apk update && apk add mysql-client libxml2-dev && docker-php-ext-install bcmath xml bz2 bcmath
RUN rm -rf  /var/www/html/*
COPY ./  /var/www/html

WORKDIR  /var/www/html

RUN composer install --no-dev && composer selfupdate

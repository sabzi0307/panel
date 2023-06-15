FROM richarvey/nginx-php-fpm:latest

LABEL maintainer="kontorol <kontorol.dev@gmail.com>"

RUN apk update && apk add mysql-client libxml2-dev && docker-php-ext-install bcmath xml bz2 xdebug

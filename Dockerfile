FROM ttracy/nginx-php-fpm:latest

LABEL maintainer="kontorol <kontorol.dev@gmail.com>"

COPY ./ /var/www/html
RUN apk update && apk add mysql-client binutils sudo

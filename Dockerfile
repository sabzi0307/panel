FROM ttracy/nginx-php-fpm:latest

LABEL maintainer="kontorol <kontorol.dev@gmail.com>"

RUN apk update && apk add mysql-client binutils

FROM ttracy/nginx-php-fpm:latest

LABEL maintainer="kontorol <kontorol.dev@gmail.com>"

RUN apk update && apk add mysql-client binutils sudo yaml yaml-dev
ENV YAML_VERSION 2.0.2

ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions yaml
FROM ttracy/nginx-php-fpm:latest

LABEL maintainer="kontorol <kontorol.dev@gmail.com>"

RUN apk update && apk add mysql-client binutils sudo yaml yaml-dev
ENV YAML_VERSION 2.0.2

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions yaml

RUN sed -i "s/^GIT_COMMAND=\\'git clone \\'/\\1 --depth 1/" /start.sh
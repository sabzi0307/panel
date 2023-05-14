#!/usr/bin/env bash
# this scripts only works with richarvey/nginx-php-fpm:latest docker image

echo >&2 "start install php extensions"
/usr/local/lib/php/docker-php-ext-install bcmath xml bz2 bcmath
echo >&2 "complete install php extensions"
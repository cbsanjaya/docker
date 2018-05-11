#!/bin/sh

mkdir -p /var/nginx/client_body_temp
chown laravel:laravel /var/nginx/client_body_temp
mkdir -p /var/run/php/
chown laravel:laravel /var/run/php/
touch /var/log/php-fpm.log
chown laravel:laravel /var/log/php-fpm.log

if [ "$1" = 'app' ]; then
    exec supervisord --nodaemon --configuration="/etc/supervisord.conf" --loglevel=info
fi

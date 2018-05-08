#!/bin/sh

mkdir -p /var/nginx/client_body_temp
chown www-data:www-data /var/nginx/client_body_temp
mkdir -p /var/run/php/
chown www-data:www-data /var/run/php/
touch /var/log/php-fpm.log
chown www-data:www-data /var/log/php-fpm.log

if [ "$1" = 'app' ]; then
    exec supervisord --nodaemon --configuration="/etc/supervisord.conf" --loglevel=info
fi

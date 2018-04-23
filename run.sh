#!/bin/sh

if [ "$1" = 'app' ]; then
    exec supervisord --nodaemon --configuration="/etc/supervisord.conf" --loglevel=info
fi

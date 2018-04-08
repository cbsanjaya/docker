#!/bin/sh

if [ "$1" != '' ]; then
    gzip -d < $1 | mysql --user=$MYSQL_USER --password=$MYSQL_PASSWORD \
        $MYSQL_DATABASE
else
    echo 'masukkan nama file backup'
fi
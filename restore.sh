#!/bin/bash

if [ "$1" != '' ]; then
    FILE_NAME=/home/laravel/backup/$1.sql.gz

    gzip -d < $FILE_NAME | mysql --user=$MYSQL_USER \
        --password=$MYSQL_PASSWORD $MYSQL_DATABASE
else
    echo 'masukkan nama file backup'
fi
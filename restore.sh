#!/bin/sh

if [ "$1" != '' ]; then
    # test mysql
    mysqladmin --user=$MYSQL_USER --password=$MYSQL_PASSWORD
    # restore database test passed
    if [ $? -eq 0 ]; then
        gzip -d < $1 | mysql --user=$MYSQL_USER \
            --password=$MYSQL_PASSWORD $MYSQL_DATABASE
    fi
else
    echo 'masukkan nama file backup'
fi
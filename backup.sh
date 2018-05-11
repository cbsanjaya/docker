#!/bin/sh

if [ "$1" != '' ]; then
    FILE_NAME=$1.sql.gz
else
    POSTFIX="`date +%Y%m%d%H%M%S`";
    FILE_NAME=$MYSQL_DATABASE-$POSTFIX.sql.gz
fi

mysqldump --user=$MYSQL_USER --password=$MYSQL_PASSWORD \
    $MYSQL_DATABASE | gzip > /backup/$FILE_NAME

#!/bin/sh

POSTFIX="`date +%Y%m%d%H%M%S`";
FILE_NAME=$MYSQL_DATABASE-$POSTFIX.sql.gz

mysqldump --user=$MYSQL_USER --password=$MYSQL_PASSWORD \
    $MYSQL_DATABASE | gzip > /backup/$FILE_NAME

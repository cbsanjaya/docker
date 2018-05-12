#!/bin/sh

FTP_HOST=ftp://localhost/volume/
FTP_USER=user_ftp
FTP_PASS=pass_ftp

POSTFIX="`date +%Y%m%d%H%M%S`";
FILE_NAME=volume-$POSTFIX.tar.gz

docker-compose exec -T --user laravel db backup auto
tar czvf $FILE_NAME volume

curl -T $FILE_NAME $FTP_HOST --user $FTP_USER:$FTP_PASS

rm $FILE_NAME

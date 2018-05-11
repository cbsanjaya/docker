#!/bin/sh

POSTFIX="`date +%Y%m%d%H%M%S`";
FILE_NAME=volume-$POSTFIX.tar.gz

docker-compose exec -T --user laravel db backup auto
tar czvf $FILE_NAME volume

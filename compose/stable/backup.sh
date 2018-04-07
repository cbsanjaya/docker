#!/bin/sh

# BACKUP DATABASE

# current dir + /backup
VOL_EXT=$(pwd)/backup

# make dir backup if not exists
mkdir -p $VOL_EXT

POSTFIX="`date +%Y%m%d%H%M%S`";
FILE_NAME=stable_db-$POSTFIX.tar

CONTAINER=stable_db_1
CON_DATA=/var/lib/mysql

docker run --rm --volumes-from $CONTAINER \
    -v $VOL_EXT:/backup alpine \
    tar cvf /backup/$FILE_NAME $CON_DATA

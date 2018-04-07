#!/bin/bash

# current dir + /backup
VOL_EXT=$(pwd)/backup

# RESTORE DATABASE

CONTAINER=alpine_db_1

TEMP_CONTAINER=dbstore_container
FILE_NAME=alpine_db.tar
CON_DATA=/var/lib/postgresql/data
VOL_NAME=alpine_db

docker run -v $VOL_NAME:$CON_DATA --name $TEMP_CONTAINER alpine /bin/sh

docker run --rm --volumes-from $TEMP_CONTAINER \
    -v $VOL_EXT:/backup alpine \
    tar xvf /backup/$FILE_NAME

docker container rm $TEMP_CONTAINER
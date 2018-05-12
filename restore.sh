#!/bin/bash

###### .env as source ############################################
. ./.env
##################################################################

###### global variable for backup file ###########################
CUR_DIR_NAME=${PWD##*/}
CUR_DIR_PATH=$(pwd)
VOL_EXT=$CUR_DIR_PATH/volume
LOCAL_FILE=$CUR_DIR_PATH/backup/_restore.tar.bz2
##################################################################

###### Down Website ##############################################
down_web() {
    docker-compose exec -T --user laravel app php artisan down
}

###### restore .env ############################
restore_env() {
    cp $CUR_DIR_PATH/volume/.env $CUR_DIR_PATH/.env
}

###### restore database from sql file ############################
restore_db() {
    docker-compose exec -T db restore db
}

###### restore app data web and cache ############################
restore_app() {
    TEMP_CONTAINER=restore_container
    VOLUME_APP=$CUR_DIR_NAME"_app"
    VOLUME_CACHE=$CUR_DIR_NAME"_cache"

    docker run \
        -v $VOLUME_APP:/home/laravel/web/storage/ \
        -v $VOLUME_CACHE:/data \
        --name $TEMP_CONTAINER \
        alpine /bin/sh

    docker run --rm --volumes-from $TEMP_CONTAINER \
    -v $VOL_EXT:/backup alpine \
    tar xf /backup/app.tar.bz2

    docker container rm $TEMP_CONTAINER
}

###### cleaning volume ###########################################
clean_volume() {
    docker run --rm \
        -v $VOL_EXT:/backup \
        alpine rm \
        /backup/.env \
        /backup/app.tar.bz2 \
        /backup/db.sql.gz
}

###### up Website ################################################
up_web() {
    docker-compose exec -T --user laravel app php artisan up
}

###### restore db and app ########################################
restore_all() {
    down_web
    restore_env
    restore_db
    restore_app
    clean_volume
    up_web
}

###### restore from local ########################################
restore_local() {
    tar xf $LOCAL_FILE -C $CUR_DIR_PATH
    restore_all
}

###### restore from ftp ###########################################
restore_ftp() {
    echo "ftp restore"
}

if [ -z "$1" ]; then
    if [ -e $LOCAL_FILE ]; then
        restore_local
    else
        echo "file '_restore.tar.bz2' not found on folder backup"
    fi
elif [ "$1" = "ftp" ]; then
    restore_ftp
else
    echo "arg not match expect ftp"
fi

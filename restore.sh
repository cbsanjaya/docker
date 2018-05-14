#!/bin/bash

###### .env as source ############################################
. ./.env
##################################################################

###### global variable for backup file ###########################
CUR_DIR_NAME=${PWD##*/}
CUR_DIR_PATH=$(pwd)
VOL_EXT=$CUR_DIR_PATH/volume
LOCAL_FILE=$CUR_DIR_PATH/backup/_restore.tar.bz2
FTP_FILE=$CUR_DIR_PATH/backup/_restore_ftp.tar.bz2
##################################################################

###### Down Website ##############################################
down_web() {
    docker-compose exec -d -T --user laravel app php artisan down
}

###### restore .env dan folder etc ###############################
restore_env_etc() {
    cp $CUR_DIR_PATH/volume/.env $CUR_DIR_PATH/.env
    rm -R $CUR_DIR_PATH/etc/
    tar xf $VOL_EXT/etc.tar.bz2 -C $CUR_DIR_PATH
}

###### restore database from sql file ############################
restore_db() {
    docker-compose exec -d -T db restore db
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
        /backup/db.sql.gz \
        /backup/etc.tar.bz2
}

###### up Website ################################################
up_web() {
    docker-compose exec -d -T --user laravel app php artisan up
}

###### restore db and app ########################################
restore_all() {
    down_web
    restore_env_etc
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
    curl --user $FTP_USER:$FTP_PASS $FTP_HOST/_restore_ftp.tar.bz2 -o $FTP_FILE --silent
    if [ -e $FTP_FILE ]; then
        tar xf $FTP_FILE -C $CUR_DIR_PATH
        restore_all
        rm $FTP_FILE
    else
        echo "file '_restore_ftp.tar.bz2' not found on $FTP_HOST"
    fi
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

#!/bin/sh
###### .env as source ############################################
. ./.env
##################################################################

###### Down Website ##############################################
docker-compose exec -d -T --user laravel app php artisan down
##################################################################

###### backup sql database #######################################
# backup to ./volume/db.sql.gz #
docker-compose exec -d -T --user laravel db backup db
##################################################################

###### global variable for backup file ###########################
CUR_DIR_NAME=${PWD##*/}
CUR_DIR_PATH=$(pwd)
VOL_EXT=$CUR_DIR_PATH/volume
##################################################################

###### backup app storage ########################################
# backup to ./volume/app.tar.bz2 #
CONTAINER_APP=$CUR_DIR_NAME"_app_1"
CONTAINER_CACHE=$CUR_DIR_NAME"_cache_1"
docker run --rm \
    --volumes-from $CONTAINER_APP \
    --volumes-from $CONTAINER_CACHE \
    -v $VOL_EXT:/backup \
    alpine tar cjf /backup/app.tar.bz2 \
    home/laravel/web/storage/ data/
##################################################################

###### copy .env dan folder etc ke volume ########################
cp $CUR_DIR_PATH/.env $CUR_DIR_PATH/volume/.env
tar -cjf $CUR_DIR_PATH/volume/etc.tar.bz2 etc/
##################################################################

###### compress volume folder to backup folder ###################
POSTFIX="`date +%Y%m%d%H%M%S`";
if [ -z "$1" ]; then
    FILE_NAME=$CUR_DIR_PATH/backup/auto-$POSTFIX.tar.bz2
else
    FILE_NAME=$CUR_DIR_PATH/backup/$1-$POSTFIX.tar.bz2
fi

cd $CUR_DIR_PATH
tar --exclude='.gitignore' -cjf $FILE_NAME volume/
##################################################################

###### cleaning file on volume folder ############################
docker run --rm \
    -v $VOL_EXT:/backup \
    alpine rm \
    /backup/.env \
    /backup/app.tar.bz2 \
    /backup/db.sql.gz \
    /backup/etc.tar.bz2
##################################################################

###### only from auto backup #####################################
if [ -z "$1" ]; then
###### send current backup via ftp ###############################
    curl -T $FILE_NAME $FTP_HOST/ --user $FTP_USER:$FTP_PASS --silent
##################################################################

###### up Website ################################################
    docker-compose exec -d -T --user laravel app php artisan up
##################################################################
fi
##################################################################
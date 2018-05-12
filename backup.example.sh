#!/bin/sh

###### Down Website ##############################################
docker-compose exec -T --user laravel app php artisan down
##################################################################

###### backup sql database #######################################
# backup to ./volume/database.sql.gz #
docker-compose exec -T --user laravel db backup database
##################################################################

###### global variable for backup file ###########################
CUR_DIR_NAME=${PWD##*/}
CUR_DIR_PATH=$(pwd)
VOL_EXT=$CUR_DIR_PATH/volume
##################################################################

###### backup app storage ########################################
# backup to ./volume/app_file.tar.gz #
CONTAINER_APP=$CUR_DIR_NAME"_app_1"
docker run --rm \
    --volumes-from $CONTAINER_APP \
    -v $VOL_EXT:/backup \
    alpine \
    tar czvf /backup/app_file.tar.gz /home/laravel/web/storage/
##################################################################

###### backup cache data #########################################
# backup to ./volume/cache_file.tar.gz #
CONTAINER_CACHE=$CUR_DIR_NAME"_cache_1"
docker run --rm \
    --volumes-from $CONTAINER_CACHE \
    -v $VOL_EXT:/backup \
    alpine \
    tar czvf /backup/cache_file.tar.gz /data/
##################################################################

###### backup db file ############################################
# backup to ./volume/db_file.tar.gz #
CONTAINER_DB=$CUR_DIR_NAME"_db_1"
docker run --rm \
    --volumes-from $CONTAINER_DB \
    -v $VOL_EXT:/backup \
    alpine \
    tar czvf /backup/db_file.tar.gz /var/lib/mysql
##################################################################

###### compress volume folder to backup folder ###################
POSTFIX="`date +%Y%m%d%H%M%S`";
if [ -z "$1" ]; then
    FILE_NAME=$CUR_DIR_PATH/backup/auto-$POSTFIX.tar.gz
else
    FILE_NAME=$CUR_DIR_PATH/backup/$1-$POSTFIX.tar.gz
fi

cd $CUR_DIR_PATH
tar czvf $FILE_NAME volume/
##################################################################

###### cleaning file on volume folder ############################
docker run --rm \
    -v $VOL_EXT:/backup \
    alpine rm \
    /backup/app_file.tar.gz \
    /backup/cache_file.tar.gz \
    /backup/database.sql.gz \
    /backup/db_file.tar.gz
##################################################################

###### only from auto backup #####################################
if [ -z "$1" ]; then
###### send current backup via ftp ###############################
    FTP_HOST=ftp://localhost/volume/
    FTP_USER=ftp_user
    FTP_PASS=ftp_pass
    curl -T $FILE_NAME $FTP_HOST --user $FTP_USER:$FTP_PASS
##################################################################

###### up Website ################################################
    docker-compose exec -T --user laravel app php artisan up
##################################################################
fi
##################################################################
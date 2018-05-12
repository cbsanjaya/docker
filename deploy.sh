#!/bin/sh

###### Run Backup First ########################################################
/bin/sh ./backup.sh deploy
################################################################################

###### Update Application ######################################################
docker-compose -f docker-compose.yml -f docker-compose.prod.yml pull app
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --no-deps app
docker image prune -a -f
docker-compose exec -T --user laravel app composer run-script --quiet update-app
################################################################################

###### up Website ##############################################################
docker-compose exec -T --user laravel app php artisan up
################################################################################

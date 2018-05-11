#!/bin/bash

docker-compose exec -T --user laravel db backup
docker-compose -f docker-compose.yml -f docker-compose.prod.yml pull app
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
docker image prune -a -f
docker-compose exec -T --user laravel app composer run-script --quiet update-app

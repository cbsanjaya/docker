#!/bin/bash

docker-compose -f docker-compose.yml -f docker-compose.prod.yml pull
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
docker image prune -a -f
docker-compose exec -T --user laravel app composer run-script --quiet update-app

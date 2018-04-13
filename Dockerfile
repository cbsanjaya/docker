FROM composer

WORKDIR /src/app

RUN composer create-project -s dev erik-dubbelboer/php-redis-admin /src/app \
    && cp /src/app/includes/config.environment.inc.php /src/app/includes/config.inc.php

EXPOSE 6000

ENTRYPOINT [ "php", "-S", "0.0.0.0:6000" ]
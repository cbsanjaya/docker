FROM php:7.2-fpm-alpine3.7

RUN apk add --no-cache \
    nginx \
    supervisor

# Install dependencies
RUN set -ex; \
    \
    apk add --no-cache --virtual .build-deps \
        bzip2-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libxpm-dev \
    ; \
    \
    docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-webp-dir=/usr --with-png-dir=/usr --with-xpm-dir=/usr; \
    docker-php-ext-install bz2 gd mysqli opcache pdo_mysql zip; \
    \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --virtual .phpmyadmin-phpexts-rundeps $runDeps; \
    apk del .build-deps

RUN addgroup -g 1000 -S laravel && \
    adduser -s /bin/sh -D -u 1000 -S laravel -G laravel && \
    mkdir /home/laravel/web && \
    chown laravel:laravel /home/laravel/web

COPY etc /etc

COPY run.sh /run.sh
RUN chmod u+rwx /run.sh

WORKDIR /home/laravel/web

EXPOSE 443 80

ENTRYPOINT ["/run.sh"]
CMD ["app"]

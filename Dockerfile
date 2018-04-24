FROM php:7.2-fpm-alpine3.7

ENV ADMIN_USER=admin
ENV ADMIN_PASS=admin

ENV REDIS_HOST=cache
ENV REDIS_PORT=6379

WORKDIR /app/src

COPY src /app/src

EXPOSE 80

ENTRYPOINT [ "php", "-S", "0.0.0.0:80" ]

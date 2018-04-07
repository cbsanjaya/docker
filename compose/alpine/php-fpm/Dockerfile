FROM php:fpm-alpine3.7

MAINTAINER Cahya bagus Sanjaya <9c96b6@gmail.com>

RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash \
    git \
    postgresql-dev

# Install the PHP pdo_pgsql extention
RUN docker-php-ext-install pdo_pgsql \
# Install composer and add its bin to the PATH.
  && curl -s http://getcomposer.org/installer | php && \
  echo "export PATH=${PATH}:/var/www/vendor/bin" >> ~/.bashrc && \
  mv composer.phar /usr/local/bin/composer

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000

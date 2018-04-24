FROM cbsanjaya/laravel:app

WORKDIR /var/www/html

# Download tarball, verify it using gpg and extract
RUN git clone --depth 1 https://github.com/ErikDubbelboer/phpRedisAdmin.git /var/www/html \
    && composer install \
    && cp /var/www/html/includes/config.environment.inc.php /var/www/html/includes/config.inc.php

COPY site-default.conf /etc/nginx/sites-available/default.conf 

EXPOSE 443 80

ENTRYPOINT ["/run.sh"]
CMD ["app"]

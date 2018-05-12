FROM mysql:5.7

#####################################
# Set Timezone
#####################################

ARG TZ=Asia/Jakarta
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN chown -R mysql:root /var/lib/mysql/

COPY my.cnf /etc/mysql/conf.d/my.cnf

COPY backup.sh /bin/backup
COPY restore.sh /bin/restore

RUN mkdir /backup && \
    chmod +x /bin/backup /bin/restore

RUN addgroup --gid 1000 laravel && \
    adduser --shell /bin/bash --disabled-password --uid 1000 --gid 1000 laravel

RUN mkdir /home/laravel/backup && \
    chown -R laravel:laravel /home/laravel/backup

WORKDIR /home/laravel/backup

CMD ["mysqld"]

EXPOSE 3306
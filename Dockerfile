FROM mysql/mysql-server:8.0

MAINTAINER Cahya Bagus Sanjaya <9c96b6@gmail.com>

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

RUN groupadd -g 1000 laravel && \
    useradd -M -s /bin/bash -u 1000 -g laravel laravel

CMD ["mysqld"]

EXPOSE 3306

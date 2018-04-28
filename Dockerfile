FROM mysql:5.7

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

RUN addgroup --system --gid 1000 laravel && \
    adduser --system --shell /bin/bash --no-create-home --disabled-password --uid 1000 --gid 1000 laravel

WORKDIR /backup

CMD ["mysqld"]

EXPOSE 3306
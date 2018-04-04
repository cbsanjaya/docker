FROM mysql:5.7

MAINTAINER Cahya Bagus Sanjaya <9c96b6@gmail.com>

#####################################
# Set Timezone
#####################################

ARG TZ=Asia/Jakarta
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN chown -R mysql:root /var/lib/mysql/

ADD my.cnf /etc/mysql/conf.d/my.cnf

CMD ["mysqld"]

EXPOSE 3306

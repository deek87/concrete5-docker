FROM mariadb:10.1
MAINTAINER deek87
ARG C5_DB_USER='c5db_user'
ARG C5_DB_USER_PW='Concr3te5pa5sw0rd'
ARG C5_DB='concrete5db'

COPY ./docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
RUN sed -i s/\-\-C5_DB\-\-/${C5_DB}/g /docker-entrypoint-initdb.d/10-init-concrete5.sql \
  && sed -i s/\-\-C5_DB_USER\-\-/${C5_DB_USER}/g /docker-entrypoint-initdb.d/10-init-concrete5.sql \
  && sed -i s/\-\-C5_DB_USER_PW\-\-/${C5_DB_USER_PW}/g /docker-entrypoint-initdb.d/10-init-concrete5.sql \
  && sed -i s/\-\-PHP_IP\-\-/${PHP_IP}/g /docker-entrypoint-initdb.d/10-init-concrete5.sql

RUN chmod 644 /etc/mysql/conf.d/*


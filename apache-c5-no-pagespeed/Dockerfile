FROM httpd:2.4-alpine
MAINTAINER deek87

ARG WEB_USER='www-data'
ARG WEB_GROUP='www-data'
ARG APACHE_ROOT_DIR='/usr/local/etc/httpd'
ARG SITE='concrete5.local'
ENV SITE=${SITE}


COPY ./config/httpd2.conf ${APACHE_ROOT_DIR}/conf/httpd.conf
COPY ./config/vhost.conf ${APACHE_ROOT_DIR}/conf/extra/vhost-${SITE}.conf




RUN apk --no-cache add shadow
RUN set -x \
 && deluser ${WEB_USER} \
 && addgroup -g 1000 -S ${WEB_GROUP} \
 && adduser -u 1000 -D -S -s /bin/sh -G ${WEB_USER} ${WEB_GROUP} \
 && chown -R ${WEB_USER}:${WEB_GROUP} ${APACHE_ROOT_DIR}

VOLUME ["${APACHE_ROOT_DIR}/conf", "/var/www/vhosts"]
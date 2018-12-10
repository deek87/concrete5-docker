FROM php:7.2-fpm-alpine
MAINTAINER deek87

ARG C5_VERSION='8.4.3'
ARG SITE='concrete5.local'
ARG HTTP_SERVER_IP=192.168.0.11
ARG WEB_USER='www-data'
ARG WEB_GROUP='www-data'
ENV SITE=${SITE}
ARG C5_DB=concrete5
ARG C5_DB_USER=c5db_user
ARG C5_DB_USER_PW=VQKz0rU9ThR0kGA7
ARG C5_ADMIN_EMAIL=admin@example.com
ARG C5_ADMIN_PASSWORD=BJe04OXN0gy7ji7U
ARG PHP_ROOT_DIR=/usr/local/etc


RUN  mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install our extra php things
RUN apk --no-cache --update --virtual add pcre-dev ${PHPIZE_DEPS} mysql-client curl-dev freetype-dev libmemcached-dev libjpeg-turbo-dev libpng-dev libxml2-dev zlib-dev \
  && pecl install redis \
  && pecl install memcached \
  && docker-php-ext-enable redis memcached \
  && docker-php-ext-install curl dom mbstring pdo pdo_mysql simplexml zip \
  && docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
  && docker-php-ext-install gd \
  && apk del pcre-dev ${PHPIZE_DEPS}
RUN docker-php-ext-install sockets

RUN set -x \
 && deluser ${WEB_USER} \
 && addgroup -g 1000 -S ${WEB_GROUP} \
 && adduser -u 1000 -D -S -s /bin/sh -G ${WEB_USER} ${WEB_GROUP}
  # make our directories
RUN mkdir -p /var/www/vhosts/${SITE} \
 && mkdir -p ${PHP_ROOT_DIR}/logs/php-fpm \
 && chown -R ${WEB_USER}:${WEB_GROUP} ${PHP_ROOT_DIR}/logs/php-fpm \
 && chmod -R 775 ${PHP_ROOT_DIR}/logs \
 && mkdir -p /var/run/php-fpm \
 && chown -R ${WEB_USER}:${WEB_GROUP} /var/run/php-fpm \
 && touch ${PHP_ROOT_DIR}/logs/php-fpm/www-slow.log \
 && chmod 777 ${PHP_ROOT_DIR}/logs/php-fpm/www-slow.log

COPY ./php-fpm /usr/local/etc/php-fpm.d

# Copy Composer.json
COPY ./composer.json /var/www/vhosts/${SITE}/
RUN sed -i s/\-COMPOSERC5VERSION\-/${C5_VERSION}/g /var/www/vhosts/${SITE}/composer.json
COPY ./public /var/www/vhosts/${SITE}/public

RUN chmod 775 -R /var/www/vhosts/${SITE} && chown -R ${WEB_USER}:${WEB_GROUP} /var/www/vhosts/${SITE}

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && php -r "unlink('composer-setup.php');"
COPY ./scripts /usr/local/bin/


# backwards compatibility and adding some nice scripts
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh /usr/local/bin/concrete5.sh \
 && ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh \
 && ln -s /usr/local/bin/docker-entrypoint.sh /start-concrete5.sh \
 && ln -s /usr/local/bin/docker-entrypoint.sh /bin/start-concrete5.sh \
 && ln -s /usr/local/bin/concrete5.sh /bin/concrete5 \
 && ln -s /usr/local/bin/concrete5.sh /usr/local/bin/concrete5

RUN mkdir -p ${PHP_ROOT_DIR}/php-7.2 \
     && chmod -R 775 ${PHP_ROOT_DIR}/php-7.2 \
     && chown -R ${WEB_USER}:${WEB_GROUP} ${PHP_ROOT_DIR}/php-7.2 \
     && chgrp -R ${WEB_GROUP} ${PHP_ROOT_DIR}/php-fpm.d


RUN sed -i s/\-\-C5\_DB\-\-/${C5_DB}/g /usr/local/bin/docker-entrypoint.sh \
 && sed -i s/\-\-C5\_DB_USER\-\-/${C5_DB_USER}/g /usr/local/bin/docker-entrypoint.sh \
 && sed -i s/\-\-C5\_DB_USER\_PW\-\-/${C5_DB_USER_PW}/g /usr/local/bin/docker-entrypoint.sh \
 && sed -i s/\-\-C5\_ADMIN\_PASSWORD\-\-/${C5_ADMIN_PASSWORD}/g /usr/local/bin/docker-entrypoint.sh \
 && sed -i s/\-\-C5\_ADMIN\_EMAIL\-\-/${C5_ADMIN_EMAIL}/g /usr/local/bin/docker-entrypoint.sh

ENV DIR_BASE=/var/www/vhosts/${SITE}/public
USER ${WEB_USER}
VOLUME ["/var/www/vhosts", "${PHP_ROOT_DIR}/logs/php-fpm"]
CMD ['php-fpm']

FROM php:7.4-alpine3.11

LABEL authors="Hannes Papenberg"

RUN apk --no-cache add zlib-dev libpng-dev postgresql-dev autoconf gcc freetype \
    libpng libjpeg-turbo freetype-dev jpeg-dev libjpeg libjpeg-turbo-dev libzip-dev \
    icu-dev openldap-dev gmp-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg 

RUN docker-php-ext-install gd mysqli pdo_mysql pgsql pdo_pgsql zip ldap gmp

ENV MEMCACHED_DEPS zlib-dev libmemcached-dev cyrus-sasl-dev
RUN apk add --no-cache --update libmemcached-libs zlib
RUN set -xe \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --update --virtual .memcached-deps $MEMCACHED_DEPS \
    && pecl install memcached \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/20_memcached.ini \
    && rm -rf /usr/share/php7 \
    && rm -rf /tmp/* \
    && apk del .memcached-deps .phpize-deps

RUN apk add --no-cache --update gcc make autoconf libc-dev \
    && pecl install redis \
    && docker-php-ext-enable redis

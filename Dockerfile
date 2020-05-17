FROM joomlaprojects/docker-images:php7.4

LABEL authors="David Jardin, Roland Dalmulder"

RUN apk add --no-cache git

ADD composer.sh /usr/bin

RUN /usr/bin/composer.sh

FROM phpdockerio/php72-fpm:latest

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive
ARG APPDIR=/application
ARG LOCALE=fr_FR.UTF-8
ARG LC_ALL=fr_FR.UTF-8
ENV LOCALE=fr_FR.UTF-8
ENV LC_ALL=fr_FR.UTF-8

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install curl wget git sudo cron locales \
    && locale-gen $LOCALE && update-locale \
    && usermod -u 33 www-data && groupmod -g 33 www-data \
    && mkdir -p $APPDIR && chown www-data:www-data $APPDIR

RUN cd /tmp && wget https://deb.nodesource.com/setup_12.x && chmod +x setup_12.x && ./setup_12.x && \
cd /tmp && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
apt update && apt install -y nodejs yarn

RUN apt-get update \
    && apt-get -y --no-install-recommends install php-memcached php7.2-cli php7.2-common php7.2-curl php7.2-intl php7.2-json php7.2-mbstring php7.2-mysql php7.2-opcache php7.2-readline php7.2-sqlite3 php7.2-xml php7.2-zip php7.2-pgsql php7.2-gd php7.2-yaml php7.2-redis composer

RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Run cron
RUN service cron start

COPY ./ini/php-ini-overrides.ini /etc/php/7.2/fpm/conf.d/99-overrides.ini


EXPOSE 9000
VOLUME [ $APPDIR ]
WORKDIR $APPDIR

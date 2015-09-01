FROM piotrminkina/alpine-core:3.0
MAINTAINER Piotr Minkina <projects[i.am.spamer]@piotrminkina.pl>


RUN apk --update add \
    bash \
    php-apcu \
    php-bcmath \
    php-bz2 \
    php-calendar \
    php-cli \
    php-ctype \
    php-curl \
    php-dba \
    php-dom \
    php-enchant \
    php-exif \
    php-fpm \
    php-ftp \
    php-gd \
    php-gettext \
    php-gmp \
    php-iconv \
    php-imap \
    php-intl \
    php-json \
    php-mcrypt \
    php-mysql \
    php-mysqli \
    php-openssl \
    php-pdo \
    php-pdo_mysql \
    php-pdo_pgsql \
    php-pdo_sqlite \
    php-pear \
    php-pgsql \
    php-phar \
    php-posix \
    php-pspell \
    php-shmop \
    php-soap \
    php-sockets \
    php-sqlite3 \
    php-sysvmsg \
    php-sysvsem \
    php-sysvshm \
    php-wddx \
    php-xml \
    php-xmlreader \
    php-zip \
    php-zlib \
 && rm -rf /var/cache/apk/*

RUN sed -i 's/^error_log\s*=\s*\/var\/log\/php-fpm\.log$/error_log = syslog/' /etc/php/php-fpm.conf \
 && sed -i 's/^listen\s*=\s*127\.0\.0\.1:9000$/listen = 0.0.0.0:9000/' /etc/php/php-fpm.conf \
 && sed -i 's/^;error_log\s*=\s*syslog$/error_log = syslog/' /etc/php/php.ini

COPY entrypoint.sh /usr/local/bin/entrypoint

EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD []

FROM php:7.4.33-cli-alpine

LABEL Maintainer="ShaoBo Wan (Tinywan) <756684177@qq.com>" \
    Description="Webman Lightweight container with PHP 7.4.33 based on Alpine Linux."

# Use Alibaba Cloud mirror for faster downloads
RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories

# Install runtime dependencies only (build deps will be installed and removed later)
RUN apk add --no-cache curl ca-certificates tzdata supervisor

COPY ./extension /tmp/extension
WORKDIR /tmp/extension

# Install build dependencies, compile extensions, then cleanup everything in one layer
RUN apk add --no-cache --virtual .build-deps \
    libxml2-dev libzip-dev libjpeg-turbo-dev libpng-dev freetype-dev \
    libevent-dev openssl-dev libffi-dev icu-dev bzip2-dev postgresql-dev \
    autoconf g++ gcc make libc-dev pkgconf re2c libtool automake \
    && sed -i 's/\r$//' install.sh \
    && sh install.sh \
    && rm -rf /tmp/extension \
    && apk del .build-deps \
    && rm -rf /var/cache/apk /tmp/* /root/.pearrc /usr/local/include/php \
    && mkdir -p /var/cache/apk

# Add Composer (with cache cleanup)
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && rm -rf /root/.composer/cache

# Configure PHP
COPY config/php.ini /usr/local/etc/php/conf.d/zzz_custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup document root
RUN mkdir -p /app

VOLUME /app
WORKDIR /app
EXPOSE 8787

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

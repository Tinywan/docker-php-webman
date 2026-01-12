FROM php:8.4.16-cli-alpine

LABEL Maintainer="ShaoBo Wan (Tinywan) <756684177@qq.com>" \
    Description="Webman Lightweight container with PHP 8.4.16 based on Alpine Linux with S6 Overlay."

# Use Alibaba Cloud mirror for faster downloads
RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories

# Install S6 Overlay v3
ADD https://github.com/just-containers/s6-overlay/releases/download/v3.2.0.0/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && rm /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v3.2.0.0/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz && rm /tmp/s6-overlay-x86_64.tar.xz

# Install runtime dependencies only (build deps will be installed and removed later)
RUN apk add --no-cache curl ca-certificates tzdata

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
    && rm -rf /var/cache/apk/* /tmp/* /root/.pearrc /usr/local/include/php

# Add Composer (with cache cleanup)
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && rm -rf /root/.composer/cache

# Configure PHP
COPY config/php.ini /usr/local/etc/php/conf.d/zzz_custom.ini

# Setup S6 Overlay services
COPY config/s6/ /etc/s6-overlay/

# Make scripts executable
RUN chmod +x /etc/s6-overlay/cont-init.d/* \
    && chmod +x /etc/s6-overlay/services/*/run 2>/dev/null || true

# Setup document root
RUN mkdir -p /app

# Set S6 Overlay as entrypoint
ENTRYPOINT ["/init"]
VOLUME /app
WORKDIR /app
EXPOSE 8787

CMD []

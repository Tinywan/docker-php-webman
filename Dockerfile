FROM php:8.5.9-cli-alpine

LABEL Maintainer="ShaoBo Wan (Tinywan) <756684177@qq.com>" \
    Description="Webman Lightweight container with PHP 8.5.9 based on Alpine Linux with S6 Overlay."

# Use Alibaba Cloud mirror for faster downloads
RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories

# Install runtime dependencies only (build deps will be installed and removed later).
# libstdc++ (swoole), libzip (zip), libevent (event) must be explicit runtime packages:
# apk del .build-deps would otherwise purge them with their -dev counterparts.
RUN apk add --no-cache curl ca-certificates tzdata libstdc++ libzip libevent

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
    && php -r '$m=array_filter(["gd","bcmath","mysqli","pdo_mysql","redis","bz2","calendar","pcntl","sockets","zip","event","xlswriter","swoole"],fn($e)=>!extension_loaded($e));if($m){fwrite(STDERR,"missing after cleanup: ".implode(",",$m).PHP_EOL);exit(1);}' \
    && rm -rf /var/cache/apk /tmp/* /root/.pearrc /usr/local/include/php /usr/src/php.tar.xz* /usr/share/man /usr/share/doc \
    && mkdir -p /var/cache/apk

# Add Composer (with cache cleanup, no plugins/scripts)
RUN curl -fsS --retry 3 --retry-delay 3 https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer --version \
    && rm -rf /root/.composer/cache /tmp/*

# Configure PHP
COPY config/php.ini /usr/local/etc/php/conf.d/zzz_custom.ini

# Setup document root
RUN mkdir -p /app

# Add entrypoint script for auto composer install
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.sh

# Install S6 Overlay v3 from vendored tarballs (overlay/)
# Note: /command binaries are symlinks into /package — do not remove /package.
COPY overlay/s6-overlay-noarch.tar.xz overlay/s6-overlay-x86_64.tar.xz /tmp/
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
    && tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz \
    && rm -f /tmp/s6-overlay-*.tar.xz

# Register webman as an S6 longrun service
COPY config/s6-rc.d /etc/s6-overlay/s6-rc.d
ENV WEBMAN_CMD="php start.php start"
RUN sed -i 's/\r$//' /etc/s6-overlay/s6-rc.d/webman/run \
    && chmod +x /etc/s6-overlay/s6-rc.d/webman/run

VOLUME /app
WORKDIR /app
EXPOSE 8787

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# AGENTS.md

This file provides guidance to the AI agent when working with code in this repository.

## What this repo is

A Docker image (PHP CLI Alpine + S6 Overlay v3) for running webman apps. No application code lives here: the app is mounted at `/app`, `entrypoint.sh` auto-runs `composer install` if `vendor/autoload.php` is missing, then S6 starts the `webman` longrun service (`config/s6-rc.d/webman/`, command from `WEBMAN_CMD` env, default `php start.php start`) on port 8787.

## Build / verify

- `docker build -t tinywan/docker-php-webman:<PHP-version>-cli-alpine .` — image tag must match the `FROM php:X.Y.Z-cli-alpine` base.
- Smoke test: `docker run --rm -it -p 8787:8787 -v <webman-app-dir>:/app <image>`.

## Gotchas

- Shell scripts must have LF endings. `extension/install.sh` fails with CRLF ("line 1: #!/bin/sh: not found"); the Dockerfile guards with `sed -i 's/\r$//' install.sh` — keep that line.
- Installed extensions are controlled by the comma-delimited `EXTENSIONS=",..."` string at `extension/install.sh:12`, not the individual install blocks below it. Add/remove extensions in that string.
- `extension/*.tgz` are vendored sources compiled at build time; the redis/swoole/event/xlswriter ones are currently unused fallbacks since those installs moved to PIE. PECL's REST API is decommissioned — keep builds working without it. When bumping the PHP base image, update `FROM`, the LABEL description, README, and extension versions together.
- Online extension installs use PIE (`installExtensionFromPie`, vendored `extension/pie.phar` 1.4.9): redis (`phpredis/phpredis`), event (`osmanov/pecl-event`), swoole (`swoole/swoole`), xlswriter (`viest/xlswriter`), plus dormant blocks (imagick, rar, ast, varnish, mcrypt, memcached ≥3, yaf, rdkafka). Remaining `pecl install` calls (psr, msgpack, igbinary, yac, yar, yaconf, seaslog, pdo_sqlsrv, sqlsrv, zookeeper, phalcon) have no PIE package yet.
- PIE quirks: it sometimes skips auto-enabling (pecl-event) — the helper falls back to `docker-php-ext-enable`; event's ini must be renamed to `event.ini` so it loads AFTER sockets (needs sockets' symbols); PIE 1.4.x has no configure-options flag, so swoole relies on auto-detection (openssl yes, sockets support unverified).
- Extension runtime libs must stay explicit in the Dockerfile runtime `apk add` line (`libstdc++` for swoole, `libzip` for zip, `libevent` for event): `apk del .build-deps` otherwise purges them along with their `-dev` counterparts and the extensions silently stop loading. The Dockerfile has a post-cleanup `php -r extension_loaded(...)` gate — when changing `EXTENSIONS`, update that list too.
- S6 service files live in `config/s6-rc.d/`; `webman` must stay registered via the empty marker `config/s6-rc.d/user/contents.d/webman`. Like all scripts here, the `run` file needs LF endings (the Dockerfile also strips `\r` as a guard).
- S6 overlay tarballs are vendored in `overlay/` (only the `x86_64` one); the image effectively builds amd64-only despite QEMU in CI. To support more arches, vendor the matching tarball and update the COPY line.

## Release / repo etiquette

- Images publish via CI only (`.github/workflows/docker-publish.yml`) on `v*.*.*` git tags, to Docker Hub + GHCR. Each release pushes three tags: the semver version, `latest`, and `<php-version>-cli-alpine` (extracted from the Dockerfile `FROM` line — keep that line format intact). Don't push images manually.
- Commit style is short, often just the new image tag (e.g. `8.5.9-cli-alpine`); feature branches use `feature/<name>` merged to `main` via PR.

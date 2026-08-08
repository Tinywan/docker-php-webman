# docker-php-webman

[![Docker](https://github.com/Tinywan/docker-php-webman/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/Tinywan/docker-php-webman/actions/workflows/docker-publish.yml)
[![license](https://img.shields.io/github/license/Tinywan/docker-php-webman)](LICENSE)
[![last-commit](https://img.shields.io/github/last-commit/tinywan/docker-php-webman/main)]()
[![tag](https://img.shields.io/github/v/tag/tinywan/docker-php-webman?color=ff69b4)]()

A lightweight container image for running [webman](https://www.workerman.net/webman) applications:

- **PHP 8.5.9** CLI on Alpine Linux
- **S6 Overlay v3** process supervision (webman runs as a longrun service, graceful SIGTERM shutdown)
- **Composer** preinstalled; dependencies auto-installed on first start
- Extensions commonly needed by webman: `swoole`, `event`, `redis`, and more

Your application is mounted at `/app` and started with `php start.php start` on port **8787**.

## Usage

### Linux

```bash
docker run --rm -it -p 8787:8787 -v /home/www/webman:/app tinywan/docker-php-webman
```

### Windows

```bash
docker run --rm -it -p 8787:8787 -v e:/dnmp/www/webman:/app tinywan/docker-php-webman
```

### Custom start command

The start command is controlled by the `WEBMAN_CMD` environment variable (default `php start.php start`):

```bash
docker run --rm -it -p 8787:8787 -e WEBMAN_CMD="php start.php start -d" -v /home/www/webman:/app tinywan/docker-php-webman
```

### First start

If `/app/vendor/autoload.php` is missing, the entrypoint automatically runs
`composer install --no-interaction --no-scripts --no-plugins` before starting webman.

## Image tags

Images are published to **Docker Hub** (`tinywan/docker-php-webman`) and **GHCR**
(`ghcr.io/tinywan/docker-php-webman`) by CI on every `v*.*.*` release tag:

| Tag | Meaning |
|---|---|
| `latest` | Latest release |
| `<version>` | Release version, e.g. `1.0.0` (from the git tag) |
| `<php-version>-cli-alpine` | Tracked by PHP version, e.g. `8.5.9-cli-alpine` |

## Extensions

Controlled by the `EXTENSIONS` list in [extension/install.sh](extension/install.sh):

```
bcmath bz2 calendar event gd mysqli opcache pcntl pdo pdo_mysql redis sockets swoole xlswriter zip
```

Plus the extensions bundled with the official PHP image (`curl`, `mbstring`, `openssl`, `sodium`, `iconv`, ...). Verify with:

```bash
docker run --rm tinywan/docker-php-webman php -m
```

## Build from source

```bash
docker build -t tinywan/docker-php-webman:8.5.9-cli-alpine .
```

## License

[MIT](LICENSE)

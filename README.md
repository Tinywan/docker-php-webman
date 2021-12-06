[![Build status](https://github.com/Tinywan/docker-php-webman/workflows/Docker/badge.svg)]()
[![license](https://img.shields.io/github/license/Tinywan/docker-php-webman)]()
[![nacos-sdk-php](https://img.shields.io/github/last-commit/tinywan/docker-php-webman/main)]()
[![nacos-sdk-php](https://img.shields.io/github/v/tag/tinywan/docker-php-webman?color=ff69b4)]()

## Build

```
docker build -t tinywan/docker-php-webman:7.4.26 .
```
## Usage

Start the Docker container:

### Linux

```
docker run --rm -it -p 8088:8787 -v /home/www/webman:/app tinywan/docker-php-webman:latest
```

### Windows

```
docker run --rm -it -p 8088:8787 -v e:/dnmp/www/webman:/app tinywan/docker-php-webman:latest
```

## Docker 

delete all container
```
docker rm `docker ps -a -q`
```

delete all images
```
docker rmi -f $(docker images -qa)
```





[![Build status](https://github.com/Tinywan/docker-php-webman/workflows/Docker/badge.svg)]()
[![license](https://img.shields.io/github/license/Tinywan/docker-php-webman)]()
[![nacos-sdk-php](https://img.shields.io/github/last-commit/tinywan/docker-php-webman/main)]()
[![nacos-sdk-php](https://img.shields.io/github/v/tag/tinywan/docker-php-webman?color=ff69b4)]()

## Build

```
docker build -t tinywan/docker-php-webman:7.4.14 .
```
## Usage

Start the Docker container:

```
docker run --rm -it -p 8088:8080 -v /home/www/webman:/app tinywan/docker-php-webman:latest
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





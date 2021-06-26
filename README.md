[![Build status](https://github.com/Tinywan/docker-php-webman/workflows/Docker/badge.svg)]()

## Build

```
docker build -t tinywan/docker-php-webman:7.4.14 .
```
## Usage

Start the Docker container:

```
docker run --rm -it -p 8088:8080 -v /home/www/webman:/app tinywan/docker-php-webman:latest:latest
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





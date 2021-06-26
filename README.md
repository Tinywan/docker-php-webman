## Build

```
docker build -t tinywan/docker-php-webman:7.4.14 .
```
## Usage

Start the Docker container:

```
docker run -p 8088:8080 -name dnmp-webman -v d:/dnmp/www/webman.tinywan.com:/app tinywan/docker-php-cli:latest
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





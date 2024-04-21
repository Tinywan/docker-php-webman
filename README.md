[![Build status](https://github.com/Tinywan/docker-php-webman/workflows/Docker/badge.svg)]()
[![license](https://img.shields.io/github/license/Tinywan/docker-php-webman)]()
[![nacos-sdk-php](https://img.shields.io/github/last-commit/tinywan/docker-php-webman/main)]()
[![nacos-sdk-php](https://img.shields.io/github/v/tag/tinywan/docker-php-webman?color=ff69b4)]()

## Build

```
docker build -t tinywan/docker-php-webman:8.3.4 .
```
## Usage

Start the Docker container:

### Linux

```
docker run --rm -it -p 8787:8787 -v /home/www/webman:/app tinywan/docker-php-webman
```

### Windows

```
docker run --rm -it -p 8787:8787 -v e:/dnmp/www/webman:/app tinywan/docker-php-webman
```

Test Run

![docker-run.png](./docker-run.png)

> PHP Version **8.1.4**

![image](https://user-images.githubusercontent.com/14959876/159652489-7df26dcb-b5e7-4f31-be96-3ecb63f3f7c5.png)

> **status**

![image](https://user-images.githubusercontent.com/14959876/159652735-86540cab-33c3-4b75-a0b7-41071300ee75.png)

## Extensions

```
bash-5.1# php -m
[PHP Modules]
bcmath       
bz2
calendar     
Core
ctype        
curl
date
dom
event        
fileinfo     
filter       
ftp
gd
hash
iconv        
json
libxml       
mbstring     
mysqli       
mysqlnd      
openssl      
pcntl        
pcre
PDO
pdo_mysql    
pdo_sqlite   
Phar
posix        
readline     
redis        
Reflection   
session      
SimpleXML    
soap
sockets      
sodium       
SPL
sqlite3      
standard     
tokenizer
xml
xmlreader
xmlwriter
Zend OPcache
zip
zlib

[Zend Modules]
Zend OPcache
```
## Other 

delete all container
```
docker rm `docker ps -a -q`
```

delete all images
```
docker rmi -f $(docker images -qa)
```

## dos2unix install.sh

```
=> ERROR [ 7/14] RUN chmod +x install.sh     && sh install.sh     && rm -rf /tmp/extension                                                                 0.2s 
------
 > [ 7/14] RUN chmod +x install.sh     && sh install.sh     && rm -rf /tmp/extension:
: not foundll.sh: line 1: #!/bin/sh
: not foundll.sh: line 2:
: not foundll.sh: line 4:
: not foundll.sh: line 10: echo
: not foundll.sh: line 11:
: not foundll.sh: line 13:
: not foundll.sh: line 30:
0.217 install.sh: return: line 36: Illegal number: 0
```
查看文本格式
```
$ cat -A install.sh 
M-oM-;M-?#!/bin/sh^M$
^M$
```

> 执行转换
```
# 安装
sudo apt-get install dos2unix

# 转换
dos2unix install.sh
```

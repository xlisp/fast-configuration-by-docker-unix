# set-misc-nginx-module in docker

```bash

 docker build -t set-misc-nginx80 .
 docker run -d -p 80:80 -it set-misc-nginx80:latest  # can 80
 #####docker run -it set-misc-nginx80:latest -p 81:81
 docker exec -it ` docker ps | grep set-misc-nginx | awk '{print $1}' ` /bin/bash

```

# 需要DNS的解析支持 (测试可用):

```bash
docker run -d -p 80:80 -it set-misc-nginx80:latest --dns=127.0.0.1
```

# Hack Binding习惯

```bash
alias dis=' echo IMAGES: && docker images && echo ---------DOCKER-PS: && docker ps '

drm(){
  dim=$1
  docker rmi -f $(docker images | grep -E "$1" |  awk '{ print $3}' )
  dis
}

runbash(){
  name=$1  #$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  docker run -d  -it $name /bin/bash
  did=` docker ps | grep $name | awk '{print $1}' `
  echo "RUN:====>>" "did=$did && docker exec -it \$did /bin/bash"
  docker exec -it $did /bin/bash
  docker stop $did
}
# did=632e55e20727 && docker exec -it $did /bin/bash


```
# 用Elisp做日常命令行的处理工作

```bash
./nginx-configure.el --prefix /opt/nginx --with-list http_realip_module,http_ssl_module --add-module-list /usr/src/redis2-nginx-module,/usr/src/ngx_devel_kit,/usr/src/set-misc-nginx-module,/usr/src/echo-nginx-module,/usr/src/lua-nginx-module

#=>
==============>>>>>>>>>>>>>
prefix = /opt/nginx
with-list = (http_realip_module http_ssl_module)
add-module-list = (/usr/src/redis2-nginx-module /usr/src/ngx_devel_kit /usr/src/set-misc-nginx-module /usr/src/echo-nginx-module /usr/src/lua-nginx-module)
-----------
./configure --prefix=/opt/nginx --with-http_realip_module --with-http_ssl_module --add-module=/usr/src/redis2-nginx-module --add-module=/usr/src/ngx_devel_kit --add-module=/usr/src/set-misc-nginx-module --add-module=/usr/src/echo-nginx-module --add-module=/usr/src/lua-nginx-module 
<<<<<<<<<<<<<<==============

```

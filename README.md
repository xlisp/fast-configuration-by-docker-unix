**Table of Contents** *generated with [autotoc](https://github.com/Wilfred/autotoc)*

- [fast configuration by docker: 让Docker每秒build十次, 每一次build成功的结果作为下一次build的Form, 如此递归build, 直到Fixed错误为止](#fast-configuration-by-docker-dockerbuild-buildbuildform-build-fixed)
  - [服务端Dockerfile的生成](#dockerfile)
  - [客户端获取服务端的Dockerfile开始build](#dockerfilebuild)
  - [有意思的一些脚本集合](#)
    - [1. 检测Nginx配置文件的改动事件, 改动则重启Nginx](#1-nginx-nginx)
    - [2. 如果 exec 退出 则 stop: exec退出就垃圾回收为零](#2--exec---stop-exec)
    - [3. 查看所以的image和进程，以及删除某些image](#3-imageimage)
    - [4. 监控Dockerfile的改变, 改变就build一次, 如果成功则 runbash 去Hack](#4-dockerfile-build--runbash-hack)
    - [5. 每一步都是 可以退转的，所以 推荐多个 Form 来做 构建失败 回退](#5----form---)
    - [6. 接近成功的 单个配置](#6--)
    - [7. ERB S表达式 化](#7-erb-s-)
    - [8. 用clojure写一个Ruby的eval错误分类cond为第一位，直到宏可以适应各种情况为止](#8-clojurerubyevalcond)
    - [9.  git clone的Binding函数对应: 大部分人可以修得很好表达式功夫(阳),但是很难修得很好的Binding的功夫(阴): 混沌数据中抽象出有意思lambda演算打出去,结合阳中的摊手参, 无意思无趣之用](#9--git-clonebinding-binding-lambda-)
    - [10. drm 的事件: 多参数即高阶化,处理多事件的能力](#10-drm--)
    - [11. 完整的DockerBuild的 事件记录: 处理事件流是高阶函数基本目标,这个参数过程需要提取于事件记录](#11-dockerbuild--)

# fast configuration by docker: 让Docker每秒build十次, 每一次build成功的结果作为下一次build的Form, 如此递归build, 直到Fixed错误为止

## 服务端Dockerfile的生成
* 用Elisp脚本的宏定义生成Dockerfile
* Dockerfile的每一layer层都是一个函数
* 每一层函数 的类型都是相对固定, 并有相应事件对应的 触发条件 

## 客户端获取服务端的Dockerfile开始build
* 不要局限于用什么语言,底层用Go获取 “docker/registry image辅助器” 的事件流
* 客户端命令行可以用Ruby或者Bash来包装, 上层抽象用Elisp
* 通过客户端命令行去与服务端交互 修改服务端的 Dockerfile

## 有意思的一些脚本集合 

### 1. 检测Nginx配置文件的改动事件, 改动则重启Nginx

```bash

##### Set initial time of file
LTIME=`stat -c %Z /opt/nginx/conf/vhosts/sounds.conf`

while true
do
   ATIME=`stat -c %Z /opt/nginx/conf/vhosts/sounds.conf`

   if [[ "$ATIME" != "$LTIME" ]]
   then
       echo "RUN COMMNAD": `pgrep nginx | xargs echo `
       LTIME=$ATIME
       kill -9 $(pgrep nginx) && /opt/nginx/sbin/nginx 
   fi
   sleep 0.2
done

```

### 2. 如果 exec 退出 则 stop: exec退出就垃圾回收为零 

```bash

runbash () {
    name=$1
    docker run -d -it $name /bin/bash
    did=` docker ps | grep $name | awk '{print $1}' `
    docker exec -it $did /bin/bash
    docker stop $did
}

### runbash ruby-app:1.01

```


### 3. 查看所以的image和进程，以及删除某些image


```bash

alias dis=' echo IMAGES: && sudo docker images && echo ---------DOCKER-PS: && sudo docker ps '

drm(){
  dim=$1
  sudo docker rmi -f $(sudo docker images | grep -E "$1" |  awk '{ print $3}' )
  dis
}

### drm "simple-app|dnsmasq"

```
### 4. 监控Dockerfile的改变, 改变就build一次, 如果成功则 runbash 去Hack

```bash

alias vbu='vi config/deploy/docker/Dockerfile.base ; sudo docker build -t regsvcs-base:1.01 -f config/deploy/docker/Dockerfile.base . '


```

### 5. 每一步都是 可以退转的，所以 推荐多个 Form 来做 构建失败 回退
` docker build -t testone -f  config/deploy/docker/Dockerfile.base . `

### 6. 接近成功的 单个配置
` while true; do curl http://stdocker.com/registry-test/proxy?url=http%3A%2F%2Fslimages.macys.com%2Fis%2Fimage%2FMCY%2Fproducts%2F9%2Foptimized%2F1834199_fpx.tif%3Ftest%3D1 ;done  `

### 7. ERB S表达式 化

```clojure
(def LoadModule
  { :authn_file_module "modules/mod_authn_file.so" :rewrite_module "modules/mod_rewrite.so" }
  )

;;提取: (LoadModule :authn_file_module)
```

### 8. 用clojure写一个Ruby的eval错误分类cond为第一位，直到宏可以适应各种情况为止

```bash
用clojure写Ruby的基本错误分类 cond

用宏去适应一切生成的错误，直到成功适应各种表达式

```

### 9.  git clone的Binding函数对应: 大部分人可以修得很好表达式功夫(阳),但是很难修得很好的Binding的功夫(阴): 混沌数据中抽象出有意思lambda演算打出去,结合阳中的摊手参, 无意思无趣之用

```bash
gclo () {
    git clone git@github.com:$1.git
    cd ` echo $1 | sed "s/\(.*\)\/\(.*\)/\2/g" `
}
gclo dmohs/cljs-node-template
```

### 10. drm 的事件: 多参数即高阶化,处理多事件的能力

```bash
drm () {
    dim=$1
    docker rmi -f $(docker images | grep -E "$1" |  awk '{ print $3}' )
    echo IMAGES: && docker images && echo ---------DOCKER-PS: && docker ps
}
```

### 11. 完整的DockerBuild的 事件记录: 处理事件流是高阶函数基本目标,这个参数过程需要提取于事件记录

/sections/show/2413

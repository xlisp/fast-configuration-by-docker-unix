# 快速系统配置通过Docker
### fast configuration by docker: 让Docker每秒build十次, 每一次build成功的结果作为下一次build的Form, 如此递归build, 直到Fixed错误为止

- [服务端Dockerfile的生成](#%E6%9C%8D%E5%8A%A1%E7%AB%AFdockerfile%E7%9A%84%E7%94%9F%E6%88%90)
- [客户端获取服务端的Dockerfile开始build](#%E5%AE%A2%E6%88%B7%E7%AB%AF%E8%8E%B7%E5%8F%96%E6%9C%8D%E5%8A%A1%E7%AB%AF%E7%9A%84dockerfile%E5%BC%80%E5%A7%8Bbuild)
- [有意思的一些脚本集合](#%E6%9C%89%E6%84%8F%E6%80%9D%E7%9A%84%E4%B8%80%E4%BA%9B%E8%84%9A%E6%9C%AC%E9%9B%86%E5%90%88)
  - [1. 检测Nginx配置文件的改动事件, 改动则重启Nginx](#1-%E6%A3%80%E6%B5%8Bnginx%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E7%9A%84%E6%94%B9%E5%8A%A8%E4%BA%8B%E4%BB%B6-%E6%94%B9%E5%8A%A8%E5%88%99%E9%87%8D%E5%90%AFnginx)
  - [2. 如果 exec 退出 则 stop: exec退出就垃圾回收为零](#2-%E5%A6%82%E6%9E%9C-exec-%E9%80%80%E5%87%BA-%E5%88%99-stop-exec%E9%80%80%E5%87%BA%E5%B0%B1%E5%9E%83%E5%9C%BE%E5%9B%9E%E6%94%B6%E4%B8%BA%E9%9B%B6)
  - [3. 查看所以的image和进程，以及删除某些image](#3-%E6%9F%A5%E7%9C%8B%E6%89%80%E4%BB%A5%E7%9A%84image%E5%92%8C%E8%BF%9B%E7%A8%8B%EF%BC%8C%E4%BB%A5%E5%8F%8A%E5%88%A0%E9%99%A4%E6%9F%90%E4%BA%9Bimage)
  - [4. 监控Dockerfile的改变, 改变就build一次, 如果成功则 runbash 去Hack](#4-%E7%9B%91%E6%8E%A7dockerfile%E7%9A%84%E6%94%B9%E5%8F%98-%E6%94%B9%E5%8F%98%E5%B0%B1build%E4%B8%80%E6%AC%A1-%E5%A6%82%E6%9E%9C%E6%88%90%E5%8A%9F%E5%88%99-runbash-%E5%8E%BBhack)
  - [5. 每一步都是 可以退转的，所以 推荐多个 Form 来做 构建失败 回退](#5-%E6%AF%8F%E4%B8%80%E6%AD%A5%E9%83%BD%E6%98%AF-%E5%8F%AF%E4%BB%A5%E9%80%80%E8%BD%AC%E7%9A%84%EF%BC%8C%E6%89%80%E4%BB%A5-%E6%8E%A8%E8%8D%90%E5%A4%9A%E4%B8%AA-form-%E6%9D%A5%E5%81%9A-%E6%9E%84%E5%BB%BA%E5%A4%B1%E8%B4%A5-%E5%9B%9E%E9%80%80)
  - [6. 接近成功的 单个配置](#6-%E6%8E%A5%E8%BF%91%E6%88%90%E5%8A%9F%E7%9A%84-%E5%8D%95%E4%B8%AA%E9%85%8D%E7%BD%AE)
  - [7. ERB S表达式 化](#7-erb-s%E8%A1%A8%E8%BE%BE%E5%BC%8F-%E5%8C%96)
  - [8. 用clojure写一个Ruby的eval错误分类cond为第一位，直到宏可以适应各种情况为止](#8-%E7%94%A8clojure%E5%86%99%E4%B8%80%E4%B8%AAruby%E7%9A%84eval%E9%94%99%E8%AF%AF%E5%88%86%E7%B1%BBcond%E4%B8%BA%E7%AC%AC%E4%B8%80%E4%BD%8D%EF%BC%8C%E7%9B%B4%E5%88%B0%E5%AE%8F%E5%8F%AF%E4%BB%A5%E9%80%82%E5%BA%94%E5%90%84%E7%A7%8D%E6%83%85%E5%86%B5%E4%B8%BA%E6%AD%A2)
  - [9.  git clone的Binding函数对应: 大部分人可以修得很好表达式功夫(阳),但是很难修得很好的Binding的功夫(阴): 混沌数据中抽象出有意思lambda演算打出去,结合阳中的摊手参, 无意思无趣之用](#9--git-clone%E7%9A%84binding%E5%87%BD%E6%95%B0%E5%AF%B9%E5%BA%94-%E5%A4%A7%E9%83%A8%E5%88%86%E4%BA%BA%E5%8F%AF%E4%BB%A5%E4%BF%AE%E5%BE%97%E5%BE%88%E5%A5%BD%E8%A1%A8%E8%BE%BE%E5%BC%8F%E5%8A%9F%E5%A4%AB%E9%98%B3%E4%BD%86%E6%98%AF%E5%BE%88%E9%9A%BE%E4%BF%AE%E5%BE%97%E5%BE%88%E5%A5%BD%E7%9A%84binding%E7%9A%84%E5%8A%9F%E5%A4%AB%E9%98%B4-%E6%B7%B7%E6%B2%8C%E6%95%B0%E6%8D%AE%E4%B8%AD%E6%8A%BD%E8%B1%A1%E5%87%BA%E6%9C%89%E6%84%8F%E6%80%9Dlambda%E6%BC%94%E7%AE%97%E6%89%93%E5%87%BA%E5%8E%BB%E7%BB%93%E5%90%88%E9%98%B3%E4%B8%AD%E7%9A%84%E6%91%8A%E6%89%8B%E5%8F%82-%E6%97%A0%E6%84%8F%E6%80%9D%E6%97%A0%E8%B6%A3%E4%B9%8B%E7%94%A8)
  - [10. drm 的事件: 多参数即高阶化,处理多事件的能力](#10-drm-%E7%9A%84%E4%BA%8B%E4%BB%B6-%E5%A4%9A%E5%8F%82%E6%95%B0%E5%8D%B3%E9%AB%98%E9%98%B6%E5%8C%96%E5%A4%84%E7%90%86%E5%A4%9A%E4%BA%8B%E4%BB%B6%E7%9A%84%E8%83%BD%E5%8A%9B)
  - [11. 完整的DockerBuild的 事件记录: 处理事件流是高阶函数基本目标,这个参数过程需要提取于事件记录](#11-%E5%AE%8C%E6%95%B4%E7%9A%84dockerbuild%E7%9A%84-%E4%BA%8B%E4%BB%B6%E8%AE%B0%E5%BD%95-%E5%A4%84%E7%90%86%E4%BA%8B%E4%BB%B6%E6%B5%81%E6%98%AF%E9%AB%98%E9%98%B6%E5%87%BD%E6%95%B0%E5%9F%BA%E6%9C%AC%E7%9B%AE%E6%A0%87%E8%BF%99%E4%B8%AA%E5%8F%82%E6%95%B0%E8%BF%87%E7%A8%8B%E9%9C%80%E8%A6%81%E6%8F%90%E5%8F%96%E4%BA%8E%E4%BA%8B%E4%BB%B6%E8%AE%B0%E5%BD%95)


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
```bash
$ docker events #==> docker events | sed 's/\(.*\)) \(.*\)/\2/' | sort | uniq
commit create destroy die start

```
/sections/show/2412


* Docker containers report the following events:

` attach, commit, copy, create, destroy, detach, die, exec_create, exec_detach, exec_start, export, kill, oom, pause, rename, resize, restart, start, stop, top, unpause, update ` 

* Docker images report the following events:

` delete, import, load, pull, push, save, tag, untag ` 

* Docker volumes report the following events:

` create, mount, unmount, destroy ` 

* Docker networks report the following events:

` create, connect, disconnect, destroy `

* Docker daemon report the following events:

` reload ` 

eg : 

```bash
 docker events # all 

 docker events --filter 'container=7805c1d35632' --filter 'event=stop'

 docker events --since '2013-09-03T15:49:29'

```


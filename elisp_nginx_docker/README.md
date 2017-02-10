# elisp for nginx and docker
* ` es test.el ` # 用.emacs.d/Cask管理所有的脚本依赖 
## 包装 `docker rmi ` 如下 bash函数: 
```bash
drm(){
  dim=$1
  sudo docker rmi -f $(sudo docker images | grep -E "$1" |  awk '{ print $3}' )
  dis
}
```


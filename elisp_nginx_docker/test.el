(require 'cask)
(cask-initialize)

(require 'dash)
(require 'docker)
(require 'magit-popup)
(require 'tablist)

(require 'docker-process)
(require 'docker-utils)
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))
;; Use "docker-machine env box" command to find out your environment variables
(setenv "DOCKER_TLS_VERIFY" "1")
(setenv "DOCKER_HOST" "tcp://192.168.99.100:2376")
(setenv "DOCKER_CERT_PATH" "/Users/emacs/.docker/machine/machines/nginx-clojure")
(setenv "DOCKER_MACHINE_NAME" "nginx-clojure")
;;;;;;;;;;

;;(-each '(1 2 3 4 5 6)
;;  (lambda
;;    (x)
;;    (print x))
;;  )
;;
;;(docker-images) ;; docker images --format='{{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedSince}}\t{{.Size}}'


;;(docker-containers) ;; docker ps --format='[{{.ID}},{{.Image}},{{.Command}},{{.RunningFor}},{{.Status}},{{.Ports}},{{.Names}}]'
;;[30361ad46257,regsvcs-webui:qa-latest,"/bin/bash",5 minutes,Up 5 minutes,0.0.0.0:80->80/tcp,adoring_yalow]

;;(docker-volumes) ;; docker volume ls

;;(docker-networks) ;;docker network ls


;;(docker-machines)

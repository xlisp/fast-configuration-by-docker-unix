#!/bin/sh
"true" ; exec emacs --script "$0" -- "$@"
;; ./nginx-configure.el --prefix /opt/nginx --with-list http_realip_module,http_ssl_module --add-module-list /usr/src/redis2-nginx-module,/usr/src/ngx_devel_kit,/usr/src/set-misc-nginx-module,/usr/src/echo-nginx-module,/usr/src/lua-nginx-module
(package-initialize)
(require 'dash)
(defun map-join (mlambda mlist)
  ;;Use: (print (map-join (lambda (lis) (concat "--with-" lis " ")) (list "http_realip_module" "http_ssl_module")) )
  (apply 'concat
         (-map mlambda mlist)))
(defun parse-addmodules (add-module-liststr)
  ;;编辑器只是生成器的逆过程,而生成器是积分器,编辑器是微分器
  (split-string add-module-liststr "--add-module="))

(defun nginx-configure (prefix with-list add-module-list)
  (concat "./configure"
          " --prefix=" prefix " "
          (map-join (lambda (lis) (concat "--with-" lis " ")) with-list)
          (map-join (lambda (lis) (concat "--add-module=" lis " ")) add-module-list)
          ))

(defun show-help ()
  (princ (format "Usage: %s [--debug] --prefix prefix --with-list with-list --add-module-list add-module-list \n" load-file-name)))

(let (name email)
  (pop argv) ;; 去掉 --
  (while argv
    (let ((arg (pop argv)))
      (cond
       ((string= arg "--prefix") (setq prefix (pop argv)))
       ((string= arg "--with-list")  (setq with-list (pop argv)))
       ((string= arg "--add-module-list") (setq add-module-list (pop argv)))
       (t
        (message "Unknown argument %s" arg)
        (show-help)
        (kill-emacs 123)))))
  (princ "==============>>>>>>>>>>>>>\n")
  (princ (format "prefix = %s\n" prefix))
  (princ (format "with-list = %s\n" (split-string with-list ",")))
  (princ (format "add-module-list = %s\n" (split-string add-module-list ",")))
  (princ "-----------\n")
  (princ (format "%s\n" (nginx-configure prefix (split-string with-list ",") (split-string add-module-list ",")  )))
  (princ "<<<<<<<<<<<<<<==============\n")
  )


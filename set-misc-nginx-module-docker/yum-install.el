(package-initialize)
(require 'dash)
(defun map-join (mlambda mlist)
  (apply 'concat
         (-map mlambda mlist)))

(defun yum-install (ylist)
  (concat
   "yum install -y "
   (map-join (lambda (yli) (concat yli " "))  ylist)))

(print (yum-install (list "ncurses-devel" "openssh-clients" "nano" "wget" "bind-utils" "bc" "bluez" "bluez-libs" "usbutils" "pygobject2" "dbus-python" "telnet" "python-pip" "python-setuptools" "supervisor"))
       )

;; ==>
;; "yum install -y ncurses-devel openssh-clients nano wget bind-utils bc bluez bluez-libs usbutils pygobject2 dbus-python telnet python-pip python-setuptools supervisor "

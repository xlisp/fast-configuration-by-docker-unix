#!/bin/bash

### Set initial time of file
LTIME=`stat -c %Z /opt/nginx/conf/vhosts/sounds.conf`

while true
do
   ATIME=`stat -c %Z /opt/nginx/conf/vhosts/sounds.conf`

   if [[ "$ATIME" != "$LTIME" ]]
   then
       echo "RUN COMMNAD": `pgrep nginx | xargs echo `
       LTIME=$ATIME
       ###if [ -z ` pgrep nginx ` ] ; then echo ` /opt/nginx/sbin/nginx ` ; fi
       kill -9 $(pgrep nginx) || true
       /opt/nginx/sbin/nginx
   fi
   sleep 0.2
done

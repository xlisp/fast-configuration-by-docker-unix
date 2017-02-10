# Scale Docker App Image

##### 1. Ignore Build app image regsvcs-webui:latest

##### 2. ` docker-compose scale `

```sh
docker ps 
#=> regsvcs-webui                 latest              87f861416637        10 days ago         984.1 MB

docker-compose scale web=3

docker ps
# => 0d7a73e5ebd2        regsvcs-webui:latest   "/bin/sh -c 'service "   About an hour ago   Up 55 minutes       0.0.0.0:32768->80/tcp         dockerpro_web_2
#    abec69fab0bb        regsvcs-webui:latest   "/bin/sh -c 'service "   About an hour ago   Up 55 minutes       0.0.0.0:32770->80/tcp         dockerpro_web_3
#    1f2a4a8e12c7        regsvcs-webui:latest   "/bin/sh -c 'service "   About an hour ago   Up 55 minutes       0.0.0.0:32769->80/tcp         dockerpro_web_1

```


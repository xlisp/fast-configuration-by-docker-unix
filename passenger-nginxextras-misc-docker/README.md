# 1. testone
```bash
sudo docker build -t testone -f Dockerfile.testone .  # (Successfully built)
sudo docker run -d -p 80:80 -it testone:latest 
sudo docker exec -it ` sudo docker ps | grep testone | awk '{print $1}' ` /bin/bash
```

```bash
# create: https://hub.docker.com/r/chanshunli/passenger-nginxextras-misc-docker-testone/
docker run -it  testone /bin/bash #=> c id : 3b469e1d758b
docker login
docker commit 3b469e1d758b chanshunli/passenger-nginxextras-misc-docker-testone
docker push chanshunli/passenger-nginxextras-misc-docker-testone
```

```bash
root@340d3015f8a9:/# passenger-config --nginx-addon-dir
/usr/share/passenger/ngx_http_passenger_module
root@340d3015f8a9:/#
```

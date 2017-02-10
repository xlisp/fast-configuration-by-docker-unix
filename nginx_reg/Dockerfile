FROM nginx 

RUN \
  apt-get update && \
  apt-get install -y vim

COPY nginx_slime.conf /etc/nginx/nginx.conf

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Define working directory.
WORKDIR /etc/nginx

RUN service nginx start

# Expose ports.
EXPOSE 80
EXPOSE 443

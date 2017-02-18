FROM nginx:1.11.3

# Generate nginx config file from template
COPY nginx.conf.template /tmp/nginx.conf.template
COPY htpasswd /etc/nginx/conf/htpasswd
COPY initialize.sh /tmp/initialize.sh

CMD "/tmp/initialize.sh"

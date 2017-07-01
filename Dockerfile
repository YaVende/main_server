FROM nginx:1.11.3

RUN apt-get update && apt-get install -y rsync

# Generate nginx config file from template
COPY nginx_conf    /tmp/nginx_conf
COPY initialize.sh /tmp/initialize.sh
COPY certs         /tmp/certs
COPY accepted_vars /tmp/accepted_vars
COPY misc/dhparam.pem /etc/ssl/certs/dhparam.pem

ENV ACME_CHALLENGE_PATH=/var/www/acme_challenge
ENV SSL_CERTS_PATH=/var/default_certs
ENV SSL_CERTIFICATE=$SSL_CERTS_PATH/selfsigned.crt
ENV SSL_CERTIFICATE_KEY=$SSL_CERTS_PATH/selfsigned.key

CMD "/tmp/initialize.sh"

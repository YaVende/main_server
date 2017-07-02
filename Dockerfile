FROM nginx:1.11.3

RUN apt-get update && apt-get install -y rsync

ENV ACME_CHALLENGE_DIR=/var/www/acme_challenge
ENV SSL_CERTS_DIR=/var/default_certs
ENV SSL_CERTIFICATE=$SSL_CERTS_DIR/selfsigned.crt
ENV SSL_CERTIFICATE_KEY=$SSL_CERTS_DIR/selfsigned.key

CMD "/tmp/initialize.sh"

# Generate nginx config file from template
COPY nginx_conf    /tmp/nginx_conf
COPY certs         /tmp/certs
COPY misc/dhparam.pem /etc/ssl/certs/dhparam.pem
COPY required_vars /tmp/required_vars
COPY initialize.sh /tmp/initialize.sh

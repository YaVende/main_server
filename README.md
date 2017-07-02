[![build status](https://gitlab.alfred.yavende.com/dev_ops/main_server/badges/master/build.svg)](https://gitlab.alfred.yavende.com/dev_ops/main_server/commits/master)

# Main Server

This is a dockerized nginx image meant to be used as a base for any main server.

## Features

- Configurable via environment variables
- Configurable list of required environment vars
- Snippets for common tasks:
  - ACME challenge, for integration with letsencrpyt
  - HTML5 application cache
  - Gzip compression
  - HTTPS
  - Redirect to HTTPS
  - Prerenderization via [self hosted] Prerender.io
  - Configuration for rails apps

### Configuration
All files in `/tmp/nginx_conf/**/*.template` will be replaced via `enbsubst`, using a list of variables you should include in the file `/tmp/required_vars` with this format:

~~~
$REQUIRED_VAR_NAME_1
$REQUIRED_VAR_NAME_2
$REQUIRED_VAR_NAME_3
~~~

Then the folder `/tmp/nginx_conf` will be merged into `/etc/nginx`.

Example usage:

~~~Dockerfile
FROM registry.alfred.yavende.com/dev_ops/main_server:development
COPY nginx_conf/sites-enabled /tmp/nginx_conf/sites-enabled
RUN rm /tmp/required_vars
COPY required_vars /tmp/required_vars
~~~

### Letsencrypt integration
Use in conjuction with our dockerized certbot (https://gitlab.alfred.yavende.com/dev_ops/certbot). Example usage:

~~~yml
nginx:
  image: registry.alfred.yavende.com/dev_ops/main_server:latest
  restart: on-failure:3
  ports: ["80:80", "443:443"]
  volumes:
    - acme_challenge:/var/www/acme_challenge
    - ssl_certs:/var/certs

# Certbot renews SSL certificates periodically
certbot:
  image: registry.alfred.yavende.com/dev_ops/certbot:v1.1.0
  environment:
    - WEBROOT_PATH=/var/www/acme_challenge
    - SIGNING_EMAIL=info@yavende.com
    - CERTS_PATH=/var/certs
  volumes:
    - acme_challenge:/var/www/acme_challenge
    - ssl_certs:/var/certs
    - certbot_data:/etc/letsencrypt

volumes:
  acme_challenge:
  ssl_certs:
  certbot_data:
~~~

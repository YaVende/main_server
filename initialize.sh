#!/bin/bash

# For each file in /tmp/nginx_conf that ends with '.template',
# replace env variables using envsubst, and remove the source template.
# Then merge the contents of /tmp/nginx_conf into /etc/nginx

for f in $(find /tmp/nginx_conf | grep "\.template$"); do
  cat $f \
    | \
      envsubst '\
      \$ACME_CHALLENGE_PATH \
 
      \$ADMIN_ASSETS_PATH   \
      \$ADMIN_DOMAIN        \
      \$ADMIN_SOCK_PATH     \

      \$API_ASSETS_PATH     \
      \$API_DOMAIN          \
      \$API_SOCK_PATH       \

      \$ERRBIT_DOMAIN       \
      \$ERRBIT_HOST         \

      \$FRONT_DOMAIN        \
      \$FRONT_ASSETS_PATH   \

      \$PGADMIN_DOMAIN      \
      \$PGADMIN_HOST        \

      \$SOCK_FILE           \

      \$PRERENDER_HOST      \

      \$SSL_CERTIFICATE     \
      \$SSL_CERTIFICATE_KEY \
    ' \
    > ${f%.template}

  rm $f
done

rsync -ra /tmp/nginx_conf/* /etc/nginx/
rsync -ra /tmp/certs/* $SSL_CERTS_PATH/

ln -sf /dev/stdout $ACCESS_LOG
ln -sf /dev/stdout $ERROR_LOG

nginx -g 'daemon off;'

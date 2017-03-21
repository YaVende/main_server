#!/bin/bash
cat /tmp/nginx.conf.template \
  | \
    envsubst '\
    \$API_DOMAIN \
    \$API_SOCK_PATH \
    \$API_ASSETS_PATH \

    \$ADMIN_DOMAIN \
    \$ADMIN_SOCK_PATH \
    \$ADMIN_ASSETS_PATH \

    \$FRONT_DOMAIN \

    \$SOCK_FILE \
    \$ERRBIT_DOMAIN \
    \$ERRBIT_HOST \
    \$PGADMIN_DOMAIN \
    \$PGADMIN_HOST \
  ' \
  > /etc/nginx/nginx.conf

ln -sf /dev/stdout $ACCESS_LOG
ln -sf /dev/stdout $ERROR_LOG

nginx -g 'daemon off;'

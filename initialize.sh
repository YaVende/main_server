#!/bin/bash
cat /tmp/nginx.conf.template \
  | \
    envsubst '\
    \$API_DOMAIN \
    \$API_SOCK_PATH \
    \$API_ASSETS_PATH \

    \$DOMAIN_DOMAIN \
    \$DOMAIN_SOCK_PATH \
    \$DOMAIN_ASSETS_PATH \

    \$FRONT_DOMAIN \

    \$SOCK_FILE \
    \$ERRBIT_DOMAIN \
    \$ERRBIT_HOST \
    \$PGADMIN_DOMAIN \
    \$PGADMIN_HOST \
  ' \
  > /etc/nginx/nginx.conf

echo "This is what /etc/nginx/nginx.conf looks like:"
cat /etc/nginx/nginx.conf

ln -sf /dev/stdout $ACCESS_LOG
ln -sf /dev/stdout $ERROR_LOG

nginx -g 'daemon off;'

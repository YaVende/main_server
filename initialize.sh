#!/bin/bash
cat /tmp/nginx.conf.template \
  | \
    envsubst '\
    \$ADMIN_ASSETS_PATH \
    \$ADMIN_DOMAIN \
    \$ADMIN_SOCK_PATH \

    \$API_ASSETS_PATH \
    \$API_DOMAIN \
    \$API_SOCK_PATH \

    \$ERRBIT_DOMAIN \
    \$ERRBIT_HOST \

    \$FRONT_DOMAIN \
    \$FRONT_ASSETS_PATH \

    \$PGADMIN_DOMAIN \
    \$PGADMIN_HOST \

    \$SOCK_FILE \

    \$PRERENDER_HOST \
  ' \
  > /etc/nginx/nginx.conf

echo "This is what /etc/nginx/nginx.conf looks like:"
cat /etc/nginx/nginx.conf

ln -sf /dev/stdout $ACCESS_LOG
ln -sf /dev/stdout $ERROR_LOG

nginx -g 'daemon off;'

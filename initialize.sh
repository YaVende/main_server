#!/bin/bash
cat /tmp/nginx.conf.template \
  | \
    envsubst '\
    \$API_DOMAIN \
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
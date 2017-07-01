#!/bin/bash

# For each file in /tmp/nginx_conf that ends with '.template',
# replace env variables using envsubst, and remove the source template.
# Then merge the contents of /tmp/nginx_conf into /etc/nginx

declare -a accepted_vars=$(cat /tmp/accepted_vars.yml)

for f in $(find /tmp/nginx_conf | grep "\.template$"); do
  cat $f | envsubst $() \
    > ${f%.template}

  rm $f
done

rsync -ra /tmp/nginx_conf/* /etc/nginx/
rsync -ra /tmp/certs/* $SSL_CERTS_PATH/

ln -sf /dev/stdout $ACCESS_LOG
ln -sf /dev/stdout $ERROR_LOG

nginx -g 'daemon off;'

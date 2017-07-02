#!/bin/bash

# For each file in /tmp/nginx_conf that ends with '.template',
# replace env variables using envsubst, and remove the source template.
# Then merge the contents of /tmp/nginx_conf into /etc/nginx

# Required variables are read from /tmp/required_vars
# File should have a variable name per line, preceded with a dollar sign.
# Example:
# $VAR1
# $VAR2
declare required_vars="\
  $(cat /tmp/required_vars)
  \$ACME_CHALLENGE_DIR
  \$SSL_CERTS_DIR
  \$SSL_CERTIFICATE
  \$SSL_CERTIFICATE_KEY
"

# Remove dollar sign in variable name and store all var names in an array
IFS=' '; read -a non_prefixed_var_names <<< $(
  echo $required_vars \
    | sed ':a;N;$!ba;s/\n/ /g' \
    | sed 's/\$//g' \
)

for var_name in "${non_prefixed_var_names[@]}"
do
  if [[ ! -v $var_name ]]; then
    echo "Missing environment variable $var_name"
    exit 1
  fi
done

for f in $(find /tmp/nginx_conf | grep "\.template$"); do
  cat $f | envsubst "$required_vars" > ${f%.template}
  rm $f
done

rsync -ra /tmp/nginx_conf/* /etc/nginx/
rsync -ra /tmp/certs/* $SSL_CERTS_DIR/

ln -sf /dev/stdout $ACCESS_LOG
ln -sf /dev/stdout $ERROR_LOG

nginx -g 'daemon off;'

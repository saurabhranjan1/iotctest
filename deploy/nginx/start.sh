#!/bin/sh

set -e

if [ -z $BASIC_AUTH_USERNAME ]; then
  echo >&2 "BASIC_AUTH_USERNAME must be set"
  exit 1
fi

if [ -z $BASIC_AUTH_PASSWORD ]; then
  echo >&2 "BASIC_AUTH_PASSWORD must be set"
  exit 1
fi

htpasswd -bc /etc/nginx/.htpasswd $BASIC_AUTH_USERNAME $BASIC_AUTH_PASSWORD
exec nginx-debug -g "daemon off;"
# exec nginx -t
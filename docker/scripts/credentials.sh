#!/bin/bash
DIR=$(pwd)/docker/tmp

[ -z "$MYSQL_USER" ] && MYSQL_USER=${SERVICE}
[ -z "$MYSQL_DATABASE" ] && MYSQL_DATABASE=${SERVICE}_${RAILS_ENV}

root_key_file=${DIR}/root.key
user_key_file=${DIR}/${MYSQL_USER}.key

if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
  if [ -f "$root_key_file" ]; then
    MYSQL_ROOT_PASSWORD=$(cat ${root_key_file})
  else
    MYSQL_ROOT_PASSWORD=$(openssl rand -base64 32 | tr /+ -_ | tr -d '\n')
    echo "$MYSQL_ROOT_PASSWORD" >> ${root_key_file}
  fi
fi

if [ -z "$MYSQL_PASSWORD" ]; then
  if [ -f "$user_key_file" ]; then
    MYSQL_PASSWORD=$(cat ${user_key_file})
  else
    MYSQL_PASSWORD=$(openssl rand -base64 32 | tr /+ -_ | tr -d '\n')
    echo "$MYSQL_PASSWORD" >> ${user_key_file}
  fi
fi

export MYSQL_USER MYSQL_DATABASE MYSQL_ROOT_PASSWORD MYSQL_PASSWORD

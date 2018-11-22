#!/bin/bash

function fail {
  echo $1 >&2
  exit 1
}

function retry {
  local n=1
  local max=10
  local delay=15
  while true; do
    "$@" && break || {
      if [[ $n -lt $max ]]; then
        ((n++))
        echo "Attempt $n/$max:"
        sleep $delay;
      else
        fail "Exitting after $n attempts."
      fi
    }
  done
}

function setPrivileges {
  DB_CONTAINER="${SERVICE}_mariadb_1"
  # Execute the command inside the container to grant access
cat <<EOF | tee tmp/privileges | docker exec -i ${DB_CONTAINER} mysql -uroot -p${MYSQL_ROOT_PASSWORD} -h127.0.0.1
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' WITH GRANT OPTION;
FLUSH PRIVILEGES;
FLUSH HOSTS;
EOF
}
#!/bin/bash

RAILS_PORT=3000

wait_for() {
  host="$1"
  port="$2"
  while ! nc -z mariadb 3306; do
    echo "Waiting for mariadb"
    sleep 1
  done
}

#echo "Waiting for MariaDB to start..."
wait_for mariadb 3306

#echo "Waiting for Redis to start..."
wait_for redis 6379

# Initialize database
echo "Executing db:create:"
rake db:exists || rake db:setup
/app/bin/rails db:create
echo "Executing db:migrate:"
/app/bin/rails db:migrate
echo "Executing db:seed:"
/app/bin/rails db:seed

# Remove pids
/bin/rm -f /app/tmp/pids/server.pid \
           /app/tmp/pids/puma.pid

# Initialize Ruby on Rails
exec /app/bin/rails server -b 0.0.0.0 -p ${RAILS_PORT}
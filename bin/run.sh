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

#echo "Waiting for Elasticsearch to start..."
wait_for elasticsearch 9200

# Initialize database
echo "Executing rake db:create"
/app/bin/rails db:create
echo "Executing rake db:migrate"
/app/bin/rails db:migrate
echo "Executing rake db:seed"
/app/bin/rails db:seed

echo "Executing rake ubs:csv_first_import"
/app/bin/rails ubs:csv_first_import

# Remove pids
/bin/rm -f /app/tmp/pids/server.pid \
           /app/tmp/pids/puma.pid

# Initialize Ruby on Rails
exec /app/bin/rails server -b 0.0.0.0 -p ${RAILS_PORT}
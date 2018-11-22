#!/bin/bash

source .env

if [ -z "$RELEASE" ]; then
  export RELEASE=$(git symbolic-ref -q --short HEAD || git describe --tags --exact-matc)
fi

# If $PROJECT not defined in .env, exit
if [ -z "${SERVICE}" ] || [ -z "${RELEASE}" ]; then
  echo ".env file must contain at least SERVICE and RELEASE. Exitting."
  exit -1
fi

# Mysql
source docker/scripts/credentials.sh

# control
case "${1}" in
  "build")
    [ -f docker-compose.${ENV}.yml ] && COMPOSE_ENV="-f docker-compose.${ENV}.yml"
    docker-compose -f docker-compose.yml ${COMPOSE_ENV} build ${2}
    ;;

  "up"|"start")
    [ -f docker-compose.${ENV}.yml ] && COMPOSE_ENV="-f docker-compose.${ENV}.yml"

    # first up mariadb and set privileges
    env $(cat .env | grep ^[A-Z] | xargs) docker-compose -f docker-compose.yml ${COMPOSE_ENV} up -d mariadb
    source docker/scripts/privileges.sh
    retry setPrivileges

    # up stack
    env $(cat .env | grep ^[A-Z] | xargs) docker-compose -f docker-compose.yml ${COMPOSE_ENV} up -d
    ;;

  "stop")
    [ -f docker-compose.${ENV}.yml ] && COMPOSE_ENV="-f docker-compose.${ENV}.yml"
    env $(cat .env | grep ^[A-Z] | xargs) docker-compose -f docker-compose.yml ${COMPOSE_ENV} stop
    ;;

  "log")
    env $(cat .env | grep ^[A-Z] | xargs) docker-compose logs --tail=80 ${2}
    ;;

  "logs")
    env $(cat .env | grep ^[A-Z] | xargs) docker-compose logs --tail=500 -f ${2}
    ;;

  "bash")
    env $(cat .env | grep ^[A-Z] | xargs) docker-compose -f docker-compose.yml ${COMPOSE_ENV} exec ${SERVICE} bash -l
    ;;
  *)
    echo "Usage: $0 (build|up|start|stop|log|logs|bash)"
esac

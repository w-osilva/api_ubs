#!/bin/bash

source .env

if [ -z "$MYSQL_USER" ]; then
  export MYSQL_USER="$(bin/rails credentials:show | grep mysql_user | awk '{print $2}')"
fi
if [ -z "$MYSQL_PASSWORD" ]; then
  export MYSQL_PASSWORD="$(bin/rails credentials:show | grep mysql_password | awk '{print $2}')"
fi
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
  export MYSQL_ROOT_PASSWORD="$(bin/rails credentials:show | grep mysql_root_password | awk '{print $2}')"
fi
if [ -z "$RELEASE" ]; then
  export RELEASE=$(git symbolic-ref -q --short HEAD || git describe --tags --exact-matc)
fi

source .env

# If $PROJECT not defined in .env, exit
if [ -z "${SERVICE}" ] || [ -z "${RELEASE}" ]; then
  echo ".env file must contain at least SERVICE and RELEASE. Exitting."
  exit -1
fi

case "${1}" in
  "build")
    [ -f docker-compose.${ENV}.yml ] && COMPOSE_ENV="-f docker-compose.${ENV}.yml"
    docker-compose -f docker-compose.yml ${COMPOSE_ENV} build ${2}
#    docker-compose -f docker-compose.yml ${COMPOSE_ENV} push
    ;;

  "up"|"start")
#    [ -f docker-compose.${ENV}.yml ] && COMPOSE_ENV="--compose-file docker-compose.${ENV}.yml"
#    env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy --compose-file docker-compose.yml ${COMPOSE_ENV} ${SERVICE}
    [ -f docker-compose.${ENV}.yml ] && COMPOSE_ENV="-f docker-compose.${ENV}.yml"
    env $(cat .env | grep ^[A-Z] | xargs) docker-compose -f docker-compose.yml ${COMPOSE_ENV} up -d

    source docker/storage/privileges.sh
    retry setPrivileges
    ;;

  "stop")
#    docker stack rm ${SERVICE}
    [ -f docker-compose.${ENV}.yml ] && COMPOSE_ENV="-f docker-compose.${ENV}.yml"
    env $(cat .env | grep ^[A-Z] | xargs) docker-compose -f docker-compose.yml ${COMPOSE_ENV} stop
    ;;

#  "restart")
#    [[ -z "$2" ]] && interval="10s" || interval="$2"
#    docker service update --update-parallelism 1 --force --update-delay ${interval} ${SERVICE}_${SERVICE}
#    ;;

  "log")
#    docker service logs --tail=80 ${SERVICE}_${SERVICE}
    env $(cat .env | grep ^[A-Z] | xargs) docker-compose logs --tail=80 ${2}
    ;;

  "logs")
#    docker service logs --tail=200 -f ${SERVICE}_${SERVICE}
    env $(cat .env | grep ^[A-Z] | xargs) docker-compose logs --tail=500 -f ${2}
    ;;

  "bash")
#    docker container exec -it $(docker ps | grep ${SERVICE}_${SERVICE} | awk '{print $1}') bash
    env $(cat .env | grep ^[A-Z] | xargs) docker-compose -f docker-compose.yml ${COMPOSE_ENV} exec ${SERVICE} bash -l
    ;;
  *)
    echo "Usage: $0 (build|up|start|stop|log|logs|bash)"
esac

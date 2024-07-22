#!/bin/bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list or a compound command returns a non-zero status.
# https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#The-Set-Builtin
set -e

# Determine the full directory path of the script no matther where it is being
# called from.
# https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# The source command reads and executes commands from the file specified as its
# argument in the current shell environment. It is useful to load functions,
# variables, and configuration files into shell scripts.
source "${SCRIPT_DIR}/read-env-config.sh" ${@}

if [ "$1" = '--help' ]; then
    echo "how to use:"
    echo "./<script.sh> <environment> <extension1> ... <extension N>"
    echo "   <environment> : main config from ./environments. Required"
    echo "   <extension1> : one of configuration overrides in ./environments, that extending the main config. Default is empty(no overrides)"
    exit 0;
fi

#this should be name of application container in your docker-compose.yml
APP_CONTAINER_NAME="pizza"

mvn install -P skipFrontendBuild

docker-compose ${DOCKER_COMPOSE_EXTRA_ARGS} rm -sf ${APP_CONTAINER_NAME}
docker-compose ${DOCKER_COMPOSE_EXTRA_ARGS} up -d ${APP_CONTAINER_NAME}

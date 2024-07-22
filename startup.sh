#!/bin/bash

# Determine the full directory path of the script no matther where it is being
# called from.
# https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Print help on stdout
if [ "$1" = '--help' ]; then
    echo "how to use:"
    echo "./startup.sh <environment> <extension1> ... <extension N>"
    echo "   <environment> : main config from ./environments. Required"
    echo "   <extension1> : one of configuration overrides in ./environments, that extending the main config. Default is empty(no overrides)"
    exit 0;
fi

echo "INFO: PROXY_HOST is to: ${PROXY_HOST}"

# The source command reads and executes commands from the file specified as its
# argument in the current shell environment. It is useful to load functions,
# variables, and configuration files into shell scripts.
source "${SCRIPT_DIR}/read-env-config.sh" ${@}

# Run dcmerge to merge all found docker-compose files. Use the environment
# variable DOCKER_COMPOSE_FILES to do this.
"${SCRIPT_DIR}/scripts/dcmerge.sh" ${DOCKER_COMPOSE_FILES}

# Generate App2App certificates via generate-certificate.sh and the merged
# docker-compose file by dcmerge. Furthermore, generate-certificates calls the
# sub script uctl.sh as wrapper for generating the certificates.
"${SCRIPT_DIR}/scripts/generate-certificates.sh"

# Print docker-compose config on stdout
echo "=============================== BEGIN: DOCKER-COMPOSE CONFIG ==============================="
docker-compose ${DOCKER_COMPOSE_EXTRA_ARGS} config
echo "=============================== END:   DOCKER-COMPOSE CONFIG ==============================="

# 'Restart' the environment
#docker-compose ${DOCKER_COMPOSE_EXTRA_ARGS} down
docker-compose ${DOCKER_COMPOSE_EXTRA_ARGS} up -d --scale qu-seed=${REPLICA_COUNT:-1}
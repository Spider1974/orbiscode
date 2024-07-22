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

# Shutdown all running applications
docker-compose ${DOCKER_COMPOSE_EXTRA_ARGS} stop
docker-compose ${DOCKER_COMPOSE_EXTRA_ARGS} rm -f

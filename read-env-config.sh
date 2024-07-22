#!/bin/bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list or a compound command returns a non-zero status.
# https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#The-Set-Builtin
set -e

# Determine the full directory path of the script no matter where it is being
# called from.
# https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Verify if at least one argument is passed to this shell script.
if [ "$#" -eq 0 ]; then
  # use find to retrieve possible environments from folder ./environments and convert them in a comma separated list
  ENVIRONMENT_LIST="$(find "${SCRIPT_DIR}"/environments/* -maxdepth 1 -type d -print0 | xargs -0 -n1 -- basename | sed 's/$/, /g' | xargs echo | sed 's/,$//g')"
  echo "ERROR: Require at least one name of an environment: ${ENVIRONMENT_LIST}"
  exit 1
fi

# DOCKER_COMPOSE_FILES contains the absolute paths to all found docker-compose
# files inside the passed environments.
DOCKER_COMPOSE_FILES=""

# DOCKER_COMPOSE_EXTRA_ARGS contains extra arguments for the docker-compose
# binary.
DOCKER_COMPOSE_EXTRA_ARGS=""

# If global .env file exists load defined variables.
if [ -e "${SCRIPT_DIR}/.env" ]; then
  echo "INFO: Read .env file: ${SCRIPT_DIR}/.env"
  set -a
  source "${SCRIPT_DIR}/.env"
  set +a
fi


# kafka and schema registry are mandatory environments for the application to run so making sure they are included
ENVIRONMENTS=("$@")
if [[ ! " ${ENVIRONMENTS[*]} " =~ " kafka " ]]; then
  ENVIRONMENTS+=("kafka")
fi
if [[ ! " ${ENVIRONMENTS[*]} " =~ " schema-registry " ]]; then
  ENVIRONMENTS+=("schema-registry")
fi

# Iterate over all passed ENVIRONMENTS
for ENVIRONMENT in ${ENVIRONMENTS[@]}; do
  ENVIRONMENT_PATH="${SCRIPT_DIR}/environments/${ENVIRONMENT}"

  if [ ! -d "${ENVIRONMENT_PATH}" ]; then
    echo "ERROR: Environment ${ENVIRONMENT} does not exists."
    exit 1;
  fi

  # Merge environment specific .env file into the context of the global .env
  # file.
  if [ -f "${ENVIRONMENT_PATH}/.env" ]; then
    echo "INFO: Read .env file: ${ENVIRONMENT_PATH}/.env"
    set -a
    source "${ENVIRONMENT_PATH}/.env"
    set +a
  fi

  # Extend COMPOSE_FILES for each found *.yml file found in ENVIRONMENT_PATH.
  for DOCKER_COMPOSE_FILE in "${ENVIRONMENT_PATH}"/*.yml; do
    [ -e "$DOCKER_COMPOSE_FILE" ] || continue # if file does not exist, skip loop
    echo "INFO: Use docker-compose file: ${DOCKER_COMPOSE_FILE}"
    DOCKER_COMPOSE_EXTRA_ARGS+=" -f ${DOCKER_COMPOSE_FILE}"
    DOCKER_COMPOSE_FILES+="${DOCKER_COMPOSE_FILE} "
  done
done

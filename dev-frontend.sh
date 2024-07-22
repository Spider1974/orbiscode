#!/bin/bash

export UPSTREAM_HOST="$(hostname | tr '[:upper:]' '[:lower:]').dedalus.lan"
if [ "$(uname)" == "Linux" ]; then
  echo "Linux OS detected"
  export UPSTREAM_HOST=$(hostname -f)
fi

export UPSTREAM_URL="https://${UPSTREAM_HOST}";

echo "Env variable UPSTREAM_URL set to:" ${UPSTREAM_URL}

script_dir="$(dirname "$0")"
(cd ${script_dir}/frontend/ui && yarn start)
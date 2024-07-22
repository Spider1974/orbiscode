#!/bin/bash

export UPSTREAM_URL="http://localhost:8080"

echo "Env variable UPSTREAM_URL set to:" ${UPSTREAM_URL}

script_dir="$(dirname "$0")"
(cd ${script_dir}/frontend/ui && yarn start)
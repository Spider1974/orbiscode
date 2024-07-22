#!/bin/sh

keycloak_host=${EXTERNAL_KEYCLOAK_HOST:-host.docker.internal}

curl -q \
  -s \
  --insecure \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d 'grant_type=password&client_id=orbis-u-webclient&username=schulung&password=schulung&=' "https://${keycloak_host}/auth/realms/orbis/protocol/openid-connect/token" \
  | sed -r -e 's/\{"access_token":"([^"]*).*/Bearer \1/'
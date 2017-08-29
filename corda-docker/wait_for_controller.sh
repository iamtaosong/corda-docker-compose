#!/bin/bash

set -e

CONTROLLER="${1:-172.16.238.10:10004}"
shift
CMD="${@:-/sbin/my_init}"

while [[ "$(curl -s -o /dev/null -w ''%{HTTP_CODE}'' $CONTROLLER)" != "200" ]]
do
  sleep 5
  echo "Waiting for controller (corda-webserver)..."
done
exec $CMD
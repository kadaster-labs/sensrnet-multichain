#!/bin/bash

set -m

wait() {
  echo "Waiting for $1 seconds"
  sleep $1
}

start () {
  if [[ $DELAY_INIT == 1 ]]; then
    wait 10
  fi

  if [ -z "$MAIN_NODE_HOST" ]; then
    ./multichain.sh &
    ./streams.sh

    fg %1
  else
    ./multichain.sh
  fi
}

if [ "$1" = "start" ]; then
  start
else
  exec "$@"
fi

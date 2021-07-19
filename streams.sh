#!/bin/bash

set -m

wait() {
  echo "Waiting for $1 seconds"
  sleep $1
}

create_streams () {
  for stream in 'legalentity' 'sensordevice' 'observationgoal' ;
  do
    echo "Creating stream: $stream"
    multichain-cli $CHAINNAME -datadir=/data create stream $stream true
  done
}

# Wait a bit as the Multichain daemon is started in background. This prevents
# racing conditions where multichain-cli tries to create streams while the chain
# isn't created yet
wait 10

create_streams

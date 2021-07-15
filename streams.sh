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


wait 10
create_streams

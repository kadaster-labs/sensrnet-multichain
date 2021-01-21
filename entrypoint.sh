#!/bin/bash

init_chain() {
  echo "Init a chain: $CHAINNAME."

  multichain-util create $CHAINNAME \
    -datadir=/data

  # Set some required parameters in the params.dat
  sed -i "s/^default-network-port.*/default-network-port = $NETWORK_PORT/" /data/$CHAINNAME/params.dat
  sed -i "s/^default-rpc-port.*/default-rpc-port = $RPC_PORT/" /data/$CHAINNAME/params.dat
  sed -i "s/^chain-name.*/chain-name = $CHAINNAME/" /data/$CHAINNAME/params.dat
  sed -i "s/^chain-description.*/chain-description = MultiChain $CHAINNAME/" /data/$CHAINNAME/params.dat

  # Loop over all variables that start with PARAM_: e.g. PARAM_BLOCKTIME='target-block-time|40';
  ( set -o posix ; set ) | sed -n '/^PARAM_/p' | while read PARAM; do
      IFS='=' read -ra KV <<< "$PARAM"
      IFS='|' read -ra KV <<< "${!KV[0]}"
      sed -i "s/^${KV[0]}.*/${KV[0]} = ${KV[1]}/" /data/$CHAINNAME/params.dat
  done
}

wait() {
  echo "Waiting for $1 seconds"
  sleep $1
}

start_main_node () {
  echo "Start main node with chain: $CHAINNAME."

  if [ ! -d /data/$CHAINNAME ]; then
    init_chain
  fi

  cat /data/$CHAINNAME/params.dat

  cat << EOF > /data/$CHAINNAME/multichain.conf
  rpcuser=$RPC_USER
  rpcpassword=$RPC_PASSWORD
  rpcallowip=$RPC_ALLOW_IP
  rpcport=$RPC_PORT
EOF
  cp /data/$CHAINNAME/multichain.conf /data/multichain.conf

  multichaind $CHAINNAME \
    -daemon \
    -txindex \
    -shrinkdebugfilesize \
    -datadir=/data

  wait 10

  for stream in 'organizations' 'sensors' ;
  do
    echo "Creating stream: $stream"
    multichain-cli $CHAINNAME -datadir=/data create stream $stream true
  done
}

start_node () {
  echo "Start node with chain: $CHAINNAME."

  if [[ $MAIN_NODE_HOST =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    IP=$MAIN_NODE_HOST
  else
    IP=$(dig +short $MAIN_NODE_HOST)
  fi

  multichaind $CHAINNAME@$IP:$NETWORK_PORT \
    -daemon \
    -txindex \
    -shrinkdebugfilesize \
    -rpcuser=$RPC_USER \
    -rpcpassword=$RPC_PASSWORD \
    -rpcallowip=$RPC_ALLOW_IP \
    -rpcport=$RPC_PORT \
    -datadir=/data

  wait 10
}

start_explorer() {
  echo "Run the explorer"

  cat << EOF > /data/$CHAINNAME/multichain.conf
  rpcuser=$RPC_USER
  rpcpassword=$RPC_PASSWORD
  rpcallowip=$RPC_ALLOW_IP
  rpcport=$RPC_PORT
EOF

  cat << EOF > /root/explorer.conf
  port 2750
  host 0.0.0.0
  datadir += [{
    "dirname": "/data/$CHAINNAME",
    "loader": "default",
    "chain": "MultiChain $CHAINNAME",
    "policy": "MultiChain"
  }]
  dbtype = sqlite3
  connect-args = dockerchain.explorer.sqlite
EOF

  python -m Mce.abe --config /root/explorer.conf --commit-bytes 100000 --no-serve
  wait 5
  python -m Mce.abe --config /root/explorer.conf
}


if [[ $DELAY_INIT == 1 ]]; then
  wait 10
fi

if [ -z "$MAIN_NODE_HOST" ]; then
  start_main_node
else
  start_node
fi

start_explorer

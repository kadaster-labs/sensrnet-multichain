#!/bin/bash

set -m

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

  exec multichaind $CHAINNAME \
    -txindex \
    -shrinkdebugfilesize \
    -datadir=/data \
    -initprivkey=$PRIVATE_KEY
}

start_node () {
  if [[ $MAIN_NODE_HOST =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    IP=$MAIN_NODE_HOST
  else
    IP=$(dig +short $MAIN_NODE_HOST)
  fi

  echo "Start node with existing chain: $CHAINNAME from $IP:$NETWORK_PORT"

  exec multichaind $CHAINNAME@$IP:$NETWORK_PORT \
      -txindex \
      -shrinkdebugfilesize \
      -rpcuser=$RPC_USER \
      -rpcpassword=$RPC_PASSWORD \
      -rpcallowip=$RPC_ALLOW_IP \
      -rpcport=$RPC_PORT \
      -datadir=/data \
      -initprivkey=$PRIVATE_KEY
}

if [ -z "$MAIN_NODE_HOST" ]; then
  start_main_node
else
  start_node
fi

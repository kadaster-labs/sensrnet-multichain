#!/bin/bash

if [[ $DELAY_INIT == 1 ]];
then
  echo "Wait to ensure the entry node is initialised."
  sleep 10
fi

echo "Start the chain."
if [ -z "$MASTER_NODE_HOST" ];
then
  # Create the chain if it is not there yet
  if [ ! -d /data/$CHAINNAME ];
  then
      multichain-util create \
        $CHAINNAME \
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
  fi

  cat /data/$CHAINNAME/params.dat

  cat << EOF > /data/$CHAINNAME/multichain.conf
  rpcuser=$RPC_USER
  rpcpassword=$RPC_PASSWORD
  rpcallowip=$RPC_ALLOW_IP
  rpcport=$RPC_PORT
EOF

  cp /data/$CHAINNAME/multichain.conf /data/multichain.conf

  multichaind \
    $CHAINNAME \
    -daemon \
    -txindex \
    -shrinkdebugfilesize \
    -datadir=/data
else
  if [[ $MASTER_NODE_HOST =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]];
  then
    IP=$MASTER_NODE_HOST
  else
    IP=$(dig +short $MASTER_NODE_HOST)
  fi

  multichaind \
    $CHAINNAME@$IP:$NETWORK_PORT \
    -daemon \
    -txindex \
    -shrinkdebugfilesize \
    -rpcuser=$RPC_USER \
    -rpcpassword=$RPC_PASSWORD \
    -rpcallowip=$RPC_ALLOW_IP \
    -rpcport=$RPC_PORT \
    -datadir=/data
fi

echo "Wait 10 seconds to ensure we are initialised"
sleep 10

echo "Setup /data/$CHAINNAME/multichain.conf"
cat << EOF > /data/$CHAINNAME/multichain.conf
rpcuser=$RPC_USER
rpcpassword=$RPC_PASSWORD
rpcallowip=$RPC_ALLOW_IP
rpcport=$RPC_PORT
EOF

echo "Setup /root/explorer.conf"
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

echo "Run the explorer"
python -m Mce.abe --config /root/explorer.conf --commit-bytes 100000 --no-serve
sleep 5
python -m Mce.abe --config /root/explorer.conf

#!/bin/bash

echo "Sleep for 10 seconds so the master node has initialised"
sleep 10

if [[ $MASTER_NODE_HOST =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  IP=$MASTER_NODE_HOST
else
  IP=$(dig +short $MASTER_NODE_HOST)
fi

echo "Start the chain"
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

echo "Sleep for 10 seconds so the node has initialised"
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
python -m Mce.abe --config /root/explorer.conf

#!/bin/bash

echo "Start the chain"
multichaind \
  -daemon \
  -txindex \
  -shrinkdebugfilesize \
  $CHAINNAME@$MASTER_NODE_HOST:$NETWORK_PORT \
  -rpcuser=$RPC_USER \
  -rpcpassword=$RPC_PASSWORD \
  -rpcallowip=$RPC_ALLOW_IP \
  -rpcport=$RPC_PORT \
  -datadir=/data/

echo "Sleep for 10 seconds so the node has initialised"
sleep 10

echo "Setup /data/$CHAINNAME/multichain.conf"
cat << EOF > /data/$CHAINNAME/multichain.conf
rpcuser=$RPC_USER
rpcpassword=$RPC_PASSWORD
rpcallowip=$RPC_ALLOW_IP
rpcport=$RPC_PORT
EOF

echo "Setup /data/explorer.conf"

cat << EOF > /data/explorer.conf
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
python -m Mce.abe --config /data/explorer.conf --commit-bytes 100000 --no-serve
python -m Mce.abe --config /data/explorer.conf

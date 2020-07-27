#!/bin/bash -x

echo "Sleep for 15 seconds so the master node has initialised"
sleep 15

echo "Start the chain"
multichaind -txindex -printtoconsole -shrinkdebugfilesize $CHAINNAME@$MASTER_NODE:$NETWORK_PORT -rpcuser=$RPC_USER -rpcpassword=$RPC_PASSWORD -rpcallowip=$RPC_ALLOW_IP -rpcport=$RPC_PORT

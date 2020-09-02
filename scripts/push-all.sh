#!/bin/bash

set -ex

# Build base image in case this hasn't been done yet
docker build -t multichain base/

./scripts/push-masternode.sh
./scripts/push-node.sh
./scripts/push-explorer.sh

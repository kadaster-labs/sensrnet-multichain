#!/bin/bash

set -ex

# SET THE FOLLOWING VARIABLES
REGISTRY=sensrnetregistry.azurecr.io
USERNAME=sensrnet
# image name
IMAGE=masternode

VERSION=$(node -pe "require('./package.json').version")

# ensure we're logged on at the registry
# az acr login --name sensrnetregistry

# run build
./scripts/build-masternode.sh

# tag it
docker tag $REGISTRY/$USERNAME/$IMAGE:latest $REGISTRY/$USERNAME/$IMAGE:$VERSION

# push it
# docker push $REGISTRY/$USERNAME/$IMAGE:latest
# docker push $REGISTRY/$USERNAME/$IMAGE:$VERSION

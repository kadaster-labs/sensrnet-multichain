#!/bin/bash

set -ex

REGISTRY=sensrnetregistry.azurecr.io
USERNAME=sensrnet
# image name
IMAGE=node

docker build -t $REGISTRY/$USERNAME/$IMAGE:latest node/

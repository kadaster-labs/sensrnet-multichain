#!/bin/bash

set -ex

REGISTRY=sensrnetregistry.azurecr.io
USERNAME=sensrnet
# image name
IMAGE=explorer

docker build -t $REGISTRY/$USERNAME/$IMAGE:latest explorer/

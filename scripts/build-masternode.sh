#!/bin/bash

set -ex

REGISTRY=sensrnetregistry.azurecr.io
USERNAME=sensrnet
# image name
IMAGE=masternode

docker build -t $REGISTRY/$USERNAME/$IMAGE:latest master/

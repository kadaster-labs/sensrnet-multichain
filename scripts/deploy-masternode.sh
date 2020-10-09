#!/bin/bash

set -ex

env=local
while getopts e: flag
do
    case "${flag}" in
        e) env=${OPTARG};;
    esac
done

declare -A env_hosts=(
  ["local"]="localhost"
  ["pls"]="viewer-sensrnet.etc.test.cloud.kadaster.nl/"
)

if [[ ! -v env_hosts["${env}"] ]]; then
  echo "Cannot deploy, unknown env" ${env}
  exit 1
fi

kustomize build deployment/masternode           | \
sed s/\\\${INGRESS_HOST}/${env_hosts[$env]}/g - | \
kubectl apply -f -

#!/bin/bash

if [[ $1 == "" ]]; then
    echo "Usage: build.sh <image version>"
    exit
fi

VERSION=$1

echo "Building container"
pushd ../
podman build -t registry.sotolitolabs.com/electorjudicial:${VERSION} -f containers/Containerfile .
popd

podman tag registry.sotolitolabs.com/electorjudicial:${VERSION} registry.sotolitolabs.com/electorjudicial:latest


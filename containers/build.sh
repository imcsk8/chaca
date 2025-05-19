#!/bin/bash

if [[ $1 == "" ]]; then
    echo "Usage: build.sh <image version>"
    exit 1
fi

VERSION=$1
IMAGE_NAME="registry.sotolitolabs.com:5000/electorjudicial"

pushd ../
echo "Building chaca chaca"
make release

echo "Building container"
podman build -t ${IMAGE_NAME}:${VERSION} -f containers/Containerfile .
popd

echo "Tagging Latest"
podman tag ${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:latest

echo "Pushing to remote registry"
podman push --tls-verify=false ${IMAGE_NAME}:${VERSION}
podman push --tls-verify=false ${IMAGE_NAME}:latest

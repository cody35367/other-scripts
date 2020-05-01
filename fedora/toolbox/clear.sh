#!/bin/bash

IMAGE_NAMES=("custom-toolbox" "fedora-toolbox")
CONTAINER_NAME_PREFIX="ct"

podman stop $(podman ps -a --format="{{.Names}}" --filter="name=${CONTAINER_NAME_PREFIX}[0-9]+" | sort)
podman rm $(podman ps -a --format="{{.Names}}" --filter="name=${CONTAINER_NAME_PREFIX}[0-9]+" | sort)
for image_name in ${IMAGE_NAMES[@]}; do
    podman rmi -f $(podman images -aq --filter="reference=${image_name}")
done
podman rmi $(podman images -aq --filter="dangling=true")
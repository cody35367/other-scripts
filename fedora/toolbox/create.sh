#!/bin/bash

IMAGE_NAME="custom-toolbox"
CONTAINER_NAME_PREFIX="ct"
# Pad zeros so that we support up to 999 to conatiners.
PRINTF_FORMAT="%03d"
MAX_CONTAINER_NUMBER=999

LAST_CONTAINER=$(podman ps -a --format="{{.Names}}" --filter="name=${CONTAINER_NAME_PREFIX}[0-9]+" | sort | tail -n 1)
CONTAINER_NAME=""
if [[ -n ${LAST_CONTAINER} ]]; then
    CONTAINER_NUMBER=$(echo "${LAST_CONTAINER}" | grep -oP '[0-9]+')
    ((CONTAINER_NUMBER++))
    if [[ ${CONTAINER_NUMBER} -gt ${MAX_CONTAINER_NUMBER} ]]; then
        echo "Container number \"${CONTAINER_NUMBER}\" is not supported."
        exit 1
    fi
    CONTAINER_NAME="${CONTAINER_NAME_PREFIX}$(printf ${PRINTF_FORMAT} ${CONTAINER_NUMBER})"
else
    CONTAINER_NAME="${CONTAINER_NAME_PREFIX}$(printf ${PRINTF_FORMAT} 1)"
fi

cd "$(dirname "$0")"
buildah bud \
    --pull \
    --no-cache \
    -t ${IMAGE_NAME} \
    .
echo "Creating ${CONTAINER_NAME} from ${IMAGE_NAME}..."
toolbox create \
    --container ${CONTAINER_NAME} \
    --image ${IMAGE_NAME}

echo "Run \"toolbox enter\" if only running container or \"toolbox enter -c ${CONTAINER_NAME}\" if multiple containers are running."

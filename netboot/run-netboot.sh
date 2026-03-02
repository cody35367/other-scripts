#!/bin/bash
set -e
mkdir -p config assets
docker run \
    --rm \
    --name=netbootxyz \
    -e PUID=$(id -u)                   `# optional, UserID for volume permissions` \
    -e PGID=$(id -g)                   `# optional, GroupID for volume permissions` \
    -e NGINX_PORT=80                   `# optional` \
    -e WEB_APP_PORT=3000               `# optional` \
    -p 3000:3000                       `# sets web configuration interface port, destination should match ${WEB_APP_PORT} variable above.` \
    -p 69:69/udp                       `# sets tftp port` \
    -p 8080:80                         `# optional, destination should match ${NGINX_PORT} variable above.` \
    -v $PWD/config:/config             `# optional` \
    -v $PWD/assets:/assets             `# optional` \
    ghcr.io/netbootxyz/netbootxyz

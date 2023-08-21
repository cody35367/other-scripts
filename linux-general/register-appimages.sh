#!/bin/bash

mkdir -vp ~/Applications

for APP_IMAGE in ~/Applications/*.AppImage; do
    chmod -c u+x ${APP_IMAGE}
    app_name=$(basename ${APP_IMAGE} | grep -oP '^[a-zA-Z]+')
    "$(dirname "$0")/../gnome/gen_desktop_file.py" "${APP_IMAGE}" ~/.local/share/applications/${app_name}.desktop
done
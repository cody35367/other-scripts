#!/bin/bash
SET_PRIMARY_COLOR="#000000"
SET_SECONDARY_COLOR="#000000"
SET_COLOR_SHADING_TYPE="solid"
SET_PICTURE_URI=""

gsettings set org.gnome.desktop.background primary-color "${SET_PRIMARY_COLOR}"
gsettings set org.gnome.desktop.background secondary-color "${SET_SECONDARY_COLOR}"
gsettings set org.gnome.desktop.background color-shading-type "${SET_COLOR_SHADING_TYPE}"
gsettings set org.gnome.desktop.background picture-uri "${SET_PICTURE_URI}"

gsettings set org.gnome.desktop.screensaver primary-color "${SET_PRIMARY_COLOR}"
gsettings set org.gnome.desktop.screensaver secondary-color "${SET_SECONDARY_COLOR}"
gsettings set org.gnome.desktop.screensaver color-shading-type "${SET_COLOR_SHADING_TYPE}"
gsettings set org.gnome.desktop.screensaver picture-uri "${SET_PICTURE_URI}"
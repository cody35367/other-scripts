#!/bin/bash

# This is only really needed on X11 because on Wayland most trackpads these days work with the gestures.
# When I made this on the fedora 36 beta not all the nvidia issues were resolved (multi-monitor support issues)

# This is start and run fusuma ideally to run as a background startup task.
# See https://github.com/iberianpig/fusuma

# Install on fedora
#   sudo dnf install libinput-utils ruby xdotool
#   sudo gem install fusuma
#   mkdir -p ~/.config/fusuma
#   vim ~/.config/fusuma/config.yml
#   sudo gpasswd -a $USER input
#   newgrp input

# Example config
# swipe:
#   3:
#     up:
#       command: "xdotool key super" # Activity
#     down:
#       command: "xdotool key super" # Activity
#     left:
#       command: "xdotool key ctrl+alt+Left" # Switch to next workspace
#     right:
#       command: "xdotool key ctrl+alt+Right" # Switch to previous workspace

fusuma
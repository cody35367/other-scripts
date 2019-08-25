#!/bin/bash
BRIGHTNESS_PERCENT=20
SLEEP_TIME=10
sleep ${SLEEP_TIME}
gdbus call --session --dest org.gnome.SettingsDaemon.Power --object-path /org/gnome/SettingsDaemon/Power --method org.freedesktop.DBus.Properties.Set org.gnome.SettingsDaemon.Power.Screen Brightness "<int32 ${BRIGHTNESS_PERCENT}>"
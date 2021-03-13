#!/bin/bash

id=""
master_id=""
enabled_line=""
disabled_line=""

xinput_output=$(xinput list)

enabled_line=$(echo "${xinput_output}" | grep "↳ AT Translated Set 2 keyboard")
disabled_line=$(echo "${xinput_output}" | grep "∼ AT Translated Set 2 keyboard")

if [[ -n ${enabled_line} ]]; then
    id=$(echo "${enabled_line}" | grep -oP "(?<=id=)[0-9]+")
    xinput float ${id}
elif [[ -n ${disabled_line} ]]; then
    id=$(echo "${disabled_line}" | grep -oP "(?<=id=)[0-9]+")
    master_id=$(echo "${xinput_output}" | grep -oP "\[slave\s+keyboard\s+\([0-9]+\)\]" | tail -n 1 | grep -oP "(?<=\()[0-9]+")
    xinput reattach ${id} ${master_id}
fi
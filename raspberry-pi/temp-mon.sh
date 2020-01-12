#!/bin/bash

temp_mon(){
    cpuTemp0=$(cat /sys/class/thermal/thermal_zone0/temp)
    cpuTemp1=$((${cpuTemp0}/1000))
    cpuTemp2=$((${cpuTemp0}/100))
    cpuTempM=$((${cpuTemp2} %${cpuTemp1}))
    echo CPU temp"="${cpuTemp1}"."${cpuTempM}"'C"
    echo GPU $(/opt/vc/bin/vcgencmd measure_temp)
}
export -f temp_mon

if [[ -n ${1} && ${#} == 1 ]]; then
    watch -d -n ${1} -x bash -c temp_mon
else
    temp_mon
fi
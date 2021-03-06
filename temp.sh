#!/bin/bash
# Script: my-pi-temp.sh
# Purpose: Display the ARM CPU and GPU  temperature of Raspberry Pi 2/3
# Author: Vivek Gite <www.cyberciti.biz> under GPL v2.x+
# -------------------------------------------------------
cpu=`bc <<< "scale=4; $(</sys/class/thermal/thermal_zone0/temp)/1000"`
gpu=$(/opt/vc/bin/vcgencmd measure_temp)
echo "$(date) @ $(hostname)"
echo "-------------------------------------------"
echo "GPU => ${gpu:5}"
echo "CPU => `printf "%.1f" $cpu`'C"

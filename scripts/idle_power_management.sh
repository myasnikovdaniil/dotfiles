#!/bin/bash

if [ $(cat /sys/class/power_supply/AC/online) -eq "0" ]
then
    #notify-send "supend-then-hibernate"
    systemctl suspend-then-hibernate
else
    #notify-send "supend"
    systemctl suspend
fi

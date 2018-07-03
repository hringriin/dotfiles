#!/bin/bash
# i3_batt - will throw pop ups , if battery power low

tmpFile=/tmp/battinfo

acpi -b > $tmpFile

if [[ !(-e $tmpFile) ]] ; then
    echo "Temp files not found!"
    exit 1
fi

echo $(env | grep DBUS)

batt0=$(cat $tmpFile | grep 'Battery 0')
batt1=$(cat $tmpFile | grep 'Battery 1')

if [[ $(echo $batt0 | grep 'Discharging' | cut -f 5 -d " ") < 00:10:00 ]] ; then
    DISPLAY=:0.0 /usr/bin/notify-send "Battery 0 LOW!" "$batt0" --icon=battery-low
elif [[ $(echo $batt0 | grep 'Discharging' | cut -f 5 -d " ") < 00:30:00 ]] ; then
    DISPLAY=:0.0 /usr/bin/notify-send "Battery 0 CRITICAL!" "batt0" --icon=battery-caution
fi

if [[ $(echo $batt1 | grep 'Discharging' | cut -f 5 -d " ") < 00:10:00 ]] ; then
    DISPLAY=:0.0 /usr/bin/notify-send "Battery 1 LOW!" "$batt1" --icon=battery-low
elif [[ $(echo $batt1 | grep 'Discharging' | cut -f 5 -d " ") < 00:30:00 ]] ; then
    DISPLAY=:0.0 /usr/bin/notify-send "Battery 1 CRITICAL!" "$batt1" --icon=battery-caution
fi

rm -rf $tmpFile

#if [[ `echo $BatInfo | grep 'Battery 0' && `echo $BatInfo | cut -f 5 -d " "` < 00:15:00 ]] ; then
#    DISPLAY=:0.0 /usr/bin/notify-send "Battery 0 LOW!" "$BatInfo"
#else
#    DISPLAY=:0.0 /usr/bin/notify-send "works!" "$BatInfo"
#fi
#
#if [[ `echo $BatInfo | grep 'Battery 1' && `echo $BatInfo | cut -f 5 -d " "` < 00:15:00 ]] ; then
#    DISPLAY=:0.0 /usr/bin/notify-send "Battery 1 LOW!" "$BatInfo"
#else
#    DISPLAY=:0.0 /usr/bin/notify-send "works!" "$BatInfo"
#fi

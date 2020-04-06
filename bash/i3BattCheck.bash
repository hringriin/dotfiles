#!/bin/bash
# i3_batt - will throw pop ups , if battery power low

tmpFile=/tmp/battinfo

# these files will assure, each message (crit/warning) is only issued once
warning0=/tmp/battwarning0
critical0=/tmp/battcritical0

acpi -b > $tmpFile

if [[ !(-e $tmpFile) ]] ; then
    echo "Temp files not found\!"
    exit 1
fi

batt0=$(cat $tmpFile | grep 'Battery 0')
batt1=$(cat $tmpFile | grep 'Battery 1')

# some regex foo to get the precise battery level as integer
function getBatLevel()
{
    echo ${1} | cut -d ',' -f 2 | sed -e 's/  *//g' | tr -d '%'
}

function checkBatt()
{
    # if the battery is not available (plugged in / attached), nothing will happen
    if [[ $1 != "" ]] ; then

        # Check, if the battery is discharching.
        if [[ $(echo $1 | cut -d ',' -f 1) == *"Discharging" ]] ; then
        #if [[ $(echo $1 | cut -d ',' -f 1) == *"Charging" ]] ; then

            # Below 7 percent (According to `acpi -b`), get on my nerves to
            # shutdown or hybernate this thing.
            if [[ $(getBatLevel "$1") -lt 8 ]] ; then
                DISPLAY=:0.0 i3-msg fullscreen disable
                #DISPLAY=:0.0 notify-send --icon=battery-caution "Battery 0 is CRITICAL! Shutdown IMMINENT!" "$1"
                DISPLAY=:0.0 i3-nagbar -t error -m "Battery 0 is CRITICAL! Shutdown IMMINENT! $1" -f "pango:Hack 18"

            # Check, if the battery level is below 12 percent (According to
            # `acpi -b`). If true, issue notify-send and i3-nagbar to make the
            # user aware of the critical battery level.
            elif [[ $(getBatLevel "$1") -lt 11 ]] ; then

                # only issue warning, if the warning file is not present
                if [[ ! -e ${critical0} ]] ; then
                    touch ${critical0}
                    DISPLAY=:0.0 i3-msg fullscreen disable
                    #DISPLAY=:0.0 notify-send --icon=battery-caution "Battery 0 is CRITICAL!" "$1"
                    DISPLAY=:0.0 i3-nagbar -t error -m "Battery 0 is CRITICAL! $1" -f "pango:Hack 14"
                fi

            # Check, if the battery level is below 25 percent (According to
            # `acpi -b`). If true, issue notify-send to make the user aware of
            # the low battery level.
            elif [[ $(getBatLevel "$1") -lt 25 ]] ; then

                # only issue warning, if the critical file is not present
                if [[ ! -e ${warning0} ]] ; then
                    touch ${warning0}
                    DISPLAY=:0.0 i3-msg fullscreen disable
                    #DISPLAY=:0.0 notify-send --icon=battery-low "Battery 0 is low!" "$1"
                    DISPLAY=:0.0 i3-nagbar -t warning -m "Battery 0 is low! $1" -f "pango:Hack 10"
                fi
            fi
        # if the script is issued while the batteries were charging, remove the
        # warning/critical files to issue warning/critical messages again.
        elif [[ $(echo $1 | cut -d ',' -f 1) == *"Charging" ]] ; then
            rm -f ${warning0}
            rm -f ${critical0}
        fi
    fi
}

checkBatt "${batt0}"
#checkBatt "${batt1}"
rm -rf $tmpFile
exit 0

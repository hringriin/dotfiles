#!/bin/bash
# setBrightness - sets the brightness of the LVDS-1 dislay

current=$(xrandr --verbose | grep -i brightness | cut -f2 -d ' ' | head -n1 | cut -f2 -d '.')

function cleanup()
{
    unset current
}

function usage()
{
    echo "Usage:"
    echo -e "\t./setBrightness Inc\t\t# Increments brightness by 5%"
    echo -e "\t./setBrightness Dec\t\t# Decrements brightness by 5%"
    echo -e "\t./setBrightness help\t\t# This help"
}

function inc()
{
    local var=$(($current + 5))

    if [[ ${var} -lt 99 ]] ; then
        xrandr --output LVDS1 --brightness 0.${var}
    fi

    unset var
}

function dec()
{
    local var=$(($current - 5))

    if [[ ${var} -gt 5 ]] ; then
        xrandr --output LVDS1 --brightness 0.${var}
    fi

    unset var
}

function main()
{
    if [[ $1 == "" ]] ; then
        exit 1
    elif [[ $1 == "help" ]] ; then
        usage
    fi

    if [[ $1 == "Inc" ]] ; then
        inc
    elif [[ $1 == "Dec" ]] ; then
        dec
    fi

    cleanup
}

main $1

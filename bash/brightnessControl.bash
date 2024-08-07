#!/bin/bash
# brightness control
# this script will display the newly set display brightness via dunst

imagePath="${HOME}/.icons/gruvbox-soft/status"
image=
level=
step=

# choose the image for the notifier
function setImage()
{
    setLevel

    if [[ ${level} -lt 10 ]] ; then
        image="${imagePath}/display-brightness-low-symbolic.png"
    elif [[ ${level} -gt 45 ]] ; then
        image="${imagePath}/display-brightness-high-symbolic.png"
    elif [[ ${level} -ge 10 ]] ; then
        image="${imagePath}/display-brightness-medium-symbolic.png"
    fi

}

function setLevel()
{
    tmp=$(xbacklight -get)
    level=${tmp%.*}
    #level=$(printf "%.0f\n" $(xbacklight -get))
}

function setStep()
{
    setLevel

    if [[ ${level} -lt 30 ]] ; then
        step=2
    elif [[ ${level} -lt 50 ]] ; then
        step=5
    elif [[ ${level} -ge 50 ]] ; then
        step=10
    fi
}

function notify()
{
    setImage
    setLevel
    notify-send "Brightness" "Level: ${level}" -t 750 -u low -i ${image}
}

# increase backlight
function raise()
{
    setStep

    if [[ ${level} -ge 100 ]] ; then
        exit 2
    fi

    #printf "Calculation:\n\tLevel:\t%.0f\n\tStep:\t%.0f\n\n\tResult:\t%.0f\n" ${level} ${step} $((${level} + ${step}))
    inc=$((${level} + ${step}))
    xbacklight -set ${inc} -time 0
    notify
}

# decrease backlight
function lower()
{
    setStep

    if [[ ${level} -le 0 ]] ; then
        exit 3
    fi

    #printf "Calculation:\n\tLevel:\t%.0f\n\tStep:\t%.0f\n\n\tResult:\t%.0f\n" ${level} ${step} $((${level} - ${step}))
    dec=$((${level} - ${step}))
    xbacklight -set ${dec} -time 200
    notify
}

# reset backlight to 10
function reset()
{
    xbacklight -set 10 -time 1000
    notify
}

function movie()
{
    xbacklight -set 40 -time 1000
    notify
}

main ()
{
    if [[ $1 == "raise" ]] ; then
        raise
    elif [[ $1 == "lower" ]] ; then
        lower
    elif [[ $1 == "reset" ]] ; then
        reset
    elif [[ $1 == "movie" ]] ; then
        movie
    fi
}

if [[ $@ >/dev/null ]] ; then
    main $1
    exit 0
else
    exit 1
fi

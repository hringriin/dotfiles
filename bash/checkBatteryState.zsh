#!/bin/zsh
# checkBatteryState

autoload -U colors && colors

# Paths
BAT0="/sys/class/power_supply/BAT0/capacity"
BAT1="/sys/class/power_supply/BAT1/capacity"
AC="/sys/class/power_supply/AC/online"

# Values
if [ -f $BAT0 ] ; then
        BAT0VAL=`cat $BAT0`
fi

if [ -f $BAT1 ] ; then
        BAT1VAL=`cat $BAT1`
fi

if [ -f $AC ] ; then
    if [ `cat $AC` -eq 1 ] ; then
        #echo "$fg_bold[green]AC$reset_color"
        echo "%B%F{green}AC%f%b"
    else
        #echo "$fg_bold[red]BAT$reset_color"
        echo "%B%F{red}BAT%f%b"
    fi
else
    #echo "$fg_bold[yellow]N/A$reset_color"
    echo "%B%F{yellow}N/A%f%b"
fi

# Handling BAT 0 (Internal)

if [ -f $BAT0 ] ; then
    if [ $BAT0VAL -ge 100 ] ; then
        #echo -e "$fg_bold[green]FULL$reset_color"
        echo -e "%B%F{green}FULL%f%b"
    fi

    if [ $BAT0VAL -lt 100 ] ; then
        if [ $BAT0VAL -gt 50 ] ; then
            #echo -e "$fg_bold[green]$BAT0VAL %$reset_color"
            echo -e "%B%F{green}$BAT0VAL%%%f%b"
        fi
    fi

    if [ $BAT0VAL -le 50 ] ; then
        if [ $BAT0VAL -gt 20 ] ; then
            #echo -e "$fg_bold[yellow]$BAT0VAL %$reset_color"
            echo -e "%B%F{yellow}$BAT0VAL%%%f%b"
        fi
    fi

    if [ $BAT0VAL -le 20 ] ; then
        if [ $BAT0VAL -gt 0 ] ; then
            #echo -e "$fg_bold[red]$BAT0VAL %$reset_color"
            echo -e "%B%F{red}$BAT0VAL%%%f%b"
        fi
    fi

    if [ $BAT0VAL -le 0 ] ; then
        #echo -e "$fg_bold[red]!! EMPTY !!$reset_color"
        echo -e "%B%F{red}!! EMPTY !!%f%b"
    fi
else
    echo "$fg_bold[yellow]N/A $reset_color"
fi

# Handling Bat 1 (External -- Slice)

if [ -f $BAT1 ] ; then
    if [ $BAT1VAL -ge 100 ] ; then
        #echo -e "$fg_bold[green]FULL$reset_color"
        echo -e "%B%F{green}FULL%f%b"
    fi

    if [ $BAT1VAL -lt 100 ] ; then
        if [ $BAT1VAL -gt 50 ] ; then
            #echo -e "$fg_bold[green]$BAT1VAL %$reset_color"
            echo -e "%B%F{green}$BAT1VAL%%%f%b"
        fi
    fi

    if [ $BAT1VAL -le 50 ] ; then
        if [ $BAT1VAL -gt 20 ] ; then
            #echo -e "$fg_bold[yellow]$BAT1VAL %$reset_color"
            echo -e "%B%F{yellow}$BAT1VAL%%%f%b"
        fi
    fi

    if [ $BAT1VAL -le 20 ] ; then
        if [ $BAT1VAL -gt 0 ] ; then
            #echo -e "$fg_bold[red]$BAT1VAL %$reset_color"
            echo -e "%B%F{red}$BAT1VAL%%%f%b"
        fi
    fi

    if [ $BAT1VAL -le 0 ] ; then
        #echo -e "$fg_bold[red]!! EMPTY !!$reset_color"
        echo -e "%B%F{red}!! EMPTY !!%f%b"
    fi
else
    #echo "$fg_bold[yellow]N/A$reset_color"
    echo "%B%F{yellow}N/A%f%b"
fi

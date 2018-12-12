#!/bin/zsh
# vim: ft=sh
# control volume for i3wm

# configuration
outDevices=()                                                   # list of output devices (speakers)
inDevices=()                                                    # list of input devices (microphones)
outDevice=''                                                    # the default speaker device for this script
inDevice=''                                                     # the defult microphone device for this script
devPath=${HOME}/.local/share/pulseaudiodevicechooser            # path to config folder
outDevFile=outdev                                               # config file for output device (name)
inDevFile=indev                                                 # config file for input device (name)

# if the configuration files and directories do not exist, create them
if [[ -d ${devPath} ]] ; then
    outDevice=$(cat ${devPath}/${outDevFile})
    inDevice=$(cat ${devPath}/${inDevFile})
else
    mkdir -p ${devPath}
    touch ${devPath}/${outDevFile}
    touch ${devPath}/${inDevFile}
fi

# prints the help and information message to the console
printHelp ()
{
    echo -e "\ncontrolVolume (v0.1) -- by Joschka Köster"
    echo -e "\nSmall script to handle PulseAudio devices, designed for i3wm."
    echo -e "\n\nUsage:"
    echo -e "\tcontrolVolume [ option [<vol>] ]"
    echo -e "\n\tOptions:"
    echo -e "\n\t\t- oup              increase volume"
    echo -e "\t\t- getvol           print volume"
    echo -e "\t\t- getmic           print mic volume"
    echo -e "\t\t- oupN             increase volume by <vol>"
    echo -e "\t\t- odn              decrease volume"
    echo -e "\t\t- odnN             increase volume by <vol>"
    echo -e "\t\t- iup              decrease input"
    echo -e "\t\t- iupN             increase input by <vol>"
    echo -e "\t\t- idn              decrease input"
    echo -e "\t\t- idnN             increase input by <vol>"
    echo -e "\t\t- sp               toggles speaker mute"
    echo -e "\t\t- mic              toggles microphone mute"
    echo -e "\t\t- setOutDev        set Output Device"
    echo -e "\t\t- setInDev         set Input Device"
    echo -e "\t\t- help             display this message"
    echo -e "\n\n\tExamples:"
    echo -e "\n\t\tcontrolVolume iup         # increses volume by 5 on device 1"
    echo -e "\t\tcontrolVolume iupN 20     # increses volume by 20 on device 2"
}

# Through a bunch of piping get a list of output devices
# and put them into the ${outDevices} array.
# After that choose one from that list to be the new default
# output device.
# If the input is not correct, start over.
chooseOutDevice ()
{
    int=1

    echo "Choose OUTPUT device number:"
    while [ ! -z $(pactl list sinks | grep Name | cut -d ':' -f 2 | cut -d ' ' -f 2 | sed -n ${int}p) ]
    do
        outDevices+=$(pactl list sinks | grep Name | cut -d ':' -f 2 | cut -d ' ' -f 2 | sed -n ${int}p)
        echo "Device Number: \t[${int}]\tdevice: $(pactl list sinks | grep Name | cut -d ':' -f 2 | cut -d ' ' -f 2 | sed -n ${int}p)"
        int=$((int+1))
    done
    echo "Abort with 'q'"
    read -r devnum

    if [[ ${devnum} == "q" || ${devnum} == "Q" ]] ; then
        exit 1
    elif [[ ${devnum} -gt 0 && ${devnum} -lt 20 ]] ; then
        pactl set-default-sink ${outDevices[${devnum}]}
        echo ${outDevices[${devnum}]} > ${devPath}/${outDevFile}
    else
        echo "wrong input!"
        chooseOutDevice
    fi

    unset int
    unset devnum
}

# Through a bunch of piping get a list of input devices
# and put them into the ${inDevices} array.
# After that choose one from that list to be the new default
# input device.
# If the input is not correct, start over.
chooseInDevice ()
{
    int=1

    echo "Choose INPUT device number:"
    while [ ! -z $(pactl list sources | grep Name | grep -vi 'monitor' | cut -d ':' -f 2 | cut -d ' ' -f 2 | sed -n ${int}p) ]
    do
        inDevices+=$(pactl list sources | grep Name | grep -vi 'monitor' | cut -d ':' -f 2 | cut -d ' ' -f 2 | sed -n ${int}p)
        echo "Device Number: \t[${int}]\tdevice: $(pactl list sources | grep Name | grep -vi 'monitor' | cut -d ':' -f 2 | cut -d ' ' -f 2 | sed -n ${int}p)"
        int=$((int+1))
    done
    echo "Abort with 'q'"
    read -r devnum

    if [[ ${devnum} == "q" || ${devnum} == "Q" ]] ; then
        exit 1
    elif [[ ${devnum} -gt 0 && ${devnum} -lt 20 ]] ; then
        echo ${inDevices[${devnum}]} > ${devPath}/${inDevFile}
    else
        echo "wrong input!"
        chooseInDevice
    fi
}

# turn volume up for default speaker
volUp ()
{
    #if [[ $1 -gt 0 && $($1+$(pactl list sinks | grep ${outDevice} | grep -v 'Base Volume' | grep Volume | cut -d '/' -f 4 | sed -e 's/ //g')) -le 120 ]] ; then
    if [[ $(getVol) -eq 100 ]] ; then
        exit 0
    fi

    if [[ $1 -gt 0 && $1 -le 25 ]] ; then
        if [[ $(echo $1 + $(getVol) | bc) -lt 100 ]] ; then
            pactl set-sink-volume ${outDevice} +$1%
            notifyVolume
        else
            pactl set-sink-volume ${outDevice} 100%
            notifyVolume
        fi
    else
        if [[ $(echo 5 + $(getVol) | bc) -lt 100 ]] ; then
            pactl set-sink-volume ${outDevice} +5%
            notifyVolume
        else
            pactl set-sink-volume ${outDevice} 100%
            notifyVolume
        fi
    fi
}

# turn volume down for default speaker
volDn ()
{
    #if [[ $1 -gt 0 && $($1+$(pactl list sinks | grep ${outDevice} | grep -v 'Base Volume' | grep Volume | cut -d '/' -f 4 | sed -e 's/ //g')) -ge 0 ]] ; then
    if [[ $(getVol) -eq 0 ]] ; then
        exit 0
    fi

    if [[ $1 -gt 0 && $1 -le 25 ]] ; then
        pactl set-sink-volume ${outDevice} -$1%
        notifyVolume
    else
        pactl set-sink-volume ${outDevice} -5%
        notifyVolume
    fi
}

# pokes the dunst notification daemon to display the current volume after
# raising/lowering the volume of the default microphone
notifyMicVolume ()
{
    image=
    if [[ $(isMicMute) == "yes" ]] ; then
        image=microphone-sensitivity-muted
    elif [[ $(isMicMute) == "no" ]] ; then
        if [[ $(getMicVol) -le 15 ]] ; then
            image=microphone-sensitivity-low
        elif [[ $(getMicVol) -le 50 ]] ; then
            image=microphone-sensitivity-medium
        else
            image=microphone-sensitivity-high
        fi
    else
        image=info
    fi

    notify-send "Mic-Volume" "$(getMicVol)" -t 500 -u low -i ${image}
    unset image
}

# pokes the dunst notification daemon to display the current volume after
# raising/lowering the volume of the default speaker
notifyVolume ()
{
    image=
    if [[ $(isVolMute) == "yes" ]] ; then
        image=audio-volume-muted
    elif [[ $(isVolMute) == "no" ]] ; then
        if [[ $(getVol) -le 15 ]] ; then
            image=audio-volume-low
        elif [[ $(getVol) -le 50 ]] ; then
            image=audio-volume-medium
        else
            image=audio-volume-high
        fi
    else
        image=info
    fi

    notify-send "Volume" "$(getVol)" -t 500 -u low -i ${image}
    unset image
}

# turn volume up for input device
inUp ()
{
    if [[ $(getMicVol) -eq 100 ]] ; then
        exit 0
    fi

    if [[ $1 -gt 0 && $1 -le 25 ]] ; then
        pactl set-source-volume ${inDevice} +$1%
        notifyMicVolume
    else
        pactl set-source-volume ${inDevice} +5%
        notifyMicVolume
    fi
}

# turn volume down for input device
inDn ()
{
    if [[ $(getMicVol) -eq 0 ]] ; then
        exit 0
    fi

    if [[ $1 -gt 0 && $1 -le 25 ]] ; then
        pactl set-source-volume ${inDevice} -$1%
        notifyMicVolume
    else
        pactl set-source-volume ${inDevice} -5%
        notifyMicVolume
    fi
}

# mute output device
muteSpeaker ()
{
    pactl set-sink-mute ${outDevice} toggle
    notifyVolume
}

# mute input device
muteMic ()
{
    pactl set-source-mute ${inDevice} toggle
    notifyMicVolume
}

# returns "yes" or "no", depending on whether the default speaker is muted or not
isVolMute ()
{
    echo $(pactl list sinks | grep "Name: $(cat ${devPath}/${outDevFile})" -A 6 | tail -n 1 | awk '{print $2}')
}

# returns "yes" or "no", depending on whether the default mic is muted or not
isMicMute ()
{
    echo $(pactl list | grep "Name: $(cat ${devPath}/${inDevFile})" -A 6 | tail -n 1 | awk '{print $2}' | tr -d '%')
}

# returns volume of default microphone
getMicVol ()
{
    echo $(pactl list | grep "Name: $(cat ${devPath}/${inDevFile})" -A 7 | tail -n 1 | awk '{print $5}' | tr -d '%')
}

# returns volume of default speaker
getVol ()
{
    echo $(pactl list sinks | grep "Name: $(cat ${devPath}/${outDevFile})" -A 7 | tail -n 1 | awk '{print $5}' | tr -d '%')
}

# main function, choosing what to do, evaluating the input parameter
main ()
{
    if [[ $1 == "help" || $1 == "" ]] ; then
        printHelp
        exit 0
    elif [[ $1 == "setInDev" ]] ; then
        chooseInDevice
        exit 0
    elif [[ $1 == "setOutDev" ]] ; then
        chooseOutDevice
        exit 0
    fi

    if [[ ${outDevice} == "" ]] ; then
        chooseOutDevice
    fi

    if [[ ${inDevice} == "" ]] ; then
        chooseInDevice
    fi

    if [[ $1 == "oup" ]] ; then
        volUp $2
    elif [[ $1 == "odn" ]] ; then
        volDn $2
    elif [[ $1 == "iup" ]] ; then
        inUp $2
    elif [[ $1 == "idn" ]] ; then
        inDn $2
    elif [[ $1 == "sp" ]] ; then
        muteSpeaker
    elif [[ $1 == "mic" ]] ; then
        muteMic
    elif [[ $1 == "getvol" ]] ; then
        getVol
    elif [[ $1 == "getmic" ]] ; then
        getMicVol
    else
        echo -e "\nUnknown parameters. Please refer to the help message with 'controlVolume help'\n"
        printHelp
        exit 0
    fi
}

main $1 $2
YOUR_SIGNAL=12
pkill -RTMIN+${YOUR_SIGNAL} i3blocks
exit 0

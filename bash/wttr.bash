#!/bin/bash
# wttr.in

debugWTTR=false
language=
location=
units=
wttrdisplay=

#while getopts ":ad:D:f:hHiILs:t:Tw:" opt ; do
while getopts ":012cdhl:L:m:M:nqQu:" opt ; do
    case $opt in
        0)
            #   ?0                  current day weather
            wttrdisplay+="&0"
            ;;
        1)
            #   ?1                  current day + next day
            wttrdisplay+="&1"
            ;;
        2)
            #   ?2                  current day + next two days
            wttrdisplay+="&2"
            ;;
        c)
            #   ?T                  switch terminal sequences off (no colors)
            wttrdisplay+="&T"
            ;;
        d)
            #debug
            debugWTTR=true
            ;;
        h)
            # help
            ;;
        l)
            # (special) location (eiffel+tower, moon, moon@2016-10-25),
            # also unicode name of any location or city in any language
            location="$OPTARG"
            ;;
        L)
            # language
            #   lang={}
            #
            # supported language
            #   de fr id it nb ru
            language="?lang=\"$OPTARG\""
            ;;
        m)
            #   ?m                  metric
            units+="&m"
            ;;
        M)
            #   ?M                  wind speed in m/s
            units+="&M"
            ;;
        n)
            #   ?n                  narrow version (only day and night)
            wttrdisplay+="&n"
            ;;
        q)
            # will not work for png
            #   ?q                  quiet version, no report text
            wttrdisplay+="&q"
            ;;
        Q)
            # will not work for png
            #   ?Q                  quiet version, no report, no city name
            wttrdisplay+="&Q"
            ;;
        u)
            #   ?u                  uscs
            units+="&u"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            ;;
    esac
done

if [[ ! ${language} >/dev/null ]] ; then
    language="?lang=en"
fi

wttrstr+=${location}
wttrstr+=${language}
wttrstr+=${units}
wttrstr+=${wttrdisplay}

curl wttr.in/${wttrstr}

if [[ ${debugWTTR} == true ]] ; then
    echo "Location:     ${location}"
    echo "language:     ${language}"
    echo "units:        ${units}"
    echo "wttrdisplay:  ${wttrdisplay}"
    echo ""
    echo ""
    echo "wttrstr:      ${wttrstr}"
fi

unset debugWTTR
unset language
unset location
unset PNopts
unset pnopts
unset pngopts
unset units
unset wttrdisplay
unset wttrstr

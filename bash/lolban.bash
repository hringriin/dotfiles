#!/bin/bash

defaultFont=pagga.tlf
defaultDir=/usr/share/figlet
defaultDuration=12
defaultSpeed=20
defaultWidth=80

while getopts ":ad:D:f:hHiILs:t:Tw:" opt ; do
    case $opt in
        a)
            animate=true
            ;;
        d)
            dir="$OPTARG"
            ;;
        D)
            duration="$OPTARG"
            ;;
        f)
            font="$OPTARG"
            ;;
        h)
            echo -e "Usage: ./lolban.bash [OPTION [ARGUMENT]] -t \"<your text>\""
            echo -e "Pukes your text in rainbow-style to your shell."

            echo -e "\nMandatory arguments:"
            echo -e "<Option>   <Argument>          <Description>"
            echo -e "  -t       \"<your text>\"       the text to display"

            echo -e "\nOptional arguments:"
            echo -e "<Option>   <Argument>          <Description>"
            echo -e "  -a                           Fade every line through an animation before printing the next one (default: no)"
            echo -e "  -d       <dir>               dir to the font (default: ${defaultDir})"
            echo -e "  -D       <duration>          duration of the animation (default: ${defaultDuration})"
            echo -e "  -f       <font-name>         the font to be used (default: ${defaultFont})"
            echo -e "  -h                           displays this help message"
            echo -e "  -H                           displays this help message while demonstrating what this programe does"
            echo -e "  -i                           inverts the background and foreground colors (default: no)"
            echo -e "  -I                           output irc (default: no)"
            echo -e "  -L                           output html (default: no)"
            echo -e "  -s       <speed>             speed (framerate, ie number of steps per second) of the animation (default: ${defaultSpeed})"
            echo -e "  -T                           widht of the text to terminal width (default: no)"
            echo -e "  -w       <width>             width of the text printed to the shell (default: ${defaultWidth})"

            exit 0
            ;;
        H)
            ./lolban.bash -T -f term.flf -t "$(./lolban.bash -h)"
            ;;
        i)
            invert=true
            ;;
        I)
            irc=true
            ;;
        L)
            html=true
            ;;
        s)
            speed="$OPTARG"
            ;;
        t)
            text="$OPTARG"
            ;;
        T)
            termWidth=true
            ;;
        w)
            width="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

if [[ ${dir} == "" || ! -d ${dir} ]] ; then
    dir="${defaultDir}"
fi

if [[ ${font} == "" ]] ; then
    font="${defaultFont}"
fi

if [[ ${duration} -lt 1 ]] ; then
    duration="${defaultDuration}"
fi

if [[ ${speed} -lt 1 ]] ; then
    speed="${defaultSpeed}"
fi

if [[ ${width} -lt 1 ]] ; then
    width="${defaultWidth}"
fi

# this looks creepy, but it works :-)
echo -e "${text}" | \
    toilet -f ${font} -w ${width} \
    $(if [[ ${termWidth} == true ]] ; then echo "--termwidth" ; fi) \
    $( if [[ ${irc} == true ]] ; then echo "--irc" ; fi) \
    $( if [[ ${html} == true ]] ; then echo "--html" ; fi) \
    $(if [[ ${dir} >/dev/null ]] ; then echo "-d ${dir}" ; fi) | \
    lolcat $(if [[ ${animate} == true ]] ; then echo "-a" ; fi) \
    $(if [[ ${invert} == true ]] ; then echo "-i" ; fi) \
    -s ${speed} -d ${duration}

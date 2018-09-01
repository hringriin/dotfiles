#!/bin/bash
# shutdown i3 or arch linux

i3exit="Exit i3"
shutdownc="Shutdown computer"
rebootc="Reboot computer"

case $(echo -e "${i3exit}\n${shutdownc}\n${rebootc}" | rofi -dmenu -markup-rows -i -p "What to do?") in
    ${i3exit})
        if [[ $(echo -e "No\nYes" | rofi -dmenu -markup-rows -i -p "Really ${i3exit}?") == "Yes" ]] ; then
            i3-msg exit
        fi
        ;;
    ${shutdownc})
        if [[ $(echo -e "No\nYes" | rofi -dmenu -markup-rows -i -p "Really ${shutdownc}?") == "Yes" ]] ; then
            shutdown -h now
        fi
        ;;
    ${rebootc})
        if [[ $(echo -e "No\nYes" | rofi -dmenu -markup-rows -i -p "Really ${rebootc}?") == "Yes" ]] ; then
            reboot -h now
        fi
        ;;
    "")
        ;;
    *)
        notify-send --icon=warning test "Unrecognized Command"
esac

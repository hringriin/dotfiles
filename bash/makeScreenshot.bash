#!/bin/bash
# makeScreenshot - takes screenshot for i3wm

scrDir="${HOME}/ownCloud/Documents/Screenshots"

if [[ ! -d ${scrDir} ]] ; then
    mkdir -p ${scrDir}
fi

scrot ~/ownCloud/Documents/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png
exit 0

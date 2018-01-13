#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="SET BRIGHTNESS"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    sudo ln -fsv ${repoPath}/xrandr/setBrightness.bash ${ulbin}/setBrightness
}

main
exit 0

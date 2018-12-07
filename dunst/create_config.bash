#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="dunst"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash
source INSTALL_ALL/yay.bash
source INSTALL_ALL/pacman.bash

main()
{
    if [[ ! ( -d ~/.config/dunst ) ]] ; then
        mkdir --mode=700 -p ~/.config/dunst
    fi
    ln -fsv ${repoPath}/dunst/dunstrc ~/.config/dunst/
}

main
exit 0

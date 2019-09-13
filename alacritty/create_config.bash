#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="alacritty"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash
source INSTALL_ALL/yay.bash
source INSTALL_ALL/pacman.bash

main()
{
    if [[ ! -d ${HOME}/.config/alacritty ]] ; then
        mkdir -p ${HOME}/.config/alacritty
    fi

    ln -vsf ${repoPath}/alacritty/alacritty.yml ${HOME}/.config/alacritty/alacritty.yml
}

main
exit 0

#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="neofetch"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash
source INSTALL_ALL/yay.bash
source INSTALL_ALL/pacman.bash

main()
{
    ln -sfv ${repoPath}/neofetch/config.conf ${HOME}/.config/neofetch/config.conf
}

main
exit 0

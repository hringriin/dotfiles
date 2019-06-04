#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="rofipassmenu"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash
source INSTALL_ALL/yay.bash
source INSTALL_ALL/pacman.bash

main()
{
    rm -rf ${HOME}/.password-store
    ln -sfv ${HOME}/ownCloud/Documents/pass ${HOME}/.password-store
}

main
exit 0

#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="mimeapps"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash
source INSTALL_ALL/yay.bash
source INSTALL_ALL/pacman.bash

main()
{
    ln -fsv ${repoPath}/mimeapps/mimeapps.list ${HOME}/.config/mimeapps.list
}

main
exit 0

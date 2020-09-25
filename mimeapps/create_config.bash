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
    #installation
    configuration
}

installation()
{
    if [[ $(check_installed ${prgname}) -eq 0 ]] ; then
        sudo pacman -S ${prgname}
    fi
}

configuration()
{
    if [[ $(check_symlink ~/.config/mimeapps.list) == "false" ]] ; then
        rm -f ~/.config/mimeapps.list
        ln -fsv ${repoPath}/mimeapps/mimeapps.list ${HOME}/.config/mimeapps.list
    fi
}

main
exit 0

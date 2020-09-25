#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="picom"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    installation
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
    if [[ $(check_symlink /etc/xdg/picom.conf) == "false" ]] ; then
        sudo rm -f /etc/xdg/picom.conf
        sudo ln -sfv ${repoPath}/picom/picom.conf /etc/xdg/picom.conf
    fi
}

main
exit 0

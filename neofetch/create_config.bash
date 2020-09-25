#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="neofetch"

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
    if [[ ! ( -d ~/.config/neofetch ) ]] ; then
        mkdir --mode=700 -p ~/.config/neofetch
    fi

    if [[ $(check_symlink ~/.config/neofetch/config.conf) == "false" ]] ; then
        rm -f ~/.config/neofetch/config.conf
        ln -sfv ${repoPath}/neofetch/config.conf ${HOME}/.config/neofetch/config.conf
    fi
}

main
exit 0

#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="dunst"

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
    if [[ ! ( -d ~/.config/dunst ) ]] ; then
        mkdir --mode=700 -p ~/.config/dunst
    fi

    if [[ $(check_symlink ~/.config/dunst/dunstrc) == "false" ]] ; then
        rm -f ~/.config/dunst/dunstrc
        ln -fsv ${repoPath}/dunst/dunstrc ~/.config/dunst/
    fi
}

main
exit 0

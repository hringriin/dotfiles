#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="alacritty"

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
    if [[ ! -d ${HOME}/.config/alacritty ]] ; then
        mkdir -p ${HOME}/.config/alacritty
    fi

    if [[ $(check_symlink ${HOME}/.config/alacritty/alacritty.yml) == "false" ]] ; then
        rm -f ~/.config/alacritty/alacritty.yml
        ln -vsf ${repoPath}/alacritty/alacritty.yml ${HOME}/.config/alacritty/alacritty.yml
    fi
}

main
exit 0

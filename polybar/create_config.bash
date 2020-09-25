#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="polybar"

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
    if [[ ! -e ${HOME}/.config/polybar/config ]] ; then
        mkdir -p ${HOME}/.config/polybar/
    else
        rm -rf ${HOME}/.config/polybar/config
    fi

    if [[ $(check_symlink ~/.config/polybar/config) == "false" ]] ; then
        rm -f ~/.config/polybar/config
        ln -svf ${repoPath}/polybar/config ${HOME}/.config/polybar/config
    fi
}

main
exit 0

#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="polybar"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash
source INSTALL_ALL/yay.bash
source INSTALL_ALL/pacman.bash

main()
{
    if [[ ! -e ${HOME}/.config/polybar/config ]] ; then
        mkdir -p ${HOME}/.config/polybar/
    else
        rm -rf ${HOME}/.config/polybar/config
    fi

    ln -svf ${repoPath}/polybar/config ${HOME}/.config/polybar/config
}

main
exit 0

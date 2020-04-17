#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="sxiv"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash
source INSTALL_ALL/yay.bash
source INSTALL_ALL/pacman.bash

main()
{
    if [[ ! -d ${HOME}/.config/sxiv/exec ]] ; then
        mkdir -p ${HOME}/.config/sxiv/exec
    fi

    ln -sfv ${repoPath}/sxiv/key-handler ${HOME}/.config/sxiv/exec/key-handler
    ln -sfv ${repoPath}/sxiv/image-info ${HOME}/.config/sxiv/exec/image-info
}

main
exit 0

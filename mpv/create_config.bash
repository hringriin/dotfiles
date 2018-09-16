#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="mpv"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    if [[ ! -d ${HOME}/.config/mpv ]] ; then
        mkdir -p ${HOME}/.config/mpv
    fi

    ln -sfv ${repoPath}/mpv/mpv.conf ${HOME}/.config/mpv/mpv.conf
}

main
exit 0

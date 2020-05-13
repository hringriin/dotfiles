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

    ln -sfv ${repoPath}/mpv/mpv.conf ${HOME}/.config/mpv/
    ln -sfv ${repoPath}/mpv/input.conf ${HOME}/.config/mpv/
    ln -sfv ${repoPath}/mpv/scripts ${HOME}/.config/mpv/
    ln -sfv ${repoPath}/mpv/script-opts ${HOME}/.config/mpv/
    ln -sfv ${repoPath}/mpv/lua-settings ${HOME}/.config/mpv/

}

main
exit 0

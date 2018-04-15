#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="ROFI"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{

    if [[ ! ( -d ${HOME}/.config/rofi ) ]] ; then
        mkdir --mode=700 -p ${HOME}/.config/rofi
    fi
    ln -fsv ${repoPath}/rofi/config ${HOME}/.config/rofi/config
    ln -fsv ${repoPath}/rofi/gruvbox-dark-hringriin.rasi ${HOME}/.config/rofi/gruvbox-dark-hringriin.rasi

    if [[ ! ( -d ${HOME}/.config/rofi-twitch ) ]] ; then
        mkdir --mode=700 -p ${HOME}/.config/rofi-twitch
        git clone git@github.com:hringriin/rofi-twitch ${HOME}/Repositories/github.com/hringriin/rofi-twitch/repo
    fi

    cp -v ${repoPath}/../../rofi-twitch/repo/settings ${HOME}/.config/rofi-twitch/settings
    sudo ln -s ${repoPath}/../../rofi-twitch/repo/hringriin-fav /usr/local/bin/hringriin-fav
}

main
exit 0

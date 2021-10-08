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
    ln -fsv ${repoPath}/rofi/config.rasi ${HOME}/.config/rofi/config.rasi
    ln -fsv ${repoPath}/rofi/hringriin.rasi ${HOME}/.config/rofi/hringriin.rasi

    cp -v ${repoPath}/../../rofi-twitch/repo/settings ${HOME}/.config/rofi-twitch/settings
}

main
exit 0

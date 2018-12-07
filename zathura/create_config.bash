#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="zathura"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash
source INSTALL_ALL/yay.bash
source INSTALL_ALL/pacman.bash

main()
{
    if [[ ! ( -d ~/.config/zathura ) ]] ; then
        mkdir --mode=700 -p ~/.config/zathura
    fi
    ln -fsv ${repoPath}/zathura/zathurarc ~/.config/zathura/
}

main
exit 0

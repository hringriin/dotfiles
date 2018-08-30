#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="ranger"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash
source INSTALL_ALL/yay.bash
source INSTALL_ALL/pacman.bash

main()
{
    if [[ ! -d ${HOME}/.config/ranger ]] ; then
        mkdir -p ${HOME}/.config/ranger
    fi

    ln -sfv ${repoPath}/ranger/bookmarks ${HOME}/.config/ranger/
    ln -sfv ${repoPath}/ranger/commands.py ${HOME}/.config/ranger/
    ln -sfv ${repoPath}/ranger/commands_full.py ${HOME}/.config/ranger/
    ln -sfv ${repoPath}/ranger/history ${HOME}/.config/ranger/
    ln -sfv ${repoPath}/ranger/rc.conf ${HOME}/.config/ranger/
    ln -sfv ${repoPath}/ranger/rifle.conf ${HOME}/.config/ranger/
    ln -sfv ${repoPath}/ranger/scope.sh ${HOME}/.config/ranger/
    ln -sfv ${repoPath}/ranger/tagged ${HOME}/.config/ranger/
}

main
exit 0

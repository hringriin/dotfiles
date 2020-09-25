#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="nagstamon"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash
source INSTALL_ALL/yay.bash
source INSTALL_ALL/pacman.bash

main()
{
    installation
    configuration
}

installation()
{
    if [[ $(check_installed ${prgname}) -eq 0 ]] ; then
        sudo yay -S ${prgname}
    fi
}

configuration()
{
    if [[ ! -d ${HOME}/.nagstamon ]] ; then
        mkdir -p ${HOME}/.nagstamon
    fi

    if [[ -e ${HOME}/.nagstamon/nagstamon.conf ]] ; then
        rm ${HOME}/.nagstamon/nagstamon.conf
    fi

    echo -e "Killing nagstamon ..."
    kill -s SIGTERM $(ps aux | grep /usr/bin/nagstamon | grep python | awk '{print $2}')

    sleep 2

    echo -e "Copying config ..."
    cp -i ${repoPath}/nagstamon/nagstamon.conf ${HOME}/.nagstamon/

    sleep 2

    echo -e "Restarting nagstamon ..."
    nagstamon &
}

main
exit 0

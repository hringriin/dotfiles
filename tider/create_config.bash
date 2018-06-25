#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="tider"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    if [[ $1 == "inst" ]] ; then
        if [[ ! -d ${HOME}/.config/tider ]] ; then
            mkdir -p ${HOME}/.config/tider
        fi
        cp -v ${repoPath}/tider/config.py ${HOME}/.config/tider
    fi

    if [[ $1 == "db-backup" ]] ; then
        cp -v ${HOME}/.config/tider/log.db ${HOME}/ownCloud/Documents/tider/log.db
    fi

    if [[ $1 == "db-restore" ]] ; then
        cp -iv ${HOME}/ownCloud/Documents/tider/log.db ${HOME}/.config/tider/log.db
    fi
}

main $1
exit 0

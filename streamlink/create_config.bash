#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="STREAMLINK"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{

    if [[ ! ( -d ${HOME}/.config/streamlink ) ]] ; then
        mkdir --mode=700 -p ${HOME}/.config/streamlink
    fi
    ln -fsv ${repoPath}/streamlink/config ${HOME}/.config/streamlink/config
}

main
exit 0

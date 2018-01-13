#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="TIMESCRIPT"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    if [[ ! ( -d ~/TIMESCRIPT ) ]] ; then
        mkdir -m 700 ~/TIMESCRIPT
    fi
    ln -fsv ${repoPath}/TIMESCRIPT/* ~/TIMESCRIPT
}

main
exit 0

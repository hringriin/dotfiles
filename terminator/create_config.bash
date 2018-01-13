#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="TERMINATOR"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    if [[ ! ( -d ~/.config/terminator ) ]] ; then
        mkdir --mode=700 -p ~/.config/terminator
    fi
    ln -fsv ${repoPath}/terminator/config ~/.config/terminator/config
}

main
exit 0

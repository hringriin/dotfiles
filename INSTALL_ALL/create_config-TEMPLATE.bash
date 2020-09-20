#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="PROGRAM"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    installation
    configuration
}

installation()
{
    if [[ $(check_installed ${prgname}) -eq 0 ]] ; then
        sudo pacman -S ${prgname}
    fi
}

configuration()
{
    #TODO
}

main
exit 0

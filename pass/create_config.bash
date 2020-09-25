#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="pass"

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
    if [[ $(check_symlink ~/.password-store) == "false" ]] ; then
        rm -rf ${HOME}/.password-store
        ln -sfv ${HOME}/ownCloud/Documents/pass ${HOME}/.password-store
    fi
}

main
exit 0

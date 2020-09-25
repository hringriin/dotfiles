#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="newsboat"

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
    if [[ ! -d ${HOME}/.newsboat ]] ; then
        mkdir -p ${HOME}/.newsboat
    fi

    if [[ $(check_symlink ~/.newsboat/config) == "false" ]] ; then
        rm -r ~/.newsboat/config
        ln -sfv ${repoPath}/newsboat/config ${HOME}/.newsboat/config
    fi

    if [[ $(check_symlink ~/.newsboat/urls) == "false" ]] ; then
        rm -f ~/.newsboat/urls
        ln -sfv ${repoPath}/newsboat/urls ${HOME}/.newsboat/urls
    fi
}

main
exit 0

#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="ncspot"
cfgPath="${HOME}/.config/ncspot"

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
        sudo /usr/bin/yay -S ${prgname}
    fi
}

configuration()
{
    if [[ ! ( -d ${cfgPath} ) ]] ; then
        mkdir -p ${cfgPath}
    fi

    ln -sfv ${repoPath}/ncspot/config.toml ${cfgPath}/config.toml
}

main
exit 0

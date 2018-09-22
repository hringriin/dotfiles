#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="newsboat"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    if [[ ! -d ${HOME}/.newsboat ]] ; then
        mkdir -p ${HOME}/.newsboat
    fi

    ln -sfv ${repoPath}/newsboat/config ${HOME}/.newsboat/config
    ln -sfv ${repoPath}/newsboat/urls ${HOME}/.newsboat/urls
}

main
exit 0

#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="MOC"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    if [[ ! -d ${HOME}/.moc ]] ; then
        mkdir -p ${HOME}/.moc
    fi

    cp -v ${repoPath}/moc/config ${HOME}/.moc/
    cp -v ${repoPath}/moc/hringriin_keymap ${HOME}/.moc
    cp -vr ${repoPath}/moc/themes ${HOME}/.moc
}

main
exit 0

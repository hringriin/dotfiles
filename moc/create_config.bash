#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="moc"

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
    if [[ ! -d ${HOME}/.moc ]] ; then
        mkdir -p ${HOME}/.moc
    fi

    cp -fv ${repoPath}/moc/config ${HOME}/.moc/
    cp -fv ${repoPath}/moc/hringriin_keymap ${HOME}/.moc
    cp -fvr ${repoPath}/moc/themes ${HOME}/.moc
}

main
exit 0

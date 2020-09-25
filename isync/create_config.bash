#!/bin/bash
# create isync config

prgname="isync"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

MBSYNCREPOPATH="${HOME}/Repositories/github.com/hringriin/dotfiles/repo/isync"

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
    cp -f ${MBSYNCREPOPATH}/mbsyncrc ${HOME}/.mbsyncrc

    # linking the script to create mailbox folders
    if [[ $(check_symlink /usr/local/bin/createFolderInMailbox) == "false" ]] ; then
        sudo ln -fsv ${MBSYNCREPOPATH}/scripts/createFolderInMailbox.bash /usr/local/bin/createFolderInMailbox
    fi
}

main
exit 0

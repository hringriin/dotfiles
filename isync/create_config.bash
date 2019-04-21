#!/bin/bash
# create isync config

prgname="ISYNC/MBSYNC"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

MBSYNCREPOPATH="${HOME}/Repositories/github.com/hringriin/dotfiles/repo/isync"
MBSYNCFILE="${HOME}/.mbsyncrc"

main()
{
    cp -f ${MBSYNCREPOPATH}/mbsyncrc ${HOME}/.mbsyncrc

    # linking the script to create mailbox folders
    sudo ln -fsv ${MBSYNCREPOPATH}/scripts/createFolderInMailbox.bash /usr/local/bin/createFolderInMailbox
}

main
exit 0

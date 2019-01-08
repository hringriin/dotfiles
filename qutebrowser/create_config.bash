#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="qutebrowser"

quteconf="${HOME}/.config/qutebrowser"
qutelocal="${HOME}/.local/share/qutebrowser"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash
source INSTALL_ALL/yay.bash
source INSTALL_ALL/pacman.bash

main()
{
    if [[ ! -d ${quteconf} ]] ; then
        mkdir -p ${quteconf}
    fi

    ln -sfv ${repoPath}/qutebrowser/autoconfig.yml ${quteconf}
    ln -sfv ${repoPath}/qutebrowser/bookmarks ${quteconf}
    ln -sfv ${repoPath}/qutebrowser/quickmarks ${quteconf}

    if [[ ! -d ${qutelocal} ]] ; then
        mkdir -p ${qutelocal}
    fi

    ln -sfv ${repoPath}/qutebrowser/userscripts ${qutelocal}
}

main
exit 0

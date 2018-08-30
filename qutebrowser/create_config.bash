#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="qutebrowser"

quteconf="${HOME}/.config/qutebrowser"

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
}

main
exit 0

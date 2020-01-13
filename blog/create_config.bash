#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="blogscript"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash
source INSTALL_ALL/yay.bash
source INSTALL_ALL/pacman.bash

main()
{
    sudo ln -sfv ${repoPath}/blog/blogscript.bash /usr/local/bin/blogscript
    sudo ln -sfv ${repoPath}/blog/blogscript.bash /usr/local/bin/lb

    if [[ ! -d ${HOME}/barzh.eu ]] ; then
        ln -sfv ${HOME}/ownCloud/Documents/websites/barzh.eu ${HOME}/barzh.eu
    fi

    if [[ ! -d ${HOME}/barzh.ddns.net ]] ; then
        ln -sfv ${HOME}/ownCloud/Documents/websites/barzh.ddns.net ${HOME}/barzh.ddns.net
    fi
}

main
exit 0

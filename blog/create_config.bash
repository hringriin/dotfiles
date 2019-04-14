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
}

main
exit 0

#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="GIT"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    ln -fsv ${repoPath}/git/gitconfig ~/.gitconfig
    ln -fsv ${repoPath}/git/gitignore ~/.gitignore
}

main
exit 0

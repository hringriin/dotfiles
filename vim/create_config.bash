#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="VIM"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    sudo ln -fsv ${repoPath}/vim/vimrc /etc/vimrc
}

main
exit 0

#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="HTOP"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    if [[ ! ( -d ~/.config/htop ) ]] ; then
        mkdir --mode=700 -p ~/.config/htop
    fi
    ln -fsv ${repoPath}/htop/htoprc ~/.config/htop/htoprc
}

main
exit 0

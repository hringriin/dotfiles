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
    git clone git@github.com:hringriin/barzh.eu ~/barzh.eu
    git clone git@github.com:hringriin/barzh.ddns.net ~/barzh.ddns.net
}

main
exit 0

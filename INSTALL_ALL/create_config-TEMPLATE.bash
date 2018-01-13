#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="PROGRAM"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash
source INSTALL_ALL/packer.bash
source INSTALL_ALL/pacman.bash

main()
{
}

main
exit 0

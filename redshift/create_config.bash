#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="REDSHIFT"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    ln -fsv ${repoPath}/redshift/redshift.conf ~/.config/redshift.conf
}

main
exit 0

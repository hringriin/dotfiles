#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="XORG"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    ln -fsv ${repoPath}/X/Xdefaults ~/.Xdefaults
    ln -fsv ${repoPath}/X/xinitrc ~/.xinitrc
}

main
exit 0

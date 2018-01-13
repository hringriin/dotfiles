#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="CLIPSTER"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    if [[ ! ( -d ~/.config/clipster/ ) ]] ; then
        mkdir -p ~/.config/clipster/
    fi
    ln -fsv ${repoPath}/clipster/clipster.ini ~/.config/clipster/
}

main
exit 0

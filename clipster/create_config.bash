#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="clipster"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    installation
    configuration
}

installation()
{
    if [[ $(check_installed ${prgname}) -eq 0 ]] ; then
        yay -S ${prgname}
    fi
}

configuration()
{
    if [[ ! ( -d ~/.config/clipster/ ) ]] ; then
        mkdir -p ~/.config/clipster/
    fi

    if [[ $(check_symlink ~/.config/clipster/clipster.ini) == "false" ]] ; then
        rm -f ~/.config/clipster/clipster.ini
        ln -fsv ${repoPath}/clipster/clipster.ini ~/.config/clipster/
    fi
}

main
exit 0

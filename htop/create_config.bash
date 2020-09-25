#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="htop"

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
        yay -S htop-vim-git
    fi
}

configuration()
{
    if [[ ! ( -d ~/.config/htop ) ]] ; then
        mkdir --mode=700 -p ~/.config/htop
    fi

    if [[ $(check_symlink ~/.config/htop/htoprc) == "false" ]] ; then
        rm -f ~/.config/htop/htoprc
        ln -fsv ${repoPath}/htop/htoprc ~/.config/htop/htoprc
    fi
}

main
exit 0

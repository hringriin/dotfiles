#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="git"

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
        sudo pacman -S ${prgname} gitg
    fi
}

configuration()
{
    if [[ $(check_symlink ~/.gitconfig) == "false" ]] ; then
        rm -f ~/.gitconfig
        ln -fsv ${repoPath}/git/gitconfig ~/.gitconfig
    fi

    if [[ $(check_symlink ~/.gitignore) == "false" ]] ; then
        rm -f ~/.gitignore
        ln -fsv ${repoPath}/git/gitignore ~/.gitignore
    fi
}

main
exit 0

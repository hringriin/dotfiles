#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="mpv"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
}

installation()
{
    if [[ $(check_installed ${prgname}) -eq 0 ]] ; then
        sudo pacman -S ${prgname}
    fi
}

configuration()
{
    if [[ ! -d ${HOME}/.config/mpv ]] ; then
        mkdir -p ${HOME}/.config/mpv
    fi

    if [[ $(check_symlink ~/.config/mpv/mpv.conf) == "false" ]] ; then
        rm -f ~/.config/mpv/mpv.conf
        ln -sfv ${repoPath}/mpv/mpv.conf ${HOME}/.config/mpv/
    fi

    if [[ $(check_symlink ~/.config/mpv/input.conf) == "false" ]] ; then
        rm -f ~/.config/mpv/input.conf
        ln -sfv ${repoPath}/mpv/input.conf ${HOME}/.config/mpv/
    fi

    if [[ $(check_symlink ~/.config/mpv/scripts) == "false" ]] ; then
        rm -f ~/.config/mpv/scripts
        ln -sfv ${repoPath}/mpv/scripts ${HOME}/.config/mpv/
    fi

    if [[ $(check_symlink ~/.config/mpv/script-opts) == "false" ]] ; then
        rm -f ~/.config/mpv/script-opts
        ln -sfv ${repoPath}/mpv/script-opts ${HOME}/.config/mpv/
    fi

    if [[ $(check_symlink ~/.config/mpv/lua-settings) == "false" ]] ; then
        rm -f ~/.config/mpv/lua-settings
        ln -sfv ${repoPath}/mpv/lua-settings ${HOME}/.config/mpv/
    fi
}

main
exit 0

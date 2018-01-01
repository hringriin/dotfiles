#!/bin/bash
# create TMUX config

echo -e "\e[1;36mINSTALLTING TMUX CONFIGURATION FILES ...\e[0m"
sleep 1

# CONFIG
REPOPATH="/home/${USER}/Repositories/github.com/hringriin/dotfiles/repo/tmux"
TMUXPATH="/home/${USER}/.tmux"

# links config files
linkFiles ()
{
    ln -vsf ${REPOPATH}/tmux.conf ${TMUXPATH}.conf
}

# creates directories, if not exist
checkDir ()
{
    if [[ ! -d ${TMUXPATH} ]] ; then
        mkdir -p ${TMUXPATH}
    fi

    if [[ ! -d ${TMUXPATH} ]] ; then
        mkdir -p ${TMUXPATH}/plugins
    fi
}

# Tmux Plugin Manager
tpm ()
{
    echo -e "Install [T]mux [P]lugin [M]anager? [y|N]"
    read -e instTPM

    if [[ ${instTPM} == "y" || ${instTPM} == "Y" ]] ; then
        if [[ -d ${TMUXPATH}/plugins/tpm ]] ; then
            echo "Updating TPM"
            cd ${TMUXPATH}/plugins/tpm
            git pull
        else
            echo "Cloning TPM"
            git clone https://github.com/tmux-plugins/tpm ${TMUXPATH}/plugins/tpm
        fi
    else
        echo "Unknown operation or user aborted. Not Installting TPM."
    fi
}

main ()
{
    checkDir
    linkFiles
    tpm
}

main
exit 0

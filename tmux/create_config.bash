#!/bin/bash
# create TMUX config

prgname="TMUX"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

# CONFIG

TMUXPATH="${HOME}/.tmux"

# links config files
linkFiles ()
{
    ln -vsf ${repoPath}/tmux/tmux.conf ${TMUXPATH}.conf
}

installtmuxinator ()
{
    if [[ ! $(uname -r)  == *"icrosoft"* ]] ; then
        if [[ -d /home/hringriin/.gem/ruby/2.6.0/bin ]] ; then
            # adding ruby bin to path variable
            export PATH=/home/hringriin/.gem/ruby/2.6.0/bin:${PATH}
        else
            echo "Installing tmuxinator ..."
            sudo gem install tmuxinator
            export PATH=/home/hringriin/.gem/ruby/2.6.0/bin:${PATH}
            tmuxinator doctor
            read -p
        fi
    fi

    sleep 2 ; echo "removing tmuxinator config files" ; sleep 2
    rm -rfv ${HOME}/.config/tmuxinator
    ln -sfv ${repoPath}/tmux/tmuxinator-conf ${HOME}/.config/tmuxinator
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
    installtmuxinator
}

main
exit 0

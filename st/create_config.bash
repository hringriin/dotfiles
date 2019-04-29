#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="st"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash
source INSTALL_ALL/yay.bash
source INSTALL_ALL/pacman.bash

stRepo="${HOME}/Repositories/suckless.org/st/repo"
main()
{
    if [[ ! -d ${stRepo} ]] ; then
        mkdir -p ${stRepo}
    fi

    cd ${stRepo}
    git clone git://git.suckless.org/st ./
    wget http://st.suckless.org/patches/alpha/st-alpha-0.8.2.diff
    patch -Np1 -i st-alpha-0.8.2.diff
    ln -fsv ${repoPath}/st/config.h ${stRepo}/config.h
    ln -fsv ${repoPath}/st/st.info ${stRepo}/st.info
    sudo make clean install
    cd -
}

main
exit 0

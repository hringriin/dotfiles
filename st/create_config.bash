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
    rm -rf ${stRepo}
    mkdir -p ${stRepo}

    cd ${stRepo}

    if [[ $(command -v ${prgname}) > /dev/null ]] ; then
        echo -e "\e[1;33mUninstall\e[0m \e[1;36m${prgname}\e[1;33m first?\e[0m"
        read -p "[y/N]: " unInst

        if [[ ${unInst} == "y" || ${unInst} == "Y" ]] ; then
            sudo make uninstall
        fi
    fi

    git clone git://git.suckless.org/st ./
    wget http://st.suckless.org/patches/alpha/st-alpha-0.8.2.diff
    wget https://st.suckless.org/patches/copyurl/st-copyurl-20190202-3be4cf1.diff
    patch -Np1 -i st-alpha-0.8.2.diff
    patch -Np1 -i st-copyurl-20190202-3be4cf1.diff
    rm *.diff*
    ln -fsv ${repoPath}/st/config.h ${stRepo}/config.h
    ln -fsv ${repoPath}/st/st.info ${stRepo}/st.info

    echo -e "\e[1;33mTry to build\e[0m \e[1;36m${prgname}\e[1;33m?\e[0m"
    read -p "[Y/n]: " tryBuild
    if [[ ${tryBuild} == "y" || ${tryBuild} == "Y" || ${tryBuild} == "" ]] ; then
        make clean ; make

        echo -e "\e[1;31mTry to install\e[0m \e[1;36m${prgname}\e[1;33m?\e[0m"
        read -p "[y/N]: " tryInst
        if [[ ${tryInst} == "y" || ${tryInst} == "Y" ]] ; then
            sudo make install
        fi
    fi

    cd -
}

main
exit 0

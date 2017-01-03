#!/bin/bash
# install-all
# This script will install most programmes needed by myself and all programmes, of which the config files
# are provided in this repository.


# Please note, that this script assumes, that you're running Arch Linux.


# exit status
# 0: everything fine
# 1: user chose not to continue at Arch Linux Question
# 2: incorrect values entered
# 3: user will not be added to sudoers file

# temporary files
tmpDir="/tmp"                                                               # temp dir
tmp1="neededProgrammes$$"                                                   # temp file for evaluation of needed programmes by pacman
tmp2="neededProgrammes2$$"                                                  # temp file for evaluation of needed programmes by packer
tmp3="sudoers"                                                              # temp file for evaluation of member of sudoers
missingPacmanPrg=0                                                          # boolean; 0: all installed; 1: one or more programmes missing
missingPackerPrg=0                                                          # boolean; 0: all installed; 1: one or more programmes missing
missingPacmanList="missingPacmanList$$"                                     # list of missing programmes (pacman)
missingPackerList="missingPackerList$$"                                     # list of missing programmes (packer)
packerList=()                                                               # empty array to write in
repoPath="/home/${USER}/Repositories/github.com/hringriin/dotfiles/repo"    # path of the repository
ulbin="/usr/local/bin"

# list of programmes maintained by packer needed for the whole action
neededPackerPrgorammes=(
    'adduser'
    'dropbox'
    'dropbox-cli'
    'spotify-legacy'
    'ttf-font-awesome'
    'whatsie'
)

# list of programmes maintained by pacman needed for the whole action
neededProgrammes=(
    'archlinux-keyring'
    'autoconf'
    'automake'
    'bash'
    'bash-completion'
    'bc'
    'binutils'
    'bison'
    'compton'
    'curl'
    'evince'
    'expac'
    'fakeroot'
    'file'
    'findutils'
    'firefox'
    'flex'
    'galculator'
    'gawk'
    'gcc'
    'gettext'
    'git'
    'grep'
    'groff'
    'gzip'
    'htop'
    'i3-wm'
    'i3lock'
    'i3status'
    'jshon'
    'keepassx2'
    'libtool'
    'lm_sensors'
    'lxappearance'
    'lynx'
    'm4'
    'make'
    'mcabber'
    'meld'
    'mumble'
    'networkmanager'
    'networkmanager-openconnect'
    'networkmanager-openvpn'
    'networkmanager-pptp'
    'networkmanager-vpnc'
    'nitrogen'
    'nm-connection-editor'
    'numlockx'
    'openconnect'
    'openssh'
    'openssl'
    'openvpn'
    'owncloud-client'
    'pacman'
    'pandoc'
    'pass'
    'patch'
    'pavucontrol'
    'pinentry'
    'pkg-config'
    'powerline-fonts'
    'pulseaudio'
    'pulseaudio-alsa'
    'pulseaudio-bluetooth'
    'pulseaudio-equalizer'
    'pulseaudio-gconf'
    'pulseaudio-lirc'
    'pulseaudio-xen'
    'pulseaudio-zeroconf'
    'ranger'
    'rofi'
    'rxvt-unicode'
    'seahorse'
    'sed'
    'sudo'
    'teamspeak3'
    'terminator'
    'texinfo'
    'thunar'
    'thunderbird'
    'ttf-dejavu'
    'util-linux'
    'vim'
    'vlc'
    'vpnc'
    'weechat'
    'which'
    'wine'
    'winetricks'
    'wireless_tools'
    'wpa_supplicant'
    'xorg-server'
    'xorg-server-utils'
    'xorg-xinit'
    'xterm'
)

# information regarding arch linux
function archLinuxCheck()
{
    echo -e "########################################################"
    echo -e "# This script assumes, that you're running Arch Linux. #"
    echo -e "#                                                      #"
    echo -e "#                   Continue ? [y/N]                   #"
    echo -e "#                                                      #"
    echo -e "########################################################"
    read alcheck

    if [[ ${alcheck} == "n" || ${alcheck} == "N" || ${alcheck} == "" ]] ; then
        exit 1
    elif [[ ${alcheck} == "y" || ${alcheck} == "Y" ]] ; then
        unset alcheck
        main
    fi
}

# checks whether programmes are missing and writes those
# names to a file
function checkNeededPacman()
{
    echo -e "\n\nChecking for not installed programmes (pacman) ...\n\n"

    # checks every programm in the array whether it is installed
    for var in "${neededProgrammes[@]}"
    do
        if pacman -Qi ${var} &> /dev/null ; then
            echo -e "${var} ... \e[92minstalled\e[0m" >> ${tmpDir}/${tmp1}
        else
            echo -e "${var} ... \e[91mnot installed\e[0m" >> ${tmpDir}/${tmp1}
            echo ${var} >> ${tmpDir}/${missingPacmanList}
            missingPacmanPrg=1
        fi
    done

    # nice output with column. green=installed;red=notinstalled
    echo -e "\n\n\nList of Programmes provided by \e[93mpacman\e[0m\n"
    column -t -s "..." ${tmpDir}/${tmp1}
    sleep 1     # just to slow things a bit down

    # if there are programmes missing (pacman)
    if [[ ${missingPacmanPrg} -eq 1 ]] ; then
        echo -e "\nThere are missing programmes (\e[93mpacman\e[0m)!\n"
        echo -e "Shall they be installed now? \e[91m(root privileges needed!)\e[0m [\e[92my\e[0m/\e[91mN\e[0m]"
        read instMissPrg

        if [[ ${instMissPrg} == "y" || ${instMissPrg} == "Y" ]] ; then
            # install all missing programmes at once
            su -c "pacman -S - < ${tmpDir}/${missingPacmanList}" root
        elif [[ ${instMissPrg} == "n" || ${instMissPrg} == "N" || ${instMissPrg} == "" ]] ; then
            echo -e "\n\e[93m!!! There are missing programmes !!!"
            echo -e "Please install them by yourself and run this script again.\e[0m"
        else
            echo -e "Incorrect value. Aborting."
            exit 2
        fi
    else
        echo -e "\n\nEvery package maintainable by \e[93mpacman\e[0m \e[92mis installed\e[0m."
    fi

    unset instMissPrg
}

function checkNeededPacker()
{
    echo -e "\n\nChecking for not installed programmes (packer) ...\n\n"

    # checks every programm in the array whether it is installed
    for var in "${neededPackerPrgorammes[@]}"
    do
        if pacman -Qi ${var} &> /dev/null ; then
            echo -e "${var} ... \e[92minstalled\e[0m" >> ${tmpDir}/${tmp2}
        else
            echo -e "${var} ... \e[91mnot installed\e[0m" >> ${tmpDir}/${tmp2}
            echo ${var} >> ${tmpDir}/${missingPackerList}
            missingPackerPrg=1
        fi
    done

    # nice output with column. green=installed;red=notinstalled
    echo -e "\n\n\nList of Programmes provided by \e[93mpacker\e[0m\n"
    column -t -s "..." ${tmpDir}/${tmp2}
    sleep 1     # just to slow things a bit down

    # if there are programmes missing (packer)
    if [[ ${missingPackerPrg} -eq 1 ]] ; then
        echo -e "\nThere are missing programmes (\e[93mpacker\e[0m)!\n"
        echo -e "Shall they be installed now? [\e[92my\e[0m/\e[91mN\e[0m]"
        read instMissPrg

        if [[ ${instMissPrg} == "y" || ${instMissPrg} == "Y" ]] ; then
            # install all missing programmes one by one
            index=0
            while read line
            do
                packerList[$index]="$line"
                index=$(($index+1))
            done < ${tmpDir}/${missingPackerList}

            for var in "${packerList[@]}"
            do
                packer --noedit --auronly -S ${var}
            done
        elif [[ ${instMissPrg} == "n" || ${instMissPrg} == "N" || ${instMissPrg} == "" ]] ; then
            echo -e "\n\e[93m!!! There are missing programmes !!!"
            echo -e "Please install them by yourself and run this script again.\e[0m"
        else
            echo -e "Incorrect value. Aborting."
            exit 2
        fi
    else
        echo -e "\n\nEvery package maintainable by \e[93mpacker\e[0m \e[92mis installed\e[0m."
    fi

    unset instMissPrg
}

function cleanup()
{
    echo -e "Cleaning up ..."
    rm -rf ${tmpDir}/${tmp1}
    rm -rf ${tmpDir}/${tmp2}
    rm -rf ${tmpDir}/${tmp3}
    rm -rf ${tmpDir}/${missingPacmanList}
    rm -rf ${tmpDir}/${missingPackerList}
    echo -e "... done!"
}

function unsetVars()
{
    unset tmpDir
    unset tmp1 tmp2 tmp3
    unset missingPacmanPrg
    unset missingPackerPrg
    unset missingPacmanList
    unset missingPackerList
    unset packerList
    unset repoPath
    unset ulbin
}

function addToSudoers()
{
    sudo -v &> ${tmpDir}/${tmp3}
    read -r line < ${tmpDir}/${tmp3}
    if [[ ${line} == "" ]] ; then
        echo -e "The user ${USER} is already member of 'sudoers'.\nNothing to do."
    else
        echo -e "It is mandatory to add the curring user running this script"
        echo -e "to the sudoers file."
        read -p "OK? [Y/n] : " addSudo

        if [[ ${addSudo} == "y" || ${addSudo} == "Y" || ${addSudo} == "" ]] ; then
            su -c "echo 'hringriin ALL=(ALL) ALL' >> /etc/sudoers" root
        elif [[ ${addSudo} == "n" || ${addSudo} == "N" ]] ; then
            echo "Aborting."
            exit 3
        else
            echo "Unrecognized entry. Aborting."
            exit 3
        fi
    fi
}

function main()
{
    echo -e "To you want to install from new or just relink all config files?"
    read -p "[R]elink | [I]nstall " relink

    if [[ ${relink} == "r" || ${relink} == "R" ]] ; then
        cleanup
        linkConfigs
        cleanup
        exit 0
    elif [[ ${relink} == "i" || ${relink} == "I" ]] ; then
        main2
    else
        echo -e "Unrecognized entry."
        main
    fi
}

function main2()
{
    cleanup
    addToSudoers
    checkNeededPacman
    installPacker
    checkNeededPacker
    linkConfigs
    cleanup
    unsetVars
    exit 0
}

function installPacker()
{
    if pacman -Qi packer &> /dev/null ; then
        echo -e "packer ... \e[92minstalled\e[0m" >> ${tmpDir}/${tmp1}
    else
        echo -e "packer ... \e[91mnot minstalled\e[0m" >> ${tmpDir}/${tmp1}
        if [[ ! -d ${tmpDir}/packer ]] ; then
            mkdir ${tmpDir}/packer
        fi
        su -c "pacman -S wget" root
        wget -O ${tmpDir}/packer/packer.tar.gz https://aur.archlinux.org/cgit/aur.git/snapshot/packer.tar.gz
        wget -O ${tmpDir}/packer/PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=packer
        cd ${tmpDir}/packer
        makepkg -si
        cd -
    fi
}

function linkConfigs()
{
    chmod go-rwx ~
    sudo ln -fsv ${repoPath}/bash/bashrc /etc/bash.bashrc
    sudo ln -fsv ${repoPath}/bash/myGitlabClone.bash ${ulbin}/myGitlabClone
    sudo ln -fsv ${repoPath}/bash/youtubedl.bash ${ulbin}/youtubedl
    ln -fsv ${repoPath}/git/gitconfig ~/.gitconfig
    ln -fsv ${repoPath}/git/gitignore ~/.gitignore

    ${repoPath}/i3/createConfig.bash

    if [[ ! -d ~/.mcabber_uni ]] ; then
        mkdir --mode=700 ~/.mcabber_uni
        mkdir --mode=700 ~/.mcabber_uni/logs
        mkdir --mode=700 ~/.mcabber_uni/otr
    else
        if [[ ! -d ~/.mcabber_uni/logs ]] ; then
            mkdir --mode=700 ~/.mcabber_uni/logs
        fi

        if [[ ! -d ~/.mcabber_uni/logs ]] ; then
            mkdir --mode=700 ~/.mcabber_uni/otr
        fi

        if [[ ! -d ~/.mcabber_uni/event_files ]] ; then
            mkdir --mode=700 ~/.mcabber_uni/event_files
        fi
    fi

    cp -ifv ${repoPath}/mcabber/mcabberrc ~/.mcabber_uni/mcabberrc

    echo -e "Please configure your jabber uni account config."
    read -n 1 -s -p "Press any key to continue"
    vim ~/.mcabber_uni/mcabberrc

    if [[ ! -d ~/.mcabber_ccchb ]] ; then
        mkdir --mode=700 ~/.mcabber_ccchb
    else
        if [[ ! -d ~/.mcabber_ccchb/logs ]] ; then
            mkdir --mode=700 ~/.mcabber_ccchb/logs
        fi

        if [[ ! -d ~/.mcabber_ccchb/logs ]] ; then
            mkdir --mode=700 ~/.mcabber_ccchb/otr
        fi

        if [[ ! -d ~/.mcabber_ccchb/event_files ]] ; then
            mkdir --mode=700 ~/.mcabber_ccchb/event_files
        fi
    fi

    cp -ifv ${repoPath}/mcabber/mcabberrc ~/.mcabber_ccchb/mcabberrc

    echo -e "Please configure your jabber ccchb account config."
    read -n 1 -s -p "Press any key to continue"
    vim ~/.mcabber_ccchb/mcabberrc

    if [[ ! -d ~/.local/rofi ]] ; then
        mkdir --mode=700 ~/.local/rofi
    fi

    ln -fsv ${repoPath}/rofi/config ~/.local/rofi/config

    if [[ ! -d ~/.ssh ]] ; then
        mkdir --mode=700 ~/.ssh
    fi
    cp -ifv ${repoPath}/ssh/config ~/.ssh/config

    echo -e "Please unencrypt the ssh config."
    read -n 1 -s -p "Press any key to continue"
    vim ~/.ssh/config

    if [[ ! -d ~/.config/terminator ]] ; then
        mkdir --mode=700 ~/.config/terminator
    fi
    ln -fsv ${repoPath}/terminator/config ~/.config/terminator/config

    ln -fsv ${repoPath}/TIMESCRIPT /home/${USER}/TIMESCRIPT

    sudo ln -fsv ${repoPath}/vim/vimrc /etc/vimrc

    /home/${USER}/Repositories/github.com/hringriin/dotfiles/repo/weechat/link-files.bash

    ln -fsv ${repoPath}/X/Xdefaults ~/.Xdefaults
    ln -fsv ${repoPath}/X/xinitrc ~/.xinitrc

    sleep 2

    echo -e "This script exited normally."
}

# first action in this script. do not touch.
archLinuxCheck

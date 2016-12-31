#!/bin/bash
# install-all
# This script will install most programmes needed by myself and all programmes, of which the config files
# are provided in this repository.



# Please note, that this script assumes, that you're running Arch Linux.



# exit status
# 0: everything fine
# 1: user chose not to continue at Arch Linux Question
# 2: incorrect values entered

# temporary files
tmpDir="/tmp"                               # temp dir
tmp1="neededProgrammes$$"                   # temp file for evaluation of needed programmes by pacman
tmp2="neededProgrammes2$$"                  # temp file for evaluation of needed programmes by packer
missingPacmanPrg=0                          # boolean; 0: all installed; 1: one or more programmes missing
missingPackerPrg=0                          # boolean; 0: all installed; 1: one or more programmes missing
missingPacmanList="missingPacmanList$$"     # list of missing programmes (pacman)
missingPackerList="missingPackerList$$"     # list of missing programmes (packer)

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
# list of programmes needed for the whole action
neededPackerPrgorammes=(
    'adduser'
    'dropbox'
    'dropbox-cli'
    'spotify-legacy'
    'ttf-font-awesome'
    'whatsie'
)
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
    'i3-wm'
    'i3lock'
    'i3status'
    'jshon'
    'keepassx2'
    'libtool'
    'lxappearance'
    'lynx'
    'm4'
    'make'
    'mcabber'
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

# checks whether programmes are missing and writes those
# names to a file
function checkNeededProgrammes()
{
    cleanup

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

    # if there are programmes missing (packer)
    if [[ ${missingPackerPrg} -eq 1 ]] ; then
        echo -e "\nThere are missing programmes (\e[93mpacker\e[0m)!\n"
        echo -e "Shall they be installed now? [\e[92my\e[0m/\e[91mN\e[0m]"
        read instMissPrg

        if [[ ${instMissPrg} == "y" || ${instMissPrg} == "Y" ]] ; then
            # install all missing programmes one by one
            while read -r line
            do
                pacman -S $line
            done < ${tmpDir}/${missingPackerList}
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

    cleanup
}

function cleanup()
{
    rm -rf ${tmpDir}/${tmp1}
    rm -rf ${tmpDir}/${tmp2}
    rm -rf ${tmpDir}/${missingPacmanList}
    rm -rf ${tmpDir}/${missingPackerList}
    unset missingPacmanPrg
    unset missingPackerPrg
}

function main()
{
    installPacker
    checkNeededProgrammes
}

function installPacker()
{
    if pacman -Qi packer &> /dev/null ; then
        echo -e "packer ... \e[92minstalled\e[0m" >> ${tmpDir}/${tmp1}
    else
        mkdir ${tmpDir}/packer
        wget -O ${tmpDir}/packer/packer.tar.gz https://aur.archlinux.org/cgit/aur.git/snapshot/packer.tar.gz
        wget -O ${tmpDir}/packer/PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=packer
        cd ${tmpDir}/packer
        makepkg -si
    fi
}

# first action in this script. do not touch.
echo -e "\n\n\t\e[91mfrom last time: install list of applications with packer!\e[0m"
#archLinuxCheck

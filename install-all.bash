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
    'gitkraken'
    'i3lock-fancy-dualmonitors-git'
    'spotify-legacy'
    'ttf-font-awesome'
    'vivaldi'
    'vivaldi-ffmpeg-codecs'
    'vivaldi-widevine'
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
    'flashplugin'
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
    'mlocate'
    'mumble'
    'network-manager-applet'
    'networkmanager'
    'networkmanager-openconnect'
    'networkmanager-openvpn'
    'networkmanager-pptp'
    'networkmanager-vpnc'
    'nitrogen'
    'nm-connection-editor'
    'notify-osd'
    'ntp'
    'numlockx'
    'openconnect'
    'openssh'
    'openssl'
    'openvpn'
    'owncloud-client'
    'pacman'
    'pacmatic'
    'pandoc'
    'pass'
    'patch'
    'pavucontrol'
    'pepper-flash'
    'pinentry'
    'pkg-config'
    'powerline-fonts'
    'pulseaudio'
    'pulseaudio-alsa'
    'pulseaudio-bluetooth'
    'pulseaudio-equalizer'
    'pulseaudio-gconf'
    'pulseaudio-lirc'
    'pulseaudio-zeroconf'
    'ranger'
    'redshift'
    'rofi'
    'rxvt-unicode'
    'scrot'
    'seahorse'
    'sed'
    'sox'
    'sudo'
    'sxiv'
    'teamspeak3'
    'terminator'
    'termite'
    'texinfo'
    'thunar'
    'thunderbird'
    'tmux'
    'ttf-dejavu'
    'util-linux'
    'vim'
    'vlc'
    'vpnc'
    'weechat'
    'which'
    'wireless_tools'
    'wpa_supplicant'
    'xorg-server'
    'xorg-server-utils'
    'xorg-xev'
    'xorg-xinit'
    'xterm'
    'zsh'
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
    read -p "   : " alcheck

    if [[ ${alcheck} == "n" || ${alcheck} == "N" || ${alcheck} == "" ]] ; then
        exit 1
    elif [[ ${alcheck} == "y" || ${alcheck} == "Y" ]] ; then
        if [[ ${HOSTNAME} == "*stuga*" ]] ; then
            echo -e "This host is not allow for this script!"
        fi
        unset alcheck
        main
    fi
}

# checks whether programmes are missing and writes those
# names to a file
function checkNeededPacman()
{
    echo -e "\n\nChecking for not installed programmes (pacman) ...\n\n"
    sleep 2

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
    sleep 2     # just to slow things a bit down

    # if there are programmes missing (pacman)
    if [[ ${missingPacmanPrg} -eq 1 ]] ; then
        echo -e "\nThere are missing programmes (\e[93mpacman\e[0m)!\n"
        sleep 1
        echo -e "Shall they be installed now? \e[91m(root privileges needed!)\e[0m [\e[92my\e[0m/\e[91mN\e[0m]"
        read instMissPrg

        if [[ ${instMissPrg} == "y" || ${instMissPrg} == "Y" ]] ; then
            # install all missing programmes at once
            su -c "pacman -S - < ${tmpDir}/${missingPacmanList}" root
        elif [[ ${instMissPrg} == "n" || ${instMissPrg} == "N" || ${instMissPrg} == "" ]] ; then
            echo -e "\n\e[93m!!! There are missing programmes !!!"
            sleep 1
            echo -e "Please install them by yourself and run this script again.\e[0m"
        else
            echo -e "Incorrect value. Aborting."
            exit 2
        fi
    else
        echo -e "\n\nEvery package maintainable by \e[93mpacman\e[0m \e[92mis installed\e[0m."
        sleep 2
    fi

    unset instMissPrg
}

function checkNeededPacker()
{
    echo -e "\n\nChecking for not installed programmes (packer) ...\n\n"
    sleep 2

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
    sleep 2     # just to slow things a bit down

    # if there are programmes missing (packer)
    if [[ ${missingPackerPrg} -eq 1 ]] ; then
        echo -e "\nThere are missing programmes (\e[93mpacker\e[0m)!\n"
        sleep 1
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
                packer --noedit --auronly --noconfirm -S ${var}
            done
        elif [[ ${instMissPrg} == "n" || ${instMissPrg} == "N" || ${instMissPrg} == "" ]] ; then
            echo -e "\n\e[93m!!! There are missing programmes !!!"
            sleep 1
            echo -e "Please install them by yourself and run this script again.\e[0m"
        else
            echo -e "Incorrect value. Aborting."
            exit 2
        fi
    else
        echo -e "\n\nEvery package maintainable by \e[93mpacker\e[0m \e[92mis installed\e[0m."
        sleep 2
    fi

    unset instMissPrg
}

function cleanup()
{
    echo -e "\n\nCleaning up ..."
    sleep 1
    rm -rf ${tmpDir}/${tmp1}
    rm -rf ${tmpDir}/${tmp2}
    rm -rf ${tmpDir}/${tmp3}
    rm -rf ${tmpDir}/${missingPacmanList}
    rm -rf ${tmpDir}/${missingPackerList}
    echo -e "... done!\n\n"
    sleep 2
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
    sleep 2
}

function installTexlive()
{
    echo -e "\n\nInstalling texlive now ...\n\n"
    sleep 1
    if pacman -Qi texlive-core &> /dev/null ; then
        su -c "pacman -S $(pacman -Ssq texlive) sage" root
    else
        echo -e "Texlive is installed"
    fi
    echo -e "\n\n... done installing texlive!\n\n"
    sleep 2
}

function main()
{
    echo -e "To you want to install from new or just relink all config files?"
    read -p "[i]nstall all from new | [r]elink | [s]ervices: " relink

    if [[ ${relink} == "r" || ${relink} == "R" ]] ; then
        cleanup
        linkConfigs
        cleanup
        exit 0
    elif [[ ${relink} == "i" || ${relink} == "I" ]] ; then
        main2
    elif [[ ${relink} == "s" || ${relink} == "S" ]] ; then
        systemdQuestion
    else
        echo -e "Unrecognized entry."
        main
    fi
}

function systemdQuestion()
{
    echo -e "Do you want to link systemd services?"
    read -p "[y]es | [N]o " systemdLinks

    if [[ ${systemdLinks} == "Y" || ${systemdLinks} == "y" ]] ; then
        systemdServicesLink

        echo -e "Do you want to enable systemd services?"
        read -p "[y]es | [N]o " systemdEnable

        if [[ ${systemdEnable} == "Y" || ${systemdEnable} == "y" ]] ; then
            systemdServicesEnable

            echo -e "Do you want to start systemd services?"
            read -p "[y]es | [N]o " systemdStart

            if [[ ${systemdStart} == "Y" || ${systemdStart} == "y" ]] ; then
                systemdServicesStart
            elif [[ ${systemdStart} == "N" || ${systemdStart} == "n" ]] ; then
                echo "No systemd services will be started."
            else
                echo "Unrecognized entry!"
                main
            fi
        elif [[ ${systemdEnable} == "N" || ${systemdEnable} == "n" ]] ; then
            echo "No systemd services will be enabled."
        else
            echo "Unrecognized entry!"
            main
        fi
    elif [[ ${systemdLinks} == "N" || ${systemdLinks} == "n" ]] ; then
        echo "No systemd links will be made."
        sleep 2
    else
        echo "Unrecognized entry!"
        main
    fi
}

function main2()
{
    cleanup
    addToSudoers
    checkNeededPacman
    installTexlive
    installPacker
    checkNeededPacker
    linkConfigs
    systemdQuestion
    cleanup
    unsetVars
    exit 0
}

function installPacker()
{
    echo -e "\n\nInstalling packer ...\n\n"
    sleep 1
    if pacman -Qi packer &> /dev/null ; then
        echo -e "packer ... \e[92minstalled\e[0m" >> ${tmpDir}/${tmp1}
    else
        echo -e "packer ... \e[91mnot minstalled\e[0m" >> ${tmpDir}/${tmp1}
        if [[ ! ( -d ${tmpDir}/packer ) ]] ; then
            mkdir -p ${tmpDir}/packer
        fi
        su -c "pacman -S wget" root
        wget -O ${tmpDir}/packer/packer.tar.gz https://aur.archlinux.org/cgit/aur.git/snapshot/packer.tar.gz
        wget -O ${tmpDir}/packer/PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=packer
        cd ${tmpDir}/packer
        makepkg -si
        cd -
    fi
    echo -e "\n\n ... done installing packer!\n\n"
}

function linkConfigs()
{
    echo -e "\n\nLinking configuration files now."
    sleep 1

    # Home directory only accessable for this user
    chmod go-rwx ~

    # bashrc
    sudo ln -fsv ${repoPath}/bash/bashrc /etc/bash.bashrc

    # gitlab clone script
    sudo ln -fsv ${repoPath}/bash/myGitlabClone.bash ${ulbin}/myGitlabClone

    # youtube downloader :-)
    sudo ln -fsv ${repoPath}/bash/youtubedl.bash ${ulbin}/youtubedl

    # git configs
    ln -fsv ${repoPath}/git/gitconfig ~/.gitconfig
    ln -fsv ${repoPath}/git/gitignore ~/.gitignore

    # i3 - create the i3 configs
    ${repoPath}/i3/createConfig.bash

    # mcabber - create the mcabber configs
    ${repoPath}/mcabber/createConfig.bash

    # rofi
    if [[ ! ( -d ~/.local/rofi ) ]] ; then
        mkdir --mode=700 -p ~/.local/rofi
    fi
    ln -fsv ${repoPath}/rofi/config ~/.local/rofi/config

    # ssh
    if [[ ! ( -d ~/.ssh ) ]] ; then
        mkdir --mode=700 ~/.ssh
    fi
    cp -ifv ${repoPath}/ssh/config ~/.ssh/config

    echo -e "Please unencrypt the ssh config with vim."
    read -p "Do it now? [Y/n]: " decrypt

    if [[ ${decrypt} == "y" || ${decrypt} == "Y" || ${decrypt} == "" ]] ; then
        vim ~/.ssh/config
    elif
        [[ ${decrypt} == "n" || ${decrypt} == "N" ]] ; then
        echo -e "Will not touch ssh config."
        echo -e "Please decrypt it by yourself before using ssh!"
    else
        echo -e "Unrecognized entry."
    fi

    # terminator
    if [[ ! ( -d ~/.config/terminator ) ]] ; then
        mkdir --mode=700 -p ~/.config/terminator
    fi
    ln -fsv ${repoPath}/terminator/config ~/.config/terminator/config

    # termite
    if [[ ! ( -d ~/.config/termite ) ]] ; then
        mkdir --mode=700 -p ~/.config/termite
    fi
    ln -fsv ${repoPath}/termite/config ~/.config/termite/config

    # htop
    if [[ ! ( -d ~/.config/htop ) ]] ; then
        mkdir --mode=700 -p ~/.config/htop
    fi
    ln -fsv ${repoPath}/htop/htoprc ~/.config/htop/htoprc

    # mutt
    /home/${USER}/Repositories/github.com/hringriin/dotfiles/repo/mutt/create_config.bash

    # redshift
    ln -fsv ${repoPath}/redshift/redshift.conf ~/.config/redshift.conf

    # setBrightness
    sudo ln -fsv ${repoPath}/xrandr/setBrightness.bash ${ulbin}/setBrightness

    # timescript
    if [[ ! ( -d ~/TIMESCRIPT ) ]] ; then
        mkdir -m 700 ~/TIMESCRIPT
    fi
    ln -fsv ${repoPath}/TIMESCRIPT/* ~/TIMESCRIPT

    # tmux
    sudo ln -fsv ${repoPath}/tmux/tmux.conf /etc/tmux.conf

    # vim
    sudo ln -fsv ${repoPath}/vim/vimrc /etc/vimrc

    # weechat
    /home/${USER}/Repositories/github.com/hringriin/dotfiles/repo/weechat/link-files.bash

    # xorg
    ln -fsv ${repoPath}/X/Xdefaults ~/.Xdefaults
    ln -fsv ${repoPath}/X/xinitrc ~/.xinitrc

    sleep 1

    echo -e "\n\n ... done linking files!\n\n"
    sleep 2
}

function systemdServicesLink()
{
    echo -e "\n\nLinking Systemd Services ...\n\n"
    sleep 2

    # list of services
    sleep 1
    sudo cp -ifv ${repoPath}/systemd/suspend@.service /etc/systemd/system/suspend@.service
    sleep 1

    echo -e "\n\n ... done linking Systemd Services!\n\n"
    sleep 2
}

function systemdServicesEnable()
{
    echo -e "\n\nEnabling Systemd Services ...\n\n"
    sleep 1

    servicesToEnable=(
        "suspend@${USER}"
        "ntpd.service"
    )

    UserServicesToEnable=(
        #"redshift-gtk.service"
    )

    for var in "${servicesToEnable[@]}"
    do
        su -c "systemctl enable ${var}" root
    done

    unset var

    for var in "${userServicesToEnable[@]}"
    do
        systemctl --user enable ${var}
    done

    unset var

    echo -e "\n\n ... done enabling Systemd Services!\n\n"
    sleep 2
}

function systemdServicesStart()
{
    echo -e "\n\nStarting Systemd Services ...\n\n"
    sleep 2

    servicesToStart=(
        "ntpd.service"
    )

    userServicesToStart=(
        #"redshift-gtk.service"
    )

    for var in "${servicesToStart[@]}"
    do
        su -c "systemctl start ${var}" root
    done

    unset var

    for var in "${userServicesToStart[@]}"
    do
        systemctl --user start ${var}
    done

    unset var

    echo -e "\n\n ... done starting Systemd Services!\n\n"
    sleep 2
}

# first action in this script. do not touch.
archLinuxCheck

#!/bin/bash
# createConfig - creates the host specifig i3 config
# this will only work for my personal computers

prgname="I3"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

username=$(echo ${USER})

# Setting Variables
I3MAINPATH="/home/${username}/Repositories/github.com/hringriin/dotfiles/repo/i3/i3"
I3STATUSPATH="${I3MAINPATH}/../i3status"

I3MAINGLOBAL="config"                           # main config file
I3STATUSGLOBALTOP="top_bar"                     # top status bar
I3STATUSGLOBALBOTTOM="bottom_bar"               # bottom status bar

I3MAINHOST=$(echo ${HOSTNAME})                  # host specific i3 config
I3STATUSHOSTTOP="${I3MAINHOST}_top"             # host specific top status bar
I3STATUSHOSTBOTTOM="${I3MAINHOST}_bottom"       # host specific bottom status bar

HOSTMAINPATH="/home/${username}/.config/i3"     # host specific main config path
HOSTSTATUSPATH="${HOSTMAINPATH}/../i3status"    # host specific status config path

HOSTMAINCONF="config"                           # host specific main config
HOSTSTATUSCONFTOP="top_bar"                     # host specific top status bar
HOSTSTATUSCONFBOTTOM="bottom_bar"               # host specific bottom status bar

# I3Blocks
I3BLOCK="${I3MAINPATH}/../i3blocks"

# sets up i3blocks cfg
function blockscfg
{
    cp -vf ${I3BLOCK}/${HOSTNAME}_bottom ${HOME}/.config/i3blocks/
    cp -vf ${I3BLOCK}/${HOSTNAME}_top ${HOME}/.config/i3blocks/
    if [[ ! -d ${HOME}/.config/i3blocks/i3blocks-gate ]] ; then
        mkdir -p ${HOME}/.config/i3blocks/i3blocks-gate
    fi
    cp -rvf ${I3BLOCK}/i3blocks-gate/Arch-i3blocks/* ${HOME}/.config/i3blocks/i3blocks-gate
}

# Creates the host specific i3 and i3status config files
function createConfig
{
    rm -rf ${HOSTMAINPATH}/* ${HOSTSTATUSPATH}/*                                                # remove old config files
    cat ${I3MAINPATH}/${I3MAINGLOBAL} >> ${HOSTMAINPATH}/${HOSTMAINCONF}                        # main config template
    echo -e "\n\n" >> ${HOSTMAINPATH}/${HOSTMAINCONF}                                           # two empty lines
    cat ${I3MAINPATH}/${I3MAINHOST} >> ${HOSTMAINPATH}/${HOSTMAINCONF}                          # host specific template

    cat ${I3STATUSPATH}/${I3STATUSGLOBALTOP} >> ${HOSTSTATUSPATH}/${HOSTSTATUSCONFTOP}          # main i3status_top template
    echo -e "\n\n" >> ${HOSTSTATUSPATH}/${HOSTSTATUSCONFTOP}                                    # two empty lines
    cat ${I3STATUSPATH}/${I3STATUSHOSTTOP} >> ${HOSTSTATUSPATH}/${HOSTSTATUSCONFTOP}            # host specific i3status_top template

    cat ${I3STATUSPATH}/${I3STATUSGLOBALBOTTOM} >> ${HOSTSTATUSPATH}/${HOSTSTATUSCONFBOTTOM}    # main i3status_bottom template
    echo -e "\n\n" >> ${HOSTSTATUSPATH}/${HOSTSTATUSCONFBOTTOM}                                 # two empty lines
    cat ${I3STATUSPATH}/${I3STATUSHOSTBOTTOM} >> ${HOSTSTATUSPATH}/${HOSTSTATUSCONFBOTTOM}      # host specific i3status_top template
}

# checks the availability for all directories
function checkDirs
{
    echo -e "\n"

    if [[ ! -d ${HOME}/.themes ]] ; then
        mkdir -p ${HOME}/.themes
    fi

    if [[ ! ( -d ${I3MAINPATH} ) ]] ; then
        echo "Directory '${HOSTMAINPATH}' does not exist, double check the correct 'myGitlabClone' Repository-path!"
        exit 127
    fi

    if [[ ! ( -d ${I3STATUSPATH} ) ]] ; then
        echo "Directory '${HOSTSTATUSPATH}' does not exist, double check the correct 'myGitlabClone' Repository-path!"
        exit 127
    fi

    if [[ ! ( -e ${I3MAINPATH}/${I3MAINGLOBAL} ) ]] ; then
        echo "The main configuration for i3 does not exist, double check the correct 'myGitlabClone' Repository-path!"
        exit 127
    fi

    if [[ ! ( -e ${I3STATUSPATH}/${I3STATUSGLOBALTOP} ) ]] ; then
        echo "The top configuration for i3status does not exist, double check the correct 'myGitlabClone' Repository-path!"
        exit 127
    fi

    if [[ ! ( -e ${I3STATUSPATH}/${I3STATUSGLOBALBOTTOM} ) ]] ; then
        echo "The bottom configuration for i3status does not exist, double check the correct 'myGitlabClone' Repository-path!"
        exit 127
    fi

    if [[ ! ( -d ${HOSTMAINPATH} ) ]] ; then
        echo "Directory '${HOSTMAINPATH}' does not exist, it will be created"
        mkdir -p ${HOSTMAINPATH}
    else
        echo "Directory '${HOSTMAINPATH}' exists, nothing will be done."
    fi

    if [[ ! ( -d ${HOSTSTATUSPATH} ) ]] ; then
        echo "Directory '${HOSTSTATUSPATH}' does not exist, it will be created"
        mkdir -p ${HOSTSTATUSPATH}
    else
        echo "Directory '${HOSTSTATUSPATH}' exists, nothing will be done."
    fi
}

function displayConfig
{
    echo -e "\n"
    echo "Git Main Path                         :   ${I3MAINPATH}"
    echo "Git Status Path                       :   ${I3STATUSPATH}"
    echo -e "\n"
    echo "Git Main Config                       :   ${I3MAINGLOBAL}"
    echo "Git Top_Status Config                 :   ${I3STATUSGLOBALTOP}"
    echo "Git Bottom_Status Config              :   ${I3STATUSGLOBALBOTTOM}"
    echo -e "\n"
    echo "Hostname                              :   ${I3MAINHOST}"
    echo "Host Top_Status Config                :   ${I3STATUSHOSTTOP}"
    echo "Host Bottom_Status Config             :   ${I3STATUSHOSTBOTTOM}"
    echo -e "\n"
    echo "Host specific Main Path               :   ${HOSTMAINPATH}"
    echo "Host specific Status Path             :   ${HOSTSTATUSPATH}"
    echo -e "\n"
    echo "Host specific Main Config             :   ${HOSTMAINCONF}"
    echo "Host specific Top_Status Config       :   ${HOSTSTATUSCONFTOP}"
    echo "Host specifig Bottom_Status Config    :   ${HOSTSTATUSCONFBOTTOM}"
}

function writeConfigToConfig
{
    echo -e "\n"
    read -p "Write to '${HOSTMAINPATH}/${HOSTMAINCONF}' ? [Y/n] " writeToConf

    if [[ ${writeToConf} = "y" || ${writeToConf} = "Y" || ${writeToConf} = "" ]] ; then
        echo -e "\nWriting to i3 config ..."
        createConfig
        blockscfg
        echo -e " ... finished!"
    elif [[ ${writeToConf} = "n" || ${writeToConf} = "N" ]] ; then
        echo -e "\nWill not touch anything!"
    fi
}

function installGTK
{
    git clone https://github.com/tim241/dots.git ${HOME}/Repositories/github.com/tim241/dots/repo
    ln -sfv ${HOME}/Repositories/github.com/tim241/dots/repo/.themes/gruvbox-soft ${HOME}/.themes
    ln -sfv ${HOME}/Repositories/github.com/tim241/dots/repo/.icons/gruvbox-soft ${HOME}/.icons
}

checkDirs
displayConfig
writeConfigToConfig
installGTK


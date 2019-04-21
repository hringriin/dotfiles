#!/bin/bash
# create configs

prgname="MUTT"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

MUTTREPOPATH="${HOME}/Repositories/github.com/hringriin/dotfiles/repo/mutt"
MUTTPATH="${HOME}/.mutt"
PASSWDPATH="${HOME}/ownCloud/Documents/mutt"
PASSWDFILE="pwdfile.gpg"
FIRSTTIME=

# Checks if a programm is installed
checkIfExists()
{
    if [[ ! ( -f ${PASSWDPATH}/${PASSWDFILE} ) ]] ; then
        echo "Password file not present!"
        exit 2
    fi
}

copyFiles()
{
    cleanupFirst

    cp -fv ${MUTTREPOPATH}/muttrc ${HOME}/.muttrc

    mkdir -m 0700 -p ${MUTTPATH}
    mkdir -m 0700 -p ${MUTTPATH}/cache
    mkdir -m 0700 -p ${MUTTPATH}/passwords

    cp -frv ${MUTTREPOPATH}/mutt/accounts ${MUTTPATH}/
    cp -frv ${MUTTREPOPATH}/mutt/colors ${MUTTPATH}/

    cp -fv ${PASSWDPATH}/${PASSWDFILE} ${MUTTPATH}/passwords

    cp -fv ${MUTTREPOPATH}/mutt/crypt-hooks.muttrc ${MUTTPATH}/

    cp -fv ${MUTTREPOPATH}/mutt/gpg.rc ${MUTTPATH}/

    if [[ $(uname -s) == *"inux"* ]] ; then
        cp -fv ${MUTTREPOPATH}/mutt/mailcap_linux ${MUTTPATH}/mailcap
    elif [[ $(uname -s) == *"arwin"* ]] ; then
        cp -fv ${MUTTREPOPATH}/mutt/mailcap_macos ${MUTTPATH}/mailcap
        cp -fv ${MUTTREPOPATH}/mutt/mailcap_macos.bash ${MUTTPATH}/
    else
        echo "On what system are you running this script on? Aborting!"
        exit 3
    fi

    cp -fv ${MUTTREPOPATH}/mutt/sidebar.muttrc ${MUTTPATH}/
}

copyService()
{
    read -p "Do you want to copy the service files? [y/N]: " cpservice

    if [[ ${cpservice} == 'y' || ${cpservice} == 'Y' ]] ; then
        echo "Services will be copied!"
        sudo cp -fv ${MUTTREPOPATH}/../systemd/isync/* /etc/systemd/system/
    else
        echo "No service will be touched!"
    fi
}

startService()
{
    read -p "Enable service? [y/N]: " enableService
    if [[ ${enableService} == "y" || ${enableServce} == "Y" ]] ; then
        thisUser=$(echo ${USER})

        echo "Enabling service ..."
        sudo systemctl enable mbsync@${thisUser}.timer
        echo "... service enabled!"

        echo "Starting service ..."
        sudo systemctl start mbsync@${thisUser}.timer
        echo "... service started!"

        echo "Reloading systemctl daemon ..."
        sudo systemctl daemon-reload
        echo "... systemctl daemon reloaded!"
    fi
}

cleanupFirst()
{
    echo "Checking previously installed mutt configurations ..."

    if [[ -d ${MUTTPATH} ]] ; then
        rm -vrf ${MUTTPATH}
    fi
}

main()
{
    if [[ ${UID} -eq 0 ]] ; then
        echo "You're root! **Don't** start this script as root!"
        exit 4
    fi

    # check, if the password file is present
    checkIfExists

    copyFiles

    ${MUTTREPOPATH}/../isync/create_config.bash
    chmod -R og-rwx ${MUTTPATH} ${HOME}/.muttrc ${HOME}/.mbsyncrc ${HOME}/.mailfolder

    read -p "Install Systemd-Service? [y|N] " instSysSer
    if [[ ${instSysSer} == "Y" || ${instSysSer} == "y" ]] ; then
        copyService
    fi

    read -p "Start Systemd-Service? [y|N] " startSysSer
    if [[ ${startSysSer} == "Y" || ${startSysSer} == "y" ]] ; then
        startService
    fi
}



main
exit 0

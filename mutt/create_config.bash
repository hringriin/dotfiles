#!/bin/bash
# create configs

MUTTREPOPATH="/home/${USER}/Repositories/github.com/hringriin/dotfiles/repo/mutt"
MUTTPATH="/home/${USER}/.mutt"
PASSWDPATH="/home/hringriin/ownCloud/Documents/mutt"
PASSWDFILE="passwords.tar.gz.gpg"

# Checks if a programm is installed
checkIfExists()
{
    if [[ ! ( `whereis $1` > /dev/null ) ]] ; then
        echo "Programm $1 is not installed! Aborting!"
        exit 1
    fi

    if [[ ! ( -f ${PASSWDPATH}/${PASSWDFILE} ) ]] ; then
        echo "Password file not present!"
        exit 2
    fi
}

copyFiles()
{
    cp -fv ${MUTTREPOPATH}/muttrc ~/.muttrc

    mkdir -m 0700 -p ${MUTTPATH}

    cp -frv ${MUTTREPOPATH}/mutt/accounts ${MUTTPATH}/
    cp -frv ${MUTTREPOPATH}/mutt/colors ${MUTTPATH}/

    cp -fv ${PASSWDPATH}/${PASSWDFILE} ${MUTTPATH}/

    gpg --output ${MUTTPATH}/`echo ${PASSWDFILE} | cut -d '.' -f 1`.tar.gz --decrypt ${MUTTPATH}/${PASSWDFILE}
    tar -zxvf ${MUTTPATH}/`echo ${PASSWDFILE} | cut -d '.' -f 1`.tar.gz -C ${MUTTPATH}/
    rm -rf ${MUTTPATH}/${PASSWDFILE} ${MUTTPATH}/`echo ${PASSWDFILE} | cut -d '.' -f 1`.tar.gz

    cp -fv ${MUTTREPOPATH}/mutt/crypt-hooks.muttrc ${MUTTPATH}/

    cp -fv ${MUTTREPOPATH}/mutt/gpg.rc ${MUTTPATH}/

    if [[ `uname -s` == *"inux"* ]] ; then
        cp -fv ${MUTTREPOPATH}/mutt/mailcap_linux ${MUTTPATH}/mailcap
    elif [[ `uname -s` == *"arwin"* ]] ; then
        cp -fv ${MUTTREPOPATH}/mutt/mailcap_macos ${MUTTPATH}/mailcap
        cp -fv ${MUTTREPOPATH}/mutt/mailcap_macos.bash ${MUTTPATH}/
    else
        echo "On what system are you running this script on? Aborting!"
        exit 3
    fi

    cp -fv ${MUTTREPOPATH}/mutt/sidebar.muttrc ${MUTTPATH}/

    chmod -v -R og-rwx ${MUTTPATH} ~/.muttrc ~/.mbsyncrc
}

copyService()
{
    cp -fv ${MUTTREPOPATH}/../systemd/isync/* /etc/systemd/system/
}

startService()
{
    read -p "Enable service? [y/N]: " enableService
    if [[ ${enableService} == "y" || ${enableServce} == "Y" ]] ; then
        thisUser=`echo ${USER}`

        echo "Enabling service ..."
        #su -c "systemctl enable mbsync@${USER}.timer" root
        sudo systemctl enable mbsync@${thisUser}.timer
        echo "... service enabled!"

        echo "Starting service ..."
        #su -c "systemctl start mbsync@${USER}.timer" root
        sudo systemctl start mbsync@${thisUser}.timer
        echo "... service started!"

        echo "Reloading systemctl daemon ..."
        #su -c "systemctl daemon-reload" root
        sudo systemctl daemon-reload
        echo "... systemctl daemon reloaded!"
    fi
}

main()
{
    if [[ ${UID} == 0 ]] ;
        echo "You're root! Don't start this script as root!"
        exit 4
    fi

    checkIfExists owncloud
    checkIfExists mutt
    checkIfExists isync
    copyFiles

    ${MUTTREPOPATH}/../isync/create_config.bash

    copyService
    startService
}

main
exit 0

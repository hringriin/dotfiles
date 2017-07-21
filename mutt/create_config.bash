#!/bin/bash
# create configs

MUTTREPOPATH="/home/${USER}/Repositories/github.com/hringriin/dotfiles/repo/mutt"
MUTTPATH="/home/${USER}/.mutt"
PASSWDPATH="/home/hringriin/ownCloud/Documents/mutt"
PASSWDFILE="passwords.tar.gz.gpg"
FIRSTTIME=

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

}

copyService()
{
    sudo cp -fv ${MUTTREPOPATH}/../systemd/isync/* /etc/systemd/system/
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


checkFirstTime()
{
    if [[ ! ( -d ~/.mailfolder ) ]] ; then
        echo -e "#########################################"
        echo -e "#########################################"
        echo -e "### ATTENTION PLEASE | READ CAREFULLY ###"
        echo -e "### ATTENTION PLEASE | READ CAREFULLY ###"
        echo -e "#########################################"
        echo -e "#########################################\n\n"
        echo "Your ~/.mailfolder does not exist. Don't worry, it will be created."
        echo "This script will perform a first time sync."
        echo "PLEASE DO NOT ABORT THIS SCRIPT FROM THIS POINT OR DISCONNECT YOUR INTERNET CONNECTION!"
        echo "Otherwise, you have to perform the sync by yourself BEFORE STARTING THE SYSTEMD-SERVICES or you could risk data loss!"
        echo -e "\nYou have been warned!\n"
        echo -e "#########################################"

        realyContinue
        FIRSTTIME=true

    fi
}

realyContinue()
{
    read -p "Really continue? [y/n]: " realyContinue
    if [[ ${realyContinue} == "y" || ${realyContinue} == "Y" ]] ; then
        echo "Ok! Continuing."
        echo "DO NOT STOP/ABORT THIS SCRIPT OR YOUR INTERNET CONNECTION!"
    elif [[ ${realyContinue} == "n" || ${realyContinue} == "N" ]] ; then
        echo "Ok, stopping here."
        echo "Please manually set your ~/.mailfolder according to your needs and rerun this script!"
        exit 5
    else
        echo -e "Unreadable input!\n\n"
        realyContinue
    fi
}

main()
{
    if [[ ${UID} -eq 0 ]] ; then
        echo "You're root! Don't start this script as root!"
        exit 4
    fi

    checkIfExists owncloud
    checkIfExists mutt
    checkIfExists isync
    copyFiles

    checkFirstTime

    ${MUTTREPOPATH}/../isync/create_config.bash
    chmod -v -R og-rwx ${MUTTPATH} ~/.muttrc ~/.mbsyncrc

    if [[ ${FIRSTTIME} ]] ; then
        mbsync -aV
        echo -e "\n\nSync done!"
        echo -e "Note, this information does not state, whether the sync was successful or not!"
    fi

    copyService
    startService
}

main
exit 0

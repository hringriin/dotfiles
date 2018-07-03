#!/bin/bash
# create configs

prgname="MUTT"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

MUTTREPOPATH="${HOME}/Repositories/github.com/hringriin/dotfiles/repo/mutt"
MUTTPATH="${HOME}/.mutt"
PASSWDPATH="${HOME}/ownCloud/Documents/mutt"
PASSWDFILE="passwords.tar.gz.gpg"
FIRSTTIME=

# Checks if a programm is installed
checkIfExists()
{
    if [[ ! ( $(whereis $1) > /dev/null ) ]] ; then
        echo "Programm $1 is not installed! Aborting!"
        exit 1
    fi

    if [[ ! ( -f ${PASSWDPATH}/${PASSWDFILE} ) ]] ; then
        echo "Password file not present!"
        exit 2
    fi
}

copyGPG()
{
    gpg --output ${MUTTPATH}/$(echo ${PASSWDFILE} | cut -d '.' -f 1).tar.gz --decrypt ${MUTTPATH}/${PASSWDFILE}
    tar -zxvf ${MUTTPATH}/$(echo ${PASSWDFILE} | cut -d '.' -f 1).tar.gz -C ${MUTTPATH}/
    rm -rf ${MUTTPATH}/${PASSWDFILE} ${MUTTPATH}/$(echo ${PASSWDFILE} | cut -d '.' -f 1).tar.gz
}

copyFiles()
{
    onlycfg=

    read -p "Install mutt config only? [Y|n] " muttcfgonly
    if [[ ${muttcfgonly} == "N" || ${muttcfgonly} == "n" ]] ; then
        onlycfg=0
        cleanupFirst
    elif [[ ${muttcfgonly} == "Y" || ${muttcfgonly} == "y" || ${muttcfgonly} == "" ]] ; then
        onlycfg=1
    elif [[ ${muttcfgonly} == "q" ]] ; then
        exit 0
    else
        echo "Unrecognized, trying again (abort with 'q')."
        copyFiles
    fi

    cp -fv ${MUTTREPOPATH}/muttrc ${HOME}/.muttrc

    mkdir -m 0700 -p ${MUTTPATH}

    cp -frv ${MUTTREPOPATH}/mutt/accounts ${MUTTPATH}/
    cp -frv ${MUTTREPOPATH}/mutt/colors ${MUTTPATH}/

    cp -fv ${PASSWDPATH}/${PASSWDFILE} ${MUTTPATH}/

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

    if [[ ${onlycfg} -eq 1 ]] ; then
        echo "Finished!"
        exit 0
    elif [[ ${onlycfg} -eq 0 ]] ; then
        echo "Ok, full install"
    else
        echo "What?!"
        exit 7
    fi


    read -p "Do you want to copy all the pgp keys? [y/N]: " copyGPG
    if [[ ${copyGPG} == 'y' || ${copyGPG} == 'Y' ]] ; then
        echo "GPG Keys will be copied!"
        copyGPG
    else
        echo "GPG Keys will NOT be copied!"
        echo "isync Script will not work this way, aborting ..."
        exit 6
    fi

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


checkFirstTime()
{
    if [[ ! ( -d ${HOME}/.mailfolder ) ]] ; then
        FIRSTTIME=true
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
        echo "You're root! **Don't** start this script as root!"
        exit 4
    fi

    if [[ $(uname -s) == *"arwin"* ]] ; then
        sleep 1
    elif [[ $(uname -s) == *"inux"* ]] ; then
        checkIfExists owncloud
        checkIfExists mutt
        checkIfExists isync
    fi

    copyFiles

    checkFirstTime

    ${MUTTREPOPATH}/../isync/create_config.bash
    chmod -R og-rwx ${MUTTPATH} ${HOME}/.muttrc ${HOME}/.mbsyncrc ${HOME}/.mailfolder

    if [[ ${FIRSTTIME} ]] ; then
        mbsync -aV
        echo -e "\n\nSync done!"
        echo -e "Note, this information does not state, whether the sync was successful or not!"
    fi

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

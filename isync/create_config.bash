#!/bin/bash
# create isync config

prgname="ISYNC/MBSYNC"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

if [[ $(uname -s) == *"arwin"* ]] ; then
    echo -e "You're running MacOs ..."
    echo -e "Sorry, you're screwed, the following part does not work on MacOs."
    echo -e "This is not by design, I actually have no clue why."
    exit 0
fi

MBSYNCREPOPATH="${HOME}/Repositories/github.com/hringriin/dotfiles/repo/isync"
#PASSWDPATH="${HOME}/Repositories/github.com/hringriin/dotfiles/mutt/passwords"
PASSWDPATH="${HOME}/.mutt/passwords"
MBSYNCFILE="${HOME}/.mbsyncrc"
TMPFILE="${HOME}/mbsyncrc-tmp"

insertPasswd()
{
    echo -e "Writing password for \e[1;35m$1\e[0m ..."

    # using filename (f) to cat the passwords from the password file
    PWD=$(cat $2 | cut -d '=' -f 2 | sed -e 's/\s*//')

    # using the filename (fdname) to insert the password into the mbsyncrc (via tmp files)
    sed -e 's/"password.'$1'"/'${PWD}'/g' ${MBSYNCFILE} &> ${TMPFILE}

    # via swap copy the new content to the mbsyncrc (dreieckstausch)
    cp -rf ${TMPFILE} ${MBSYNCFILE}

    # remove tmp files
    rm -rf ${TMPFILE}
}

main()
{
    cp -f ${MBSYNCREPOPATH}/mbsyncrc ${HOME}/.mbsyncrc

    for f in ${HOME}/.mutt/passwords/*
    do
        # stripping everything before and including the string "password." from the filename ${f}
        fdname=$(echo ${f} | sed -e 's/.*\/\w*\.//')

        # making a directory with the new fdname in the mailfolder
        # this won't touch anything, if the directory is present
        mkdir -m 0700 -p ${HOME}/.mailfolder/${fdname}

        # calling the function insertpasswd with the fdname and the absolute path + filename
        insertPasswd ${fdname} ${f}
    done

    # linking the script to create mailbox folders
    sudo ln -fsv ${MBSYNCREPOPATH}/scripts/createFolderInMailbox.bash /usr/local/bin/createFolderInMailbox
}

main
exit 0

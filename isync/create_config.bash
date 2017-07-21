#!/bin/bash
# create config

MBSYNCREPOPATH="/home/${USER}/Repositories/github.com/hringriin/dotfiles/repo/isync"
#PASSWDPATH="/home/${USER}/Repositories/github.com/hringriin/dotfiles/mutt/passwords"
PASSWDPATH="/home/${USER}/.mutt/passwords"
MBSYNCFILE="/home/${USER}/.mbsyncrc"
TMPFILE="/home/${USER}/mbsyncrc-tmp"

insertPasswd()
{
    PWD=`cat $2 | cut -d '=' -f 2 | sed -e 's/\s*//'`
    sed -e '/User '"$1"'/ a '"Pass ${PWD}"'' ${MBSYNCFILE} &> ${TMPFILE}
    cp -rf ${TMPFILE} ${MBSYNCFILE}
    rm -rf ${TMPFILE}
}

main()
{
    cp -f ${MBSYNCREPOPATH}/mbsyncrc ~/.mbsyncrc

    for f in ~/.mutt/passwords/*
    do
        fname=`echo ${f} | sed -e 's/.*\/\w*\.\w*\.\w*[\-]*\w*\.//'`
        fdname=`echo ${f} | sed -e 's/.*\/\w*\.//'`
        mkdir -m 0700 -p ~/.mailfolder/${fdname}
        #insertPasswd `echo ${fname} | sed -e 's/account\.\w*\.\w*\.//' -f 2` ${f}
        insertPasswd ${fname} ${f}
    done
}

main

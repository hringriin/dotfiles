#!/bin/bash
# create config

PREFIX=

if [[ `uname -s` == *"arwin"* ]] ; then
    PREFIX="/Users/${USER}"
elif [[ `uname -s` == *"inux"* ]] ; then
    PREFIX="/home/${USER}"
fi

MBSYNCREPOPATH="${PREFIX}/Repositories/github.com/hringriin/dotfiles/repo/isync"
#PASSWDPATH="${PREFIX}/Repositories/github.com/hringriin/dotfiles/mutt/passwords"
PASSWDPATH="${PREFIX}/.mutt/passwords"
MBSYNCFILE="${PREFIX}/.mbsyncrc"
TMPFILE="${PREFIX}/mbsyncrc-tmp"

insertPasswd()
{
    PWD=`cat $2 | cut -d '=' -f 2 | sed -e 's/\s*//'`
    sed -e '/User '"$1"'/ a '"Pass ${PWD}"'' ${MBSYNCFILE} &> ${TMPFILE}
    cp -rf ${TMPFILE} ${MBSYNCFILE}
    rm -rf ${TMPFILE}
}

main()
{
    cp -f ${MBSYNCREPOPATH}/mbsyncrc ${PREFIX}/.mbsyncrc

    for f in ${PREFIX}/.mutt/passwords/*
    do
        fname=`echo ${f} | sed -e 's/.*\/\w*\.\w*\.\w*[\-]*\w*\.//'`
        fdname=`echo ${f} | sed -e 's/.*\/\w*\.//'`
        mkdir -m 0700 -p ${PREFIX}/.mailfolder/${fdname}
        insertPasswd ${fname} ${f}
    done
}

main
exit 0

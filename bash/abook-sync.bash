#!/bin/bash
# abook-sync
# This script "synchronizes" my abook addressbooks ... sort of ...
# The problem with abook is, that it rewrites the addressbook file instead of editing it,
# this behaviour makes (sym)links useless, which would actually work, because abook can
# read addressbooks which are only symlinks.
#
# This script will take my main machine as source and copy its addressbook to my cloud.
# All other machines are slaves and only read those files and import them.
#
# Maybe I can later improve this, but for now it solves two problems:
#   - backup
#   - addressbook on my other machines


function master()
{
    cp -vf ~/.abook/addressbook ~/ownCloud/Documents/abook/
}

function slave()
{
    rm -vrf ~/.abook/*
    cp -vf ~/ownCloud/Documents/abook/addressbook ~/.abook/
}

if [[ $1 == "slave" ]] ; then
    slave
elif [[ $1 == "master" ]] ; then
    master
else
    echo -e "----------------------------------------------------------------------"
    echo -e "\tUsage:"
    echo -e "\t\t./abook-sync.bash master       Copy files TO cloud"
    echo -e "\t\t./abook-sync.bash slave        Copy files FROM cloud"
    echo -e "----------------------------------------------------------------------"
    exit 1
fi

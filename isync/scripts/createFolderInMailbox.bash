#!/bin/bash

# This script will create a new folder in an existing mailbox.

# Main mailbox folder
MAILBOX="~/.mailfolder"

# Dialogbox measures
HEIGHT=0
WIDTH=0

# Name of the new folder
NAME=""

# Path of the folder in which the new folder will be created
MBPath=""

getName ()
{
    dialog --backtitle "by hringriin" \
        --radiolist "Infotext" ${HEIGHT} ${WIDTH} 0 \
        60 "HOME FB3" off \
        70 "WWW FB3" off \
        90 "Enter custom connection" off 2>$_tmp


    ## NOTES
    # dialog --menu
    # echo ${exarray[@]}      all values
    # echo ${#exarray[@]}     length of list
    # echo ${exarray[0]}      first element
    # echo ${exarray[41]}     last element, if @=42
}

writeDir ()
{
}

getMailbox ()
{
}

main ()
{
    #getName
    #getMailbox
    #writeDir
}

#main
exit 0

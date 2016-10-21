#!/bin/bash
# mountWindowsShare - Mount windows share to given ip address

_tmp="/tmp/answer.$$"


# ip addresses
vanthIP="192.168.2.25"
fb3="x10.informatik.uni-bremen.de"

# users
defaultuser="hringriin"
fb3User="jkoester"


function cleanUp() {
    rm $_tmp
}

function mountIt() {

    if [ ! -d $mountDev ]; then
        sudo mkdir -p $mountDev
    fi

    if [ -z $domain ]; then
        sudo mount -t $vfstype //$ipaddr/$share/ $mountDev -o user=$username
    else
        sudo mount -t $vfstype //$ipaddr/$share/ $mountDev -o user=$username,domain=$domain
    fi

    cleanUp
    exit 0

}

function mountItUnix() {

    if [ ! -d $mountDev ]; then
        sudo mkdir -p $mountDev
    fi

    sudo mount -t $vfstype $username@$ipaddr:$share $mountDev

    cleanUp
    exit 0
}


dialog --backtitle "by hringriin" \
    --radiolist "Tag preselected shares or define new to mount it. \n\nMove using [UP], [DOWN], [SPACE] to select and [ENTER] to confirm your choice!" 0 0 0 \
        10 "X-Change on Skynd with hringriin" on \
        20 "C: on Skynd with hringriin" off \
        30 "D: on Skynd with hringriin" off \
        40 "E: on Skynd with hringriin" off \
        50 "F: on Skynd with hringriin" off \
        60 "HOME FB3" off \
        70 "WWW FB3" off \
        90 "Enter custom connection" off 2>$_tmp


    e=$(grep -c "10" "$_tmp")
        if [ $e -gt 0 ]; then
            ipaddr=$vanthIP
            share="X-Change"
            mountDev="/media/Skynd/X-Change/"
            username="$defaultuser"
            vfstype="cifs"

            mountIt
        fi

    e=$(grep -c "20" "$_tmp")
        if [ $e -gt 0 ]; then
            ipaddr=$vanthIP
            share="C$"
            mountDev="/media/Skynd/C"
            username="$defaultuser"
            vfstype="cifs"

            mountIt
        fi

    e=$(grep -c "30" "$_tmp")
        if [ $e -gt 0 ]; then
            ipaddr=$vanthIP
            share="D$"
            mountDev="/media/Skynd/D"
            username="$defaultuser"
            vfstype="cifs"

            mountIt
        fi

    e=$(grep -c "40" "$_tmp")
        if [ $e -gt 0 ]; then
            ipaddr=$vanthIP
            share="E$"
            mountDev="/media/Skynd/E"
            username="$defaultuser"
            vfstype="cifs"

            mountIt
        fi

    e=$(grep -c "50" "$_tmp")
        if [ $e -gt 0 ]; then
            ipaddr=$vanthIP
            share="F$"
            mountDev="/media/Skynd/F"
            username="$defaultuser"
            vfstype="cifs"

            mountIt
        fi

    e=$(grep -c "60" "$_tmp")
        if [ $e -gt 0 ]; then
            ipaddr=$fb3
            share="/home/jkoester/"
            mountDev="/media/fb3/home/"
            username=$fb3User
            vfstype="nfs4"

            mountItUnix
        fi

    e=$(grep -c "70" "$_tmp")
        if [ $e -gt 0 ]; then
            ipaddr=$fb3
            share="/home/wwwuser/jkoester"
            mountDev="/media/fb3/WWW"
            username=$fb3User
            vfstype="nfs4"

            mountItUnix
        fi

    e=$(grep -c "90" "$_tmp")
        if [ $e -gt 0 ]; then
            echo "This script will mount a Windows share of the given IP-Address to the given place on your disc."
            echo "Please enter the IP-Address of the host you want to connect to:"
            read -p ">> " ipaddr
            echo "Please enter the name of the shared directory of host $ipaddr :"
            read -p ">> " share
            echo "Please enter the FULL PATH (!) (like /home/john/tmp/ or /media/tmp/) of the directory you want the windows share $share to be mounted on. If the directory is not present, it will be created:"
            read -p ">> " mountDev
            echo "Please enter your user name for the specified Windows share:"
            read -p ">> " username
            echo "[OPTIONAL] Please enter your preferred domain: "
            read -p ">> " domain
            echo "Please enter the vfstype! (Samba: cifs)"
            read -p ">> " vfstype

            mountIt
        fi

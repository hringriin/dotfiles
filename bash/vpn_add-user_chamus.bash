#!/bin/bash
# vpn_add-user_chamus - adds a user to the vpn and packs some files

config=""
confDir="userconfigs"
useDefault="y"
confZips="confZips"

if [[ ${UID} != 0 ]] ; then
    echo "You are not root!"
    exit 127
fi

cd /etc/openvpn/easy-rsa/
source ./vars

read -p "Use default vpn client configuration file? [Y/n]: " defaultConfig

if [[ ${defaultConfig} == "y" || ${defaultConfig} == "Y" || ${defaultConfig} == "" ]] ; then
    config="default"
else
    read -p "Please provide the config file name! " configFileName
    if [[ ${configFileName} == "" ]] ; then
        echo "Config File name must not be empty!"
        exit 127
    fi
    config=${configFileName}
fi

read -p "Enter vpn username, not necessarily equal to conf file: " keyUsername

if [[ ${keyUsername} == "" ]] ; then
    echo "Username must not be empty!"
    exit 127
fi

./build-key  ${keyUsername}

cd keys

echo -n "Choose Password for tar ball! Leave empty for no password: "
read -s password

if [[ ${password} == "" ]] ; then
    zip -j niederhoelle.no-ip.biz_vpn_${keyUsername}.zip ca.crt ${keyUsername}.crt ${keyusername}.key ../${confDir}/${config}.ovpn
else
    zip -j --encrypt -P ${password} niederhoelle.no-ip.biz_vpn_${keyUsername}.zip ca.crt ${keyUsername}.crt ${keyUsername}.key ../${confDir}/${config}.ovpn
fi

cd ..

mv -i keys/niederhoelle.no-ip.biz_vpn_${keyUsername}.zip ${confZips}/

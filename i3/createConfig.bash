#!/bin/bash
# createConfig - creates the host specifig i3 config
# this will only work for my personal computers

REPOPATH="/home/hringriin/Repositories/github.com/hringriin/dotfiles/repo/i3/i3"
I3GLOBAL="config"
I3HOST=`echo ${HOSTNAME}`
HOSTCONF="/home/hringriin/.config/i3/conf"

echo "Repository path                       : ${REPOPATH}"
echo "I3 global config                      : ${I3GLOBAL}"
echo "I3 host specifig config               : ${I3HOST}"
echo "I3 final i3 config for specifig host  : ${HOSTCONF}"

echo -e "\n"
read -p "Write to ${HOSTCONF} ? [Y/n] " writeToConf

if [[ ${writeToConf} = "y" || ${writeToConf} = "Y" || ${writeToConf} = "" ]] ; then
    echo -e "\nWriting to config ..."
    rm -f ${HOSTCONF}
    cat ${REPOPATH}/${I3GLOBAL} >> ${HOSTCONF}
    echo -e "\n\n" >> ${HOSTCONF}
    cat ${REPOPATH}/${I3HOST} >> ${HOSTCONF}
    echo -e " ... finished!"
elif [[ ${writeToConf} = "n" || ${writeToConf} = "N" ]] ; then
    echo -e "\nWill not touch anything!"
fi

#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="VARIETY"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash
source INSTALL_ALL/yay.bash
source INSTALL_ALL/pacman.bash

varietyFolder="${HOME}/.config/variety"
scriptFolder="${HOME}/.config/variety/scripts"

main()
{
    if [[ ! -d ${varietyFolder} ]] ; then
        mkdir -p ${varietyFolder}
    fi

    ln -sfv ${repoPath}/variety/ui.conf ${varietyFolder}/ui.conf
    ln -sfv ${repoPath}/variety/variety.conf ${varietyFolder}/variety.conf

    if [[ -e ${scriptFolder} ]] ; then
        echo -e "\e[1;36mPrepare to compare the scripts!\e[0m"
        sleep 1
        echo "..."
        sleep 1
        echo "..."
        sleep 1
        echo "..."
        sleep 2

        vimdiff ${repoPath}/variety/set_wallpaper ${scriptFolder}/set_wallpaper
        echo -e "Which version of \e[1;36mset_wallpaper\e[0m do you want to keep, the repository's version or the local one?"
        read -p "[L]ocal | [R]epository | [A]bort " setwp
        if [[ ${setwp} == "l" || ${setwp} == "L" ]] ; then
            echo -e "Ok, copying from ${scriptFolder} to ${repoPath}"
            cp ${scriptFolder}/set_wallpaper ${repoPath}/variety/set_wallpaper
        elif [[ ${setwp} == "r" || ${setwp} == "R" ]] ; then
            echo -e "Ok, copying from ${repoPath} to ${scriptFolder}"
            cp ${repoPath}/variety/set_wallpaper ${scriptFolder}/set_wallpaper
        elif [[ ${setwp} == "a" || ${setwp} == "A" ]] ; then
            echo "Ok, aborting"
        else
            echo "Could not understand, rerunning script!"
            main
        fi

        vimdiff ${repoPath}/variety/get_wallpaper ${scriptFolder}/get_wallpaper
        echo -e "Which version of \e[1;36mget_wallpaper\e[0m do you want to keep, the repository's version or the local one?"
        read -p "[L]ocal | [R]epository | [A]bort " getwp
        if [[ ${getwp} == "l" || ${getwp} == "L" ]] ; then
            echo -e "Ok, copying from ${scriptFolder} to ${repoPath}"
            cp ${scriptFolder}/get_wallpaper ${repoPath}/variety/get_wallpaper
        elif [[ ${getwp} == "r" || ${getwp} == "R" ]] ; then
            echo -e "Ok, copying from ${repoPath} to ${scriptFolder}"
            cp ${repoPath}/variety/get_wallpaper ${scriptFolder}/get_wallpaper
        elif [[ ${getwp} == "a" || ${getwp} == "A" ]] ; then
            echo "Ok, aborting"
        else
            echo "Could not understand, rerunning script!"
            main
        fi
    else
        mkdir -p ${scriptFolder}
        cp -vf ${repoPath}/variety/set_wallpaper ${scriptFolder}
        cp -vf ${repoPath}/variety/get_wallpaper ${scriptFolder}
    fi
}

main
exit 0

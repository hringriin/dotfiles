#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="tider"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    case $1 in
        "inst")
            if [[ ! -d ${HOME}/.config/tider ]] ; then
                mkdir -p ${HOME}/.config/tider
            fi
            cp -v ${repoPath}/tider/config.py ${HOME}/.config/tider/
            ;;
        "db-backup")
            cp -v ${HOME}/.config/tider/log.db ${HOME}/ownCloud/Documents/tider/log.db/
            ;;

        "db-restore")
            cp -iv ${HOME}/ownCloud/Documents/tider/log.db ${HOME}/.config/tider/log.db/
            ;;
        *)
            echo "Unrecognized command, doing nothing."
            ;;
    esac
}

main $1
exit 0

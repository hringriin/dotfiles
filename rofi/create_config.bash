#!/bin/bash
# create_config for -- <<PROGNAME>>

prgname="ROFI"

echo -e "\e[1;36mInstalling ... ${prgname} ... configuration files ...\e[0m"
sleep 1

source INSTALL_ALL/config.bash

main()
{
    if [[ ! ( -d ~/.local/rofi ) ]] ; then
        mkdir --mode=700 -p ~/.local/rofi
    fi
    ln -fsv ${repoPath}/rofi/config ~/.local/rofi/config
}

main
exit 0

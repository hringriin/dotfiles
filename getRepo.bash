#!/bin/bash
# getRepo - get This Repo

#colors
RED='\033[1;31m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RESET='\033[0m'
CYAN='\033[1;36m'


cloneIt ()
{
    if [[ $1 == "SSH" ]] ; then
        git clone git@github.com:hringriin/dotfiles.git ~/Repositories/github.com/hringriin/dotfiles/repo/
        exit 0
    elif [[ $1 == "HTTPS" ]] ; then
        git clone https://github.com/hringriin/dotfiles.git ~/Repositories/github.com/hringriin/dotfiles/repo/
        exit 0
    fi
}

main ()
{
    echo -e "Do you want to ${YELLOW}clone${RESET} the repository via ${GREEN}SSH${RESET} or ${RED}HTTPS${RESET}?"
    echo -e "[ ${GREEN}[S]${RESET}SH | ${RED}[H]${RESET}TTPS | ${CYAN}[Q]${RESET}uit ]"
    read -p ">> " choice

    if [[ ${choice} == "S" || ${choice} == "s" ]] ; then
        cloneIt SSH
    elif [[ ${choice} == "H" || ${choice} == "h" ]] ; then
        cloneIt HTTPS
    elif [[ ${choice} == "Q" || ${choice} == "q" ]] ; then
        exit 0
    else
        echo "Cannot read input, retry"
        main
    fi
}

main
exit 0

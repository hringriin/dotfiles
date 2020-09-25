#!/bin/bash
# install_all_config.bash
# This is just for configuration!

# temporary files
tmpDir="/tmp"                                                               # temp dir
tmp1="neededProgrammesPACMAN$$"                                             # temp file for evaluation of needed programmes by pacman
tmp2="neededProgrammesYAY$$"                                                # temp file for evaluation of needed programmes by yay
tmp3="sudoers"                                                              # temp file for evaluation of member of sudoers
missingPacmanPrg=0                                                          # boolean; 0: all installed; 1: one or more programmes missing
missingYayPrg=0                                                             # boolean; 0: all installed; 1: one or more programmes missing
missingPacmanList="missingPacmanList$$"                                     # list of missing programmes (pacman)
missingYayList="missingYayList$$"                                           # list of missing programmes (yay)
packerList=()                                                               # empty array to write in
repoPath="${HOME}/Repositories/github.com/hringriin/dotfiles/repo"          # path of the repository
ulbin="/usr/local/bin"
DISTRIBUTION=

# is it arch or ubuntu or mac os?
if [[ $(uname -s) == *"arwin"* ]] ; then
    DISTRIBUTION="MAC"
elif [[ $(uname -s) == *"inux"* ]] ; then
    if [[ -x /usr/bin/lsb_release ]] ; then
        DISTRIBUTION=$(/usr/bin/lsb_release -si)
    else
        echo " ERROR ; UNSUPPORTED LINUX DISTRIBUTION ! "
        exit 127
    fi
else
    echo " ERROR ; UNSUPPORTED OPERATING SYSTEM ! "
    exit 127
fi

check_installed ()
{
    if [[ $(command -v $1) == "" ]] ; then
        echo 0
    else
        echo 1
    fi
}

check_symlink ()
{
    if [[ $(file -ib $1 | awk '{ print $1 }') != "inode/symlink;" ]] ; then
        echo "false"
    else
        echo "true"
    fi
}

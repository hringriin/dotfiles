#!/bin/bash
# launch-shell

myShell=

# select an available (installed) terminal emulator
function selShell ()
{
    if [[ $(command -v st) > /dev/null ]] ; then
        myShell=st
    elif [[ $(command -v termite) > /dev/null ]] ; then
        myShell=termite
    elif [[ $(command -v terminator) > /dev/null ]] ; then
        myShell=terminator
    elif [[ $(command -v tilix) > /dev/null ]] ; then
        myShell=tilix
    elif [[ $(command -v xterm) > /dev/null ]] ; then
        myShell=xterm
    else
        exit 1
    fi
}

# start either just the emulator or the emulator calling the tmuxinator-script
function startShell ()
{
    if [[ $(tmux ls | grep main | grep attached) == "" ]] ; then
        ${myShell} -e ~/Repositories/github.com/hringriin/dotfiles/repo/tmux/script.d/launch-tmux.bash myShell
    else
        ${myShell}
    fi
}

# start the filemanager
function startFm ()
{
    if [[ $(tmux ls | grep ranger | grep attached) == "" ]] ; then
        ${myShell} -e ~/Repositories/github.com/hringriin/dotfiles/repo/tmux/script.d/launch-tmux.bash ranger
    else
        ${myShell} -e ranger
    fi
}


# if the first parameter was "term", start a terminal, if it was "fb" start ranger (filemanager)
function main ()
{
    if [[ $1 == "term" ]] ; then
        selShell
        startShell
    elif [[ $1 == "fm" ]] ; then
        selShell
        startFm
    else
        exit 2
    fi
}

main $1
exit 0

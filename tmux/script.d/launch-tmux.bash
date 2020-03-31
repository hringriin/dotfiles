#!/bin/bash
# launch-tmux

# If the tmuxinator session 'main' is either not running or not attached the
# session will be started or attached via tmuxinator start. If the session
# exists and is attached, a new nameless tmux session will be started.


muxPath=

# check, if the path exists (tmuxinator is installed) and set the variable
# muxPath respectively
if [[ -e ${HOME}/.gem/ruby/2.7.0/bin/tmuxinator ]] ; then
    muxPath="${HOME}/.gem/ruby/2.7.0/bin/tmuxinator"
elif [[ -e /usr/local/bin/tmuxinator ]] ; then
    muxPath="/usr/local/bin/tmuxinator"
else
    if [[ $(command -v tmuxinator) > /dev/null ]] ; then
        muxPath=$(whereis tmuxinator | awk '{print $2}')
    fi
fi

startMyShell ()
{
    # start either the main tmux-session or just the terminal
    if [[ ${HOSTNAME} == "lulila" || ${HOST} == "lulila" ]] ; then
        ${muxPath} start main-lulila
    elif [[ ${HOSTNAME} == "sorth" || ${HOST} == "sorth" ]] ; then
        ${muxPath} start main-sorth
    else
        ${muxPath} start main
    fi
}

startRanger ()
{
    # start ranger
    ${muxPath} start ranger
}


if [[ $1 == "ranger" ]] ; then
    startRanger
elif [[ $1 == "myShell" ]] ; then
    startMyShell
fi

exit 0

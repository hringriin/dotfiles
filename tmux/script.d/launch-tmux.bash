#!/bin/bash
# launch-tmux

# If the tmuxinator session 'main' is either not running or not attached the
# session will be started or attached via tmuxinator start. If the session
# exists and is attached, a new nameless tmux session will be started.

if [[ $(tmux ls | grep main | grep attached) == "" ]] ; then
    ${HOME}/.gem/ruby/2.5.0/bin/tmuxinator start main
else
    tmux new-session
fi


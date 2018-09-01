#!/bin/bash
# launch-shell

if [[ $(tmux ls | grep main | grep attached) == "" ]] ; then
    termite -e ~/Repositories/github.com/hringriin/dotfiles/repo/tmux/script.d/launch-tmux.bash
else
    termite
fi

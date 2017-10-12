# Aliases and Functions
local userpath=""
if [[ `uname -a` == *"inux"* ]] ; then
    userpath="/home/${USER}"
elif [[ `uname -a` == *"arwin"* ]] ; then
    userpath="/Users/${USER}"
else
    echo "running shit"
fi

source ${userpath}/Repositories/github.com/hringriin/dotfiles/repo/bash/bashrc.d/aliases
source ${userpath}/Repositories/github.com/hringriin/dotfiles/repo/bash/bashrc.d/functions

# Editor
export EDITOR=vim
export VISUAL=vim

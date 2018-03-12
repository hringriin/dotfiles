# Generic paths seem to work fine, even on MacOS
source ~/Repositories/github.com/hringriin/dotfiles/repo/bash/bashrc.d/aliases
source ~/Repositories/github.com/hringriin/dotfiles/repo/bash/bashrc.d/functions

# Editor
export EDITOR=vim
export VISUAL=vim

# Homebrew token
if [[ -e ~/.github-homebrew-token ]] ; then
    source ~/.github-homebrew-token
fi

# MACOS shit ...
if [[ `uname -a` == *"arwin"* ]] ; then
    alias 'vim'='/usr/local/Cellar/vim/8.0.1553_2/bin/vim'
fi

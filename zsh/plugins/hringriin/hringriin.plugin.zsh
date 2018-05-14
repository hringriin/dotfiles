# vim: ft=sh
# Generic paths seem to work fine, even on MacOS
source ${HOME}/Repositories/github.com/hringriin/dotfiles/repo/bash/bashrc.d/aliases
source ${HOME}/Repositories/github.com/hringriin/dotfiles/repo/bash/bashrc.d/functions
tmuxi="${HOME}/Repositories/github.com/hringriin/dotfiles/repo/tmux/tmuxinator"

# Editor
export EDITOR=vim
export VISUAL=vim

# Homebrew token
if [[ -e ${HOME}/.github-homebrew-token ]] ; then
    source ${HOME}/.github-homebrew-token
fi

# tmuxinator
if [[ -d /home/hringriin/.gem/ruby/2.5.0/bin ]] ; then
    # adding ruby bin to path variable
    export PATH=/home/hringriin/.gem/ruby/2.5.0/bin:${PATH}
fi

if [[ -e ${tmuxi}/completion/tmuxinator.zsh ]] ; then
    # sourcing tmuxinator completion
    source ${tmuxi}/completion/tmuxinator.zsh
fi

# alises vor zsh autocorrection. sometimes it this is seriously p*** me off.
alias 'cd ...'='nocorrect cd ../..'
alias 'tmux'='nocorrect tmux'

# MACOS shit ...
if [[ `uname -a` == *"arwin"* ]] ; then
    alias 'vim'='/usr/local/Cellar/vim/8.0.1553_2/bin/vim'
fi

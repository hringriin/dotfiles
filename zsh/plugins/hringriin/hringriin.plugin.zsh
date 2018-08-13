# vim: ft=sh

# Generic paths seem to work fine, even on MacOS {{{
source ${HOME}/Repositories/github.com/hringriin/dotfiles/repo/bash/bashrc.d/aliases
source ${HOME}/Repositories/github.com/hringriin/dotfiles/repo/bash/bashrc.d/functions
tmuxi="${HOME}/Repositories/github.com/hringriin/dotfiles/repo/tmux/tmuxinator"
# Generic paths seem to work fine, even on MacOS }}}

# Editor {{{
export EDITOR=vim
export VISUAL=vim
# Editor }}}

# Homebrew token {{{
if [[ -e ${HOME}/.github-homebrew-token ]] ; then
    source ${HOME}/.github-homebrew-token
fi
# Homebrew token }}}

# tmuxinator {{{
if [[ -d /home/hringriin/.gem/ruby/2.5.0/bin ]] ; then
    # adding ruby bin to path variable
    export PATH=/home/hringriin/.gem/ruby/2.5.0/bin:${PATH}
fi
# tmuxinator }}}

# /usr/local/lib to path {{{
if [[ -d /usr/local/lib ]] ; then
    # adding ruby bin to path variable
    export PATH=/usr/local/lib:${PATH}
fi
# /usr/local/lib to path }}}

# ccache {{{
if [[ -d /usr/lib/ccache/bin ]] ; then
    export PATH=/usr/lib/ccache/bin/:${PATH}
fi

if [[ -e ${tmuxi}/completion/tmuxinator.zsh ]] ; then
    # sourcing tmuxinator completion
    source ${tmuxi}/completion/tmuxinator.zsh
fi
# ccache }}}

# prevent tmux autocorrection for certain commands {{{
alias 'cd ...'='nocorrect cd ../..'
alias 'tmux'='nocorrect tmux'
# prevent tmux autocorrection for certain commands }}}

# MACOS shit ... {{{
if [[ $(uname -a) == *"arwin"* ]] ; then
    alias 'vim'='/usr/local/Cellar/vim/8.0.1553_2/bin/vim'
fi
# MACOS shit ... }}}

# Fuzzy Finder (fzf) {{{
fzf_history()
{
    zle -I
    eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}
zle -N fzf_history
bindkey '^H' fzf_history

fzf_killps()
{
    zle -I
    ps -ef | sed 1d | fzf -m | awk '{print $2}' | xargs kill -${1:-9}
}
zle -N fzf_killps
bindkey '^Q' fzf_killps

fzf_cd()
{
    zle -I
    DIR=$(find ${1:-*} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf) && cd "$DIR"
}
zle -N fzf_cd
bindkey '^S' fzf_cd

fzf_gitdiff()
{
    diffing=$(git status | grep 'modified' | cut -d ':' -f 2 | sed -e 's/  *//g' | fzf -m --tac +s)

    if [[ ${diffing} != "" ]] ; then
        while read -r var; do
            git difftool ${var}
        done <<< ${diffing}
    fi
}
alias 'gdiff'='fzf_gitdiff'

fzf_gitvimopen()
{
    vopen=$(git status | grep 'modified' | cut -d ':' -f 2 | sed -e 's/  *//g' | fzf -m --tac +s)

    if [[ ${vopen} != "" ]] ; then
        while read -r var; do
            vim ${var}
        done <<< ${vopen}
    fi
}
alias 'gvim'='fzf_gitvimopen'

fzf_gitadd()
{
    modified=$(git status | grep 'modified' | cut -d ':' -f 2 | sed -e 's/\t/ /g' | sed -e 's/  *//g')
    untracked=$(git status | grep -Pzo '.*Untracked files(.*\n)*' | tail -n +4 | head -n -3 | sed -e 's/\t/ /g' | sed -e 's/  *//g')
    adds=$(echo "${modified}" "${untracked}" | fzf -m --tac +s)

    if [[ ${adds} != "" ]] ; then
        while read -r var; do
            git add ${var}
        done <<< ${adds}
    fi
}
alias 'gadd'='fzf_gitadd'
# Fuzzy Finder (fzf) }}}

# Stupid stuff... this is not recommended to use ;-) {{{
alias 'yolo'='git commit -m "$(curl -s whatthecommit.com/index.txt)"'
# Stupid stuff... this is not recommended to use ;-) }}}

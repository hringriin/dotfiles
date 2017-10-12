# Taken from Tassilo's Blog
# http://tsdh.wordpress.com/2007/12/06/my-funky-zsh-prompt/

# utf-8 characters
#
# ┤ ┫ ╣ ├ ┣ ╠ ┬ ┳ ╦ ┴ ┻ ╩ ┼ ╋ ╬
#
# ╰ └ ┗ ╚ ╭ ┌ ┏ ╔ ╮ ┐ ┓ ╗ ╯ ┘ ┛ ╝
#
# │ ┃ ╎ ╏ ┆ ┇ ┊ ┋
#
# ─ ━ ╌ ╍ ┄ ┅ ┈ ┉
#
# ▽ ▼  △ ▲  ❱ ▷ ▶  ❰ ◀ ◁  ▵ ▴  ▾ ▿  ▸ ▹  ◂ ◃  ➜ ➡ ↪  ↳  ⇉  ⇨  ≫  ≻  ≫  ⊳  ⋙ 

# Git Prompt
# TODO: needs to be changed to generic stuff. maybe linking the bash scripts
# to somewhere globally accessible.
source /home/hringriin/Repositories/github.com/hringriin/dotfiles/repo/bash/git-prompt.bash

echo "CONFIGURE ZSH NOW!"
echo "Import configs, functions and other shit from bash"
echo "Improvise on how to do some sort of installation script for all computers"

# user color
local ucolor=""
if [[ ${UID} == 0 ]] ; then
    ucolor="red"
else
    ucolor="green"
fi


# brackets
local openbracket="%{$fg[magenta]%}%B<%b%{$reset_color%}"
local closebracket="%{$fg[magenta]%}%B>%b%{$reset_color%}"

# current path
local path_p="${openbracket} %B%F{blue}%~%f%b ${closebracket}"

# user
local usern="${openbracket} %B%F{${ucolor}}%n%f%b ${closebracket}"

# host
local hostn="${openbracket} %B%F{blue}%m%f%b ${closebracket}"

# git prompt
local gitp=""
if [[ -n $(__git_ps1) ]] ; then
    gitp="${openbracket}$(__git_ps1) ${closebracket} %F{magenta}━━%f "
else
    gitp=""
fi

# return status
local ret_status="${openbracket} %F{cyan}%?%f ${closebracket}"

# history number
local hist_no="${openbracket} %F{cyan}%h%f ${closebracket}"

zstyle ':vcs_info:*' enable git
PROMPT='
%F{magenta}┌─%f %B%F{cyan}%D{%I:%M %p}%f%b ${usern} %B%F{yellow}@%b%f ${hostn} %F{magenta}──%f ${ret_status} %F{magenta}──%f ${hist_no}
%F{magenta}├─%f ${path_p}
%F{magenta}└─%f %B%F{${ucolor}}▶%f%b '

#local cur_cmd="${openbracket}%_${closebracket}"
##PROMPT2="${cur_cmd}> "
#PROMPT2="${gitp}"
RPROMPT='%F{${ucolor}}$(git_prompt_info)%f'

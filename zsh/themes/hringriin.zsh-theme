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

# user color
local ucolor=""
if [[ ${UID} == 0 ]] ; then
    ucolor="red"
else
    ucolor="green"
fi


# brackets
local openbracket="%{$fg[magenta]%}%B[%b%{$reset_color%}"
local closebracket="%{$fg[magenta]%}%B]%b%{$reset_color%}"

# current path
local path_p="%B%F{blue}%~%f%b"

# user
local usern="%B%F{${ucolor}}%n%f%b"

# host
local hostn="%B%F{blue}%m%f%b"

# return status
local ret_status="%F{cyan}%?%f"
local ret_stat="${openbracket} ${ret_status} ${closebracket}"

# history number
local hist_no="%F{cyan}%h%f"

# status and history
local stat_hist="${openbracket} ${ret_status} : ${hist_no} ${closebracket}"

local userp=""
if [[ `uname -a` == *"inux"* ]] ; then
    userp="`echo ${HOME}`"
elif [[ `uname -a` == *"arwin"* ]] ; then
    userp="/Users/${USERNAME}"
else
    print $fg_bold[yellow]"UNKNOWN USERPATH IN ZSH-COLORTHEME HRINGRIIN"
fi

# TODO: does this still needs to be here?
zstyle ':vcs_info:*' enable git

# former prompt with battery
#%F{magenta}┌─%f %B%F{cyan}%D{%I:%M %p}%f%b ${usern} %B%F{yellow}@%b%f ${hostn} ${openbracket} %F{cyan}BAT0: %f`${userp}/Repositories/github.com/hringriin/dotfiles/repo/bash/checkBatteryState.zsh | sed -n 2p` ${closebracket} ${openbracket} %F{cyan}BAT1: %f`${userp}/Repositories/github.com/hringriin/dotfiles/repo/bash/checkBatteryState.zsh | sed -n 3p` ${closebracket} ${openbracket} %F{cyan}Power: %f`${userp}/Repositories/github.com/hringriin/dotfiles/repo/bash/checkBatteryState.zsh | sed -n 1p` ${closebracket}

# care for the indention! it is crucial to the layout of of prompt
if [[ ${HOST} == "niederhoelle.de" || ${HOST} == "akuteunlust" ]] ; then
PROMPT='
%F{magenta}┌─%f %B%F{cyan}%D{%I:%M %p}%f%b ${usern} %B%F{yellow}@%b%f ${hostn} ${openbracket} %F{cyan}`uptime -p`%f ${closebracket}
%F{magenta}├─%f ${path_p}
%F{magenta}└─%f ${ret_stat} %B%F{${ucolor}}▶%f%b '
else
PROMPT='
%F{magenta}┌─%f %B%F{cyan}%D{%I:%M %p}%f%b ${usern} %B%F{yellow}@%b%f ${hostn}
%F{magenta}├─%f ${path_p}
%F{magenta}└─%f ${ret_stat} %B%F{${ucolor}}▶%f%b '
fi

# right prompt, only for git status
RPROMPT='%F{${ucolor}}$(git_prompt_info)%f'

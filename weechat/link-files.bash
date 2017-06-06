#!/bin/bash
# link-files

wcpath=""
srcpath=""

# Config
if [[ ${HOSTNAME} == "botis" ]] ; then          # check if it is my only Mac Os Machine by hostname
    wcpath="/Users/${USER}/.weechat"
    srcpath="/Users/${USER}/Repositories/github.com/hringriin/dotfiles/repo/weechat"
else
    wcpath="/home/${USER}/.weechat"
    srcpath="/home/${USER}/Repositories/github.com/hringriin/dotfiles/repo/weechat"
fi

if [[ ${wcpath} == "" ]] ; then
    exit 1;
fi

if [[ ${srcpath} == "" ]] ; then
    exit 1;
fi

# link the config files from the repository

if [[ ! -d ${wcpath} ]] ; then
    mkdir ${wcpath}
fi

files=(
    'alias.conf'
    'aspell.conf'
    'buflist.conf'
    'charset.conf'
    'exec.conf'
    'fifo.conf'
    'irc.conf'
    'logger.conf'
    'plugins.conf'
    'relay.conf'
    'script.conf'
    'trigger.conf'
    'weechat.conf'
    'xfer.conf'
)

dirs=(
    'guile'
    'lua'
    'perl'
    'python'
    'ruby'
    'script'
    'tcl'
)

for var in "${dirs[@]}"
do
    ln -fsv ${srcpath}/${var} ${wcpath}
done

unset var

for var in "${files[@]}"
do
    ln -fsv ${srcpath}/${var} ${wcpath}/${var}
done

#ln -fsv ${srcpath}/alias.conf ${wcpath}/alias.conf
#ln -fsv ${srcpath}/aspell.conf ${wcpath}/aspell.conf
#ln -fsv ${srcpath}/buflist.conf ${wcpath}/buflist.conf
#ln -fsv ${srcpath}/charset.conf ${wcpath}/charset.conf
#ln -fsv ${srcpath}/exec.conf ${wcpath}/exec.conf
#ln -fsv ${srcpath}/guile ${wcpath}/guile
#ln -fsv ${srcpath}/irc.conf ${wcpath}/irc.conf
#ln -fsv ${srcpath}/logger.conf ${wcpath}/logger.conf
#ln -fsv ${srcpath}/lua ${wcpath}/lua
#ln -fsv ${srcpath}/perl ${wcpath}/perl
#ln -fsv ${srcpath}/plugins.conf ${wcpath}/plugins.conf
#ln -fsv ${srcpath}/python ${wcpath}/python
#ln -fsv ${srcpath}/relay.conf ${wcpath}/relay.conf
#ln -fsv ${srcpath}/ruby ${wcpath}/ruby
#ln -fsv ${srcpath}/script ${wcpath}/script
#ln -fsv ${srcpath}/script.conf ${wcpath}/script.conf
#ln -fsv ${srcpath}/tcl ${wcpath}/tcl
#ln -fsv ${srcpath}/trigger.conf ${wcpath}/trigger.conf
#ln -fsv ${srcpath}/weechat.conf ${wcpath}/weechat.conf
#ln -fsv ${srcpath}/xfer.conf ${wcpath}/xfer.conf

# the sec.conf has to be copied and decrypted
cp -ifv ${srcpath}/sec.conf ${wcpath}/sec.conf

echo -e "Please decrypt the sec.conf file with vim"
read -p "Do it now? [Y/n]: " decrypt

if [[ ${decrypt} == "y" || ${decrypt} == "Y" || ${decrypt} == "" ]] ; then
    vim ${wcpath}/sec.conf
elif
    [[ ${decrypt} == "n" || ${decrypt} == "N" ]] ; then
    echo -e "Will not touch sec.conf.\nPlease decrypt it by yourself before starting weechat, otherwise it will be overwritten!"
else
    echo -e "Unrecognized entry."
fi

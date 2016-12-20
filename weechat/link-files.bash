#!/bin/bash
# link-files

# Config
if [[ ${HOSTNAME} == "botis" ]] ; then          # check if it is my only Mac Os Machine by hostname
    wcpath='/Users/hringriin/.weechat'
    srcpath='/Users/hringriin/Repositories/github.com/hringriin/dotfiles/repo/weechat'
else
    wcpath='/home/hringriin/.weechat'
    srcpath='/home/hringriin/Repositories/github.com/hringriin/dotfiles/repo/weechat'
fi

# remove all config files
rm -f ${wcpath}/alias.conf
rm -f ${wcpath}/aspell.conf
rm -f ${wcpath}/charset.conf
rm -f ${wcpath}/exec.conf
rm -f ${wcpath}/irc.conf
rm -f ${wcpath}/logger.conf
rm -f ${wcpath}/plugins.conf
rm -f ${wcpath}/relay.conf
rm -f ${wcpath}/script.conf
rm -f ${wcpath}/sec.conf
rm -f ${wcpath}/trigger.conf
rm -f ${wcpath}/weechat.conf
rm -f ${wcpath}/xfer.conf

# link the config files from the repository
ln -s ${srcpath}/alias.conf ${wcpath}/alias.conf
ln -s ${srcpath}/aspell.conf ${wcpath}/aspell.conf
ln -s ${srcpath}/charset.conf ${wcpath}/charset.conf
ln -s ${srcpath}/exec.conf ${wcpath}/exec.conf
ln -s ${srcpath}/irc.conf ${wcpath}/irc.conf
ln -s ${srcpath}/logger.conf ${wcpath}/logger.conf
ln -s ${srcpath}/plugins.conf ${wcpath}/plugins.conf
ln -s ${srcpath}/relay.conf ${wcpath}/relay.conf
ln -s ${srcpath}/script.conf ${wcpath}/script.conf
ln -s ${srcpath}/trigger.conf ${wcpath}/trigger.conf
ln -s ${srcpath}/weechat.conf ${wcpath}/weechat.conf
ln -s ${srcpath}/xfer.conf ${wcpath}/xfer.conf

# the sec.conf has to be copied and decrypted
cp ${srcpath}/sec.conf ${wcpath}/sec.conf

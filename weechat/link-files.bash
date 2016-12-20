#!/bin/bash
# link-files

wcpath='~/.weechat'
srcpath='~/Repositories/github.com/hringriin/dotfiles/repo/weechat'

rm -r ${wcpath}/alias.conf
rm -r ${wcpath}/aspell.conf
rm -r ${wcpath}/charset.conf
rm -r ${wcpath}/exec.conf
rm -r ${wcpath}/irc.conf
rm -r ${wcpath}/logger.conf
rm -r ${wcpath}/plugins.conf
rm -r ${wcpath}/relay.conf
rm -r ${wcpath}/script.conf
rm -r ${wcpath}/sec.conf
rm -r ${wcpath}/trigger.conf
rm -r ${wcpath}/weechat.conf
rm -r ${wcpath}/xfer.conf

ln -s ${srcpath}/alias.conf ${wcpath}/alias.conf
ln -s ${srcpath}/aspell.conf ${wcpath}/aspell.conf
ln -s ${srcpath}/charset.conf ${wcpath}/charset.conf
ln -s ${srcpath}/exec.conf ${wcpath}/exec.conf
ln -s ${srcpath}/irc.conf ${wcpath}/irc.conf
ln -s ${srcpath}/logger.conf ${wcpath}/logger.conf
ln -s ${srcpath}/plugins.conf ${wcpath}/plugins.conf
ln -s ${srcpath}/relay.conf ${wcpath}/relay.conf
ln -s ${srcpath}/script.conf ${wcpath}/script.conf
ln -s ${srcpath}/sec.conf ${wcpath}/sec.conf
ln -s ${srcpath}/trigger.conf ${wcpath}/trigger.conf
ln -s ${srcpath}/weechat.conf ${wcpath}/weechat.conf
ln -s ${srcpath}/xfer.conf ${wcpath}/xfer.conf

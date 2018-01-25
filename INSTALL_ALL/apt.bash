#!/bin/bash
# apt.bash







#           THIS FILE IS NEITHER TESTED NOR USED ANYWHERE !










# list of programmes maintained by apt(itude) needed for the whole action
neededAptPrgorammes=(
    'adduser'
    'bash'
    'bc'
    'clipster'
    'compton'
    'curl'
    'dropbox'
    'dropbox-cli'
    'evince'
    'file'
    'flashplugin'
    'galculator'
    'gawk'
    'gcc'
    'git'
    'gitkraken'
    'grep'
    'gzip'
    'htop'
    'i3-vim-syntax-git'
    'i3-wm'
    'i3lock-fancy-dualmonitors-git'
    'i3status'
    'keepassx2'
    'lm_sensors'
    'lxappearance'
    'lynx'
    'make'
    'mcabber'
    'meld'
    'mlocate'
    'mumble'
    'network-manager-applet'
    'networkmanager'
    'networkmanager-openconnect'
    'networkmanager-openvpn'
    'networkmanager-pptp'
    'networkmanager-vpnc'
    'nitrogen'
    'nm-connection-editor'
    'notify-osd'
    'ntp'
    'numlockx'
    'openconnect'
    'openssh'
    'openssl'
    'openvpn'
    'owncloud-client'
    'pandoc'
    'pass'
    'pepper-flash'
    'pinentry'
    'pulseaudio'
    'pulseaudio-alsa'
    'pulseaudio-bluetooth'
    'pulseaudio-equalizer'
    'pulseaudio-gconf'
    'pulseaudio-lirc'
    'pulseaudio-zeroconf'
    'ranger'
    'rofi'
    'rxvt-unicode'
    'scrot'
    'seahorse'
    'sed'
    'sox'
    'spotify'
    'sudo'
    'sxiv'
    'teamspeak3'
    'terminator'
    'termite'
    'texinfo'
    'thunar'
    'tmux'
    'ttf-dejavu'
    'ttf-font-awesome-4'
    'vim'
    'vivaldi'
    'vivaldi-ffmpeg-codecs'
    'vivaldi-widevine'
    'vlc'
    'vpnc'
    'weechat'
    'whatsie'
    'which'
    'wireless_tools'
    'wpa_supplicant'
    'xorg-server'
    'xorg-server-utils'
    'xorg-xev'
    'xorg-xinit'
    'xterm'
    'zsh'
)

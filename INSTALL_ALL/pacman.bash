#!/bin/bash
# pacman.bash


# list of programmes maintained by pacman needed for the whole action
neededProgrammes=(
    'abook'
    'acpi'
    'archlinux-keyring'
    'autoconf'
    'automake'
    'bash'
    'bash-completion'
    'bc'
    'binutils'
    'bison'
    'blueman'
    'compton'
    'cronie'
    'curl'
    'evince'
    'expac'
    'fakeroot'
    'file'
    'findutils'
    'flashplugin'
    'flex'
    'fzf'
    'galculator'
    'gawk'
    'gcc'
    'gettext'
    'git'
    'grep'
    'groff'
    'gucharmap'
    'gvim'
    'gzip'
    'hwinfo'
    'i3-gaps'
    'i3blocks'
    'i3status'
    'lolcat'
    'isync'
    'jshon'
    'keepassx2'
    'libtool'
    'lilypond'
    'lm_sensors'
    'lshw'
    'lxappearance'
    'lxrandr'
    'lynx'
    'm4'
    'make'
    'mcabber'
    'meld'
    'mlocate'
    'moc'
    'mosh'
    'mpv'
    'mumble'
    'mupdf'
    'mutt'
    'neofetch'
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
    'pacman'
    'pacman-contrib'
    'pacmatic'
    'pandoc'
    'pass'
    'patch'
    'pavucontrol'
    'pdfpc'
    'pepper-flash'
    'pinentry'
    'pkg-config'
    'playerctl'
    'powerline-fonts'
    'pulseaudio'
    'pulseaudio-alsa'
    'pulseaudio-bluetooth'
    'pulseaudio-equalizer'
    'pulseaudio-lirc'
    'pulseaudio-zeroconf'
    'qutebrowser'
    'ranger'
    'redshift'
    'rofi'
    'rubygems'
    'rxvt-unicode'
    'scrot'
    'seahorse'
    'sed'
    'sox'
    'sudo'
    'sxiv'
    'sysstat'
    'teamspeak3'
    'terminator'
    'termite'
    'texinfo'
    'thunar'
    'tilix'
    'tmux'
    'ttf-dejavu'
    'ttf-hack'
    'util-linux'
    'variety'
    'vivaldi-snapshot'
    'vivaldi-snapshot-ffmpeg-codecs'
    'vlc'
    'vpnc'
    'w3m'
    'weechat'
    'which'
    'wireless_tools'
    'wpa_supplicant'
    'xdotool'
    'xorg-server'
    'xorg-xdpyinfo'
    'xorg-xev'
    'xorg-xinit'
    'xorg-xrandr'
    'xterm'
    'zathura'
    'zsh'
)

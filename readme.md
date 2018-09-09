# Dotfiles

This repository provides a bunch of config files and a couple of scripts for maintaining my personal computers.
Feel free to adapt what you see to your own configs.

## INSTALL ALL (?)

This script will do quite a few things, primarily in regard of installing
necessary applications. But there are some things to do manually, though.

### Install mandatory programmes

`pacman -S lsb-release curl wget git sudo`

### Make sure, the mirrorlists are up to date to download in an ape-shit-crazy-fast manner.

### Add a user and a group

`groupadd <INITIAL-GROUP>`
`useradd -m -g <INITIAL-GROUP> -G <additional-groups> -s <login_shell> <username>`
`su -l <username>`

### Download the repo

`wget https://raw.githubusercontent.com/hringriin/dotfiles/master/getRepo.bash`
`cd ~/Repositories/github.com/hringriin/dotfiles/repo/`
`./install-all.bash`


## Things that do not work (yet)

- updateting and initialising submodules in this repo in the install script
- yay does not use the list it was fed. it seems, that it needs to install every package one by one (like packer needed to as well)
- rubygems were not installed beforehand, so tmuxinator failed to install and looped infinitely
- manually set theme with `lxappearance`
- adding the `[herecura]` repository to `pacman.conf`
- the mutt install script will not work until the gpg keys are imported
- un-fuck the install sequence. texlive and that shit.
    - make clear what needs to be installed before the script itself can start
- crontabs ?
    - add systemd entries to install script
- install `pacman-contrib` before `pacmatic`.
- 

#!/bin/bash
# install_all_config.bash
# This is just for configuration!

# temporary files
tmpDir="/tmp"                                                               # temp dir
tmp1="neededProgrammes$$"                                                   # temp file for evaluation of needed programmes by pacman
tmp2="neededProgrammes2$$"                                                  # temp file for evaluation of needed programmes by packer
tmp3="sudoers"                                                              # temp file for evaluation of member of sudoers
missingPacmanPrg=0                                                          # boolean; 0: all installed; 1: one or more programmes missing
missingPackerPrg=0                                                          # boolean; 0: all installed; 1: one or more programmes missing
missingPacmanList="missingPacmanList$$"                                     # list of missing programmes (pacman)
missingPackerList="missingPackerList$$"                                     # list of missing programmes (packer)
packerList=()                                                               # empty array to write in
repoPath="/home/${USER}/Repositories/github.com/hringriin/dotfiles/repo"    # path of the repository
ulbin="/usr/local/bin"

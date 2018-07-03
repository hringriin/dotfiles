#!/bin/bash
# server compile

echo -e "\nSTARTING script: $(date)"
echo -e "Change directory ..."
cd /home/hringriin/Repositories/github.com/hringriin/chordbook/repo/Unix/
echo -e "Dir: $(pwd)"

echo -e "Pulling ..."
git pull

echo -e "Making ..."
make -f /home/hringriin/Repositories/github.com/hringriin/chordbook/repo/Unix/Makefile server

echo -e "\n\nDone!"
echo -e "ENDING script: $(date)\n"

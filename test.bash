#!/bin/bash
# test

# for fuzzy finder thingy

modified=$(git status | grep 'modified' | cut -d ':' -f 2 | sed -e 's/\t/ /g' | sed -e 's/  *//g')
untracked=$(git status | grep -Pzo '.*Untracked files(.*\n)*' | tail -n +4 | head -n -3 | sed -e 's/\t/ /g' | sed -e 's/  *//g')
adds=$(echo "${modified}" "${untracked}" | fzf -m --tac +s)

if [[ ${adds} == "" ]] ; then
    exit 0
fi

while read -r var; do
    git add ${var}
done <<< ${adds}

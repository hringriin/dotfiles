#!/bin/bash
# new-mirros - recalculates the arch linux mirrorlist

PMD='/etc/pacman.d'
PML='mirrorlist'
PMN='mirrorlist.pacnew'
PMT='mirrorlist.tmp'

if [[ -e ${PMD}/${PMN} ]] ; then
    cp -iv ${PMD}/${PMN} ${PMD}/${PMT}
elif [[ -e ${PMD}/${PML} ]] ; then
    cp -iv ${PMD}/${PML} ${PMD}/${PMT}
fi

sed -i 's/^#Server/Server/' ${PMD}/${PMT}

rankmirrors -n 50 ${PMD}/${PMT} > ${PMD}/${PML}

pacman -Syyu

rm -rfv ${PMD}/${PMT}
rm -rfv ${PMD}/${PMN}

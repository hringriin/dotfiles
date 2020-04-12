#!/bin/bash
# new-mirros - get me up an up to date mirrorlist

reflector --verbose \
    --latest 200 \
    --protocol https \
    --sort rate \
    --country France \
    --country Germany \
    --country Netherlands \
    --country 'United Kingdom' \
    --country 'United Statues' \
    --age 12 \
    --save /etc/pacman.d/mirrorlist

sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist

pacman -Syyu

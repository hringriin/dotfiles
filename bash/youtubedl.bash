#!/bin/bash
# Script for grabbing the audio of youtube videos as mp3.
address=$1
bitrate=$2
default_bitrate=256
title=$(youtube-dl --get-title $address)
filename=$(youtube-dl --get-filename $address)
youtube-dl $address
mkdir .tmp
mv *.mkv .tmp
cd .tmp

shopt -s nullglob

array=(*)

for i in "${array[@]}"
do
ffmpeg -i "$i" -vn -ar 44100 -ac 2 -ab 192k -f mp3 "$i.mp3"
done

mv *.mp3 ../
cd ..
rm -r .tmp

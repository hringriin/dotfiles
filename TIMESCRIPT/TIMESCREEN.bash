#!/bin/bash

( while sleep 1 ; do /home/hringriin/TIMESCRIPT/TIMESCRIPT.bash ; echo -e '\f' ; done ) | sm --foreground=#00FF00 --background=#000000 -

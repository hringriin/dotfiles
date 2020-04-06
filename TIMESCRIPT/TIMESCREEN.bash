#!/bin/bash

( while sleep 1 ; do /home/hringriin/TIMESCRIPT/TIMESCRIPT.bash ; echo -e '\f' ; done ) | sm --foreground=#ebdbb2 --background=#282828 -

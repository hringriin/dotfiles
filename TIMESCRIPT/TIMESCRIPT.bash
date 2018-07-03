#!/bin/bash

# String for tutorium end format "<HOUR><HOUR>:<MINUTE><MINUTE>:<SECOND><SECOND>"
TUTEND="17:45:00"



# DO NOT TOUCH
NEWEND=$(date -d "${TUTEND}" "+%s")
NEWNOW=$(date "+%s")
NEWREMAINING=$[${NEWEND} - ${NEWNOW} - 3600]                # output of $(date -d @10 "+%T") == 1 hour 10 seconds --> -= 1 Hour

if [[ ${NEWREMAINING} -lt -3600 ]] ; then
    echo -e "$(date "+%T") Uhr\n"
    echo -e "Zeit aufgebraucht!"
else
    echo -e "$(date "+%T") Uhr\n"
    echo -e "Restzeit: $(date -d @${NEWREMAINING} "+%T")"
fi

#!/bin/bash
# video-spool - add a video (e.g. Youtube) to the youtube-task-spooler

while getopts ":s" opt ; do
    case $opt in
        s)
            # let task-spooler handle it
            TS_SOCKET=/tmp/tsp-youtube tsp mpv ${QUTE_URL}
            exit 0
            ;;
    esac
done

mpv ${QUTE_URL}
exit 0

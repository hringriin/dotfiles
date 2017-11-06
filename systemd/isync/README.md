# SystemD Services for isync

Copy both files to `/etc/systemd/system/` and *enable* and *start* **only the timer** with
your username, e.g. `systemctl enable mbsync@john.timer && systemctl start
mbsync@john.timer`.

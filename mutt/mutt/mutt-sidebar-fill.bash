cd $1
find . -maxdepth 10 -type d | grep -v /cur | grep -v /tmp | grep -v /new | sed -n '1!p' | sed -e 's/^\.\///g' | sed -e 's/^/mailboxes ="/g' | sed -e 's/$/"/g' | sort

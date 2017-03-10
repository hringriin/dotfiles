#!/bin/bash
# ts3-query

# config - tmp files
tmpDir="/tmp"
tmp1="tmp1$$"
tmp2="tmp2$$"
tmp3="tmp3$$"
tmp4="tmp4$$"
tmp5="tmp5$$"
tmp6="tmp6$$"

# config - ts3 query user data
username=""
passphrase=""

# config - ts3 query server data
server="niederhoelle.de"
port="10011"

# config - webserver
serverDir="/var/www/ts3-query"
clientlistfile="ts3-clientlist.txt"

# telnet foo
# connect to server with teamspeak3 server installed to query current userlist
function telnetGetData ()
{
    ( echo "login ${username} ${passphrase}"; sleep 2; echo "use 1"; sleep 2; echo "clientlist"; sleep 2; echo "quit" ) | telnet  ${server} ${port} > ${tmpDir}/${tmp1}
}

# määääägick :-)
# line by line:
# 1st: all whitespaces to newlines (regex) and write to new file
# 2nd: all lines with "client_nickname" to new file
# 3rd: all lines except those with "serveradmin" to new file
# 4th: all lines with '\s' to whitespace and to new file
# 5th: cut off the prefix "client_nickname=" and keep only the usernames, one name per line
function parseTelnetData ()
{
    sed -e 's\/s\+/\n/g' ${tmpDir}/${tmp1} > ${tmpDir}/${tmp2}
    grep -e "client_nickname" ${tmpDir}/${tmp2} > ${tmpDir}/${tmp3}
    grep -iv "serveradmin" ${tmpDir}/${tmp3} > ${tmpDir}/${tmp4}
    sed -e 's/\\s/ /g' ${tmpDir}/${tmp4} > ${tmpDir}/${tmp5}
    cat ${tmpDir}/${tmp5} | cut -d "=" -f 2 > ${tmpDir}/${tmp6}
}

# copy the list of usernames to a file accessable by the webserver
function deliverData ()
{
    cp ${tmpDir}/${tmp6} ${serverDir}/${clientlistfile}
}

# obvious, isn't it ?
# the functions are written in this file in order of appearance, that is in the main function, too
function main ()
{
    exit 0
}

# deletes (hopefully) all that mess we did and cleans up space
function cleanup ()
{
    cd ${tmpDir}
    for i in {1..6..1}          #   to delete *ALL* temp files, increment or decrement the current '6' to your needs (see config - tmp files)
    do
        rm ${tmp${i}}
    done
}

main

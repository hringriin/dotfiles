#!/bin/bash
# author: dyamon
# the original script by dyamon (#mutt@irc.freenode.net) did the output in the
# mutt-alias syntax
#
# author: hringriin
# issued from within mutt, this script will magically put emails addresses from
# the mail you received to you abook address book.
# it also works with stdin ("finish" with CTRL + d)


ADDRESS_BOOK="${HOME}/.abook/addressbook"

# for regex foo in the dialog box
word="[0-9A-Za-z._-]+"
address="$word\@$word"
indexnum="\[[0-9]+\]"

mails=$(cat /dev/stdin | grep -oE "$address" | sort | uniq)

checklist=()
while read -r mail;
do
    checklist=( "${checklist[@]}" "$mail" off )
done <<< "$mails"

selected=$( dialog --stdout --separate-output --no-items \
                   --title "AliasMe" \
                   --ok-label "Continue" \
                   --checklist "Choose emails to save in $ADDRESS_BOOK" \
                               8 80 0 \
                               "${checklist[@]}"
          )

[[ "$selected" = "" ]] && exit 0

# get the last number of the current address book, to prevent issues with the
# sorting. this way, all new entries will be listet at the buttom of the
# current address book
lastNum=$(tail -n 20 ${ADDRESS_BOOK} | grep -i "\[[0-9]*\]" | tail -n 1 | tr -d '[]')

echo ${lastNum}

n=1
form=()
while read -r mail;
do
    let ++lastNum
    form=( "${form[@]}" \
           "Index:"         "$n"        1   "[${lastNum}]"  "$n"        12  40  0   \
           "E-mail(*):"     "$[n+1]"    1   "$mail"         "$[n+1]"    12  40  0   \
           "Alias(*):"      "$[n+2]"    1   ""              "$[n+2]"    12  40  0   \
           "Last Name:"     "$[n+3]"    1   ""              "$[n+3]"    12  40  0   \
           "First Name:"    "$[n+4]"    1   ""              "$[n+4]"    12  40  0
         )
    n=$[n+6]
done <<< "$selected"

# the string of "paste -sd" has to be n-1 lines of the dialog forms!
dialog --stdout \
    --title "AliasMe" \
    --ok-label "Save" \
    --form "Enter missing items in the form" 0 80 20 "${form[@]}" \
    | paste -sd '    \n' \
    | sed -r "s/(${indexnum}) (${address}) (${word}) (${word}) (${word})/\1\nname=\4, \5\nemail=\2\nnick=\3\n/" \
    >> ${ADDRESS_BOOK}

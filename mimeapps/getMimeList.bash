#!/bin/bash
# getmimeList.bash - get all mime-type -- desktop.file associations.

listdesktop="${HOME}/listdesktop.txt"
mimelistfile="${HOME}/mimelistfile.txt"
filelist=()

if [[ $(command -v updatedb) >/dev/null ]] ; then
    echo "Need to update database for mlocate, running 'updatedb'."
    sleep 1
    sudo updatedb
else
    echo "command 'updatedb' not present. Is the package 'mlocate' installed?"
fi

if [[ $(command -v locate) >/dev/null ]] ; then
    echo "Locating the files ..."
    sleep 1

    i=0
    while read -r line ; do
        filelist[${i}]="${line}"
        ((++i))
    done < <(locate -i "*.desktop")
else
    echo "command 'locate' not present"
    exit 1
fi

rm -r ${listdesktop}
touch ${listdesktop}

for val in "${filelist[@]}" ; do
    echo -e "\e[1;36m${val}\e[0m"
    grep -ir mimetype "${val}" | cut -d '=' -f 2 | sed -e 's/;/\n/g' | sed '/^\s*$/d' >> ${listdesktop}
done

cat ${listdesktop} | sort -u >> ${mimelistfile}

while read -r line ; do
    echo "${line}: $(xdg-mime query default ${line})" >> output.txt
done < ${mimelistfile}


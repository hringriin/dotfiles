#!/bin/bash
# blogscript

# This script does some funny things to put some html code on my website(s)

matchBlog="<!-- BLOG INPUT HERE -->"
matchNav="<!-- NAV INPUT HERE -->"
serverDir=
server=
blog=
rss=
content=
files=()

function newEntry()
{
    if [[ ! -d ${serverDir} ]] ; then
        mkdir -p ${serverDir}
    fi

    if [[ ! -d ${serverDir}/.drafts ]] ; then
        mkdir -p ${serverDir}/.drafts
    fi

    if [[ ! -d ${serverDir}/.templates ]] ; then
        //TODO
    fi

    local fname=$(dialog --no-tags \
        --stdout \
        --backtitle "by hringriin" \
        --title "Blogscript" \
        --inputbox "Name your blogpost!" 0 0)

    if [[ ${fname} == "" ]] ; then
        echo "No proper blogpost name given!"
        exit 1;
    fi

    # make sure the name does not contain whitespaces
    local fn=$(sed -e 's/\s/_/gm' <<< ${fname})
    local rawDate=$(date)
    local theDate=$(date -d "${rawDate}" "+%Y-%m-%d_%H:%M")
    fn="${theDate}_${fn}"
    theDate=$(sed -e "s/${theDate}/$(date -d "${rawDate}" "+%d.%m.%Y"), $(date -d "${rawDate}" "+%H:%M") Uhr/" <<< ${theDate})

    file=${serverDir}/.drafts/${fn}.html
    cp ${serverDir}/.templates/BLOG.html ${file}

    sed -i -e "s/<IDREPLACE>/${fn}/" ${file}
    sed -i -e "s/<TITLEREPLACE>/${theDate} -- ${fname}/" ${file}

    ${EDITOR} ${file}
}

function checkDrafts()
{
    if [[ -d ${serverDir}/.drafts ]] && [[ $(ls -1 ${serverDir}/.drafts | wc -l) -gt 0 ]] ; then
        files=($(cd ${serverDir}/.drafts && ls -1 *html))
    else
        dialog --no-tags \
            --stdout \
            --backtitle "by hringriin" \
            --title "Blogscript" \
            --msgbox "Drafts folder not present or empty" 0 0

        exit 0
    fi
}

function selectServer()
{
    local selServ=$(dialog --no-tags \
        --stdout \
        --backtitle "by hringriin" \
        --title "Blogscript" \
        --radiolist "Select your server." 0 0 0 \
            10 "barzh.eu - Blog" on \
            20 "barzh.eu - Wartung" off)

    case ${selServ} in
        "10")
            server="https:\/\/barzh\.eu"
            serverDir="${HOME}/barzh.eu"
            blog="blog.html"
            rss="rss.xml"
            ;;
        "20")
            server="https:\/\/niederhoelle\.no-ip\.biz"
            serverDir="${HOME}/barzh.eu-wartung"
            blog="index.html"
            rss="rss.xml"
            ;;
        *)
            exit 0
            ;;
    esac
}

function getDir()
{
    local NUM=0

    for f in ${files[@]} ; do
        echo "${NUM} ${f} off"
        NUM=$((NUM + 1))
    done
}

function writeToBlog()
{
    local theDate="$(cut -d '_' -f 1 <<< $1)_$(cut -d '_' -f 2 <<< $1)"
    local id=$(cut -d '.' -f 1 <<< $1)

    # looks nasty, but it is necessary to add whitespaces in front of the
    # list-entry-string
    repString="\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ <li><a href=\"#${id}\">$(date -d $(cut -d '_' -f 1 <<< ${theDate}) "+%d.%m.%Y"), $(date -d $(cut -d '_' -f 2 <<< ${theDate}) "+%H:%M"):<br \/>$(sed -e "s/${theDate}_//" <<< $1 | cut -d '.' -f 1 | sed -e "s/_/ /g")<\/a><\/li>"

    # add the list entry in the nav bar
    sed -i -e "/${matchNav}/a ${repString}" ${serverDir}/${blog}

    # add the blog post in the article section
    sed -i -e "/${matchBlog}/ r ${serverDir}/.drafts/$1" ${serverDir}/${blog}

    # delete lines containing 'div'
    if [[ ! -d ${serverDir}/.tmp ]] ; then
        mkdir -p ${serverDir}/.tmp
    fi
    tmpFile="${serverDir}/.tmp/$$_tmp.html"
    cat ${serverDir}/.drafts/$1 | sed -e "/div/d" | tail -n +2 > ${tmpFile}

    cp ${serverDir}/.templates/RSS.xml ${serverDir}/.drafts/$1.xml

    # replace the date
    sed -i -e "s/<DATEREPLACE>/$(date -d "$(sed -e "s/_/ /" <<< ${theDate})" "+%a, %d %b %Y %H:%M:%S %Z")/" ${serverDir}/.drafts/$1.xml

    # replace the title
    sed -i -e "s/<TITLEREPLACE>/$(date -d "$(sed -e "s/_/ /" <<< ${theDate})" "+%d.%m.%Y, %H:%M") Uhr -- $(sed -e "s/${theDate}_//" <<< $1 | sed -e "s/_/ /g" | cut -d '.' -f 1)/" ${serverDir}/.drafts/$1.xml

    # replace the url
    sed -i -e "s/<URLREPLACE>/${server}\/${blog}\#${id}/" ${serverDir}/.drafts/$1.xml

    # replace the content
    sed -i -e "/<\!\[CDATA\[/ r ${tmpFile}" ${serverDir}/.drafts/$1.xml

    # add to xml file
    sed -i -e "/${matchBlog}/ r ${serverDir}/.drafts/$1.xml" ${serverDir}/${rss}

    rm ${serverDir}/.drafts/$1{,.xml}
    rm ${tmpFile}
}

function delBlogPost ()
{
    local tmpFiles=$(getDir)

    if [[ ${tmpFiles[@]} > 0 ]] ; then
        local selPosts=$(dialog --no-tags \
            --stdout \
            --backtitle "by hringriin" \
            --title "Blogscript" \
            --default-button "Cancel" \
            --checklist "Select the posts to delete. This is IRREVERSIBLE!" 0 0 0 ${tmpFiles})

        for i in ${selPosts[@]} ; do
            rm ${serverDir}/.drafts/${files[${i}]}
        done

        dialog --no-tags \
            --stdout \
            --backtitle "by hringriin" \
            --title "Blogscript" \
            --msgbox "Selected posts were deleted." 0 0
    fi
}

function publishBlogPost ()
{
    local tmpFiles=$(getDir)

    if [[ ${tmpFiles[@]} > 0 ]] ; then
        local selPosts=$(dialog --no-tags \
            --stdout \
            --backtitle "by hringriin" \
            --title "Blogscript" \
            --checklist "Select the posts to publish." 0 0 0 ${tmpFiles})

        for i in ${selPosts[@]} ; do
            writeToBlog ${files[${i}]}
        done
    fi
}

function usage ()
{
            echo -e "Blogscript by hringriin.\nFunny things for my blog(s).\n"
            echo -e "Usage: ./blogscript.bash [OPTION]\n"

            echo -e "\t<Option>   <Argument>          <Description>"
            echo -e "\t  -n                           Create a new blog entry."
            echo -e "\t  -d                           Delete a previously created blog entry"
            echo -e "\t  -p                           Publish a previously created blog entry"

            exit 0
}

# if no argument is passed to the script
if [[ $# -eq 0 ]] ; then
    usage
fi

while getopts "dnp" opt ; do
    case $opt in
        d)
            selectServer
            checkDrafts
            delBlogPost
            ;;
        n)
            selectServer
            newEntry
            ;;
        p)
            selectServer
            checkDrafts
            publishBlogPost
            ;;
        \?)
            echo -e "Invalid option: -$OPTARG\n\n" >&2
            usage
            ;;
        :)
            echo -e "Option -$OPTARG requires an argument." >&2
            ;;
    esac
done

exit 0

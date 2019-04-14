#!/bin/bash
# blogscript

# This script does some funny things to put some html code on my website(s)

matchBlog="<!-- BLOG INPUT HERE -->"
matchNav="<!-- NAV INPUT HERE -->"
scpPath=
serverDir=
server=
blog=
rss=
content=
files=()

function newEntry()
{
    # check if the directories are present
    if [[ ! -d ${serverDir} ]] ; then
        mkdir -p ${serverDir}
    fi

    if [[ ! -d ${serverDir}/.drafts ]] ; then
        mkdir -p ${serverDir}/.drafts
    fi

    if [[ ! -d ${serverDir}/.templates ]] ; then
        cp -r ${HOME}/Repositories/github.com/hringriin/dotfiles/repo/blog/.templates ${serverDir}/
    fi

    # input the name for the new post
    local fname=$(dialog --no-tags \
        --stdout \
        --backtitle "by hringriin" \
        --title "Blogscript" \
        --inputbox "Name your blogpost!" 0 0)

    # checks for proper name convention
    if [[ ${fname} == "" ]] ; then
        dialog --no-tags \
            --stdout \
            --backtitle "by hringriin" \
            --title "Blogscript" \
            --msgbox "No proper blogpost name given!" 0 0
        exit 1;
    fi

    # make sure the name does not contain whitespaces
    local fn=$(sed -e 's/\s/_/gm' <<< ${fname})

    # store the current date as blogpost date in date's default output to
    # modify it later
    local rawDate=$(date)

    # the date for id and url
    local theDate=$(date -d "${rawDate}" "+%Y-%m-%d_%H:%M")

    # the filename combined with the date for id and url
    fn="${theDate}_${fn}"

    # redefining the theDate for the title
    theDate=$(sed -e "s/${theDate}/$(date -d "${rawDate}" "+%d.%m.%Y"), $(date -d "${rawDate}" "+%H:%M") Uhr/" <<< ${theDate})

    # the file to be created
    file=${serverDir}/.drafts/${fn}.html

    # if the blog template is not present (regardless of its content), exit
    if [[ ! -e ${serverDir}/.templates/BLOG.html ]] ; then
        dialog --no-tags \
            --stdout \
            --backtitle "by hringriin" \
            --title "Blogscript" \
            --msgbox "Template error. Check, if the templates are present." 0 0

        exit 0
    fi
    cp ${serverDir}/.templates/BLOG.html ${file}

    # replace the ID place holder with the correct id (called fn)
    sed -i -e "s/<IDREPLACE>/${fn}/" ${file}

    # replace the title place holder with the correct date and modified file
    # name as entered by the user
    sed -i -e "s/<TITLEREPLACE>/${theDate} -- ${fname}/" ${file}

    # open the file with the user's default editor.
    ${EDITOR} ${file}

    dialog --no-tags \
        --stdout \
        --backtitle "by hringriin" \
        --title "Blogscript" \
        --msgbox "Blogpost created." 0 0
}

# checks for the drafts folder to be not empty of html files. if NOT empty,
# initialize the ${files} array variable with all the html files in the drafts
# folder
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

# select the server to write/delete/publish a blogpost from
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
            scpPath="barzh.eu:/var/www/barzh.eu"
            ;;
        "20")
            server="https:\/\/niederhoelle\.no-ip\.biz"
            serverDir="${HOME}/barzh.eu-wartung"
            blog="index.html"
            rss="rss.xml"
            scpPath="chamus:/var/www/html"
            ;;
        *)
            exit 0
            ;;
    esac
}

# the dialog needs a differently formated list, i.e. a string with:
#   - a number
#   - the flie name
#   - it's initial checklist state
# so, the original ${files} array is not suitable, but will be used later on
function getDir()
{
    local NUM=0

    for f in ${files[@]} ; do
        echo "${NUM} ${f} off"
        NUM=$((NUM + 1))
    done
}

# publishes a blog post, i.e. writes to the local blogs on your machine.
# NO UPLOAD WILL BE DONE BY THIS FUNCTION!
function writeToBlog()
{
    # date to be used later for id and title replacements
    local theDate="$(cut -d '_' -f 1 <<< $1)_$(cut -d '_' -f 2 <<< $1)"

    # the id, being the filename provided to the function as parameter
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

    # if the rss.xml templates does not exist, exit
    if [[ ! -e ${serverDir}/.templates/RSS.xml ]] ; then
        dialog --no-tags \
            --stdout \
            --backtitle "by hringriin" \
            --title "Blogscript" \
            --msgbox "Template error. Check, if the templates are present." 0 0

        exit 0
    fi
    cp ${serverDir}/.templates/RSS.xml ${serverDir}/.drafts/$1.xml

    # replace the date
    sed -i -e "s/<DATEREPLACE>/$(date -d "$(sed -e "s/_/ /" <<< ${theDate})" "+%a, %d %b %Y %H:%M:%S %Z")/" ${serverDir}/.drafts/$1.xml

    # replace the title
    sed -i -e "s/<TITLEREPLACE>/$(sed -e "s/${theDate}_//" <<< $1 | sed -e "s/_/ /g" | cut -d '.' -f 1)/" ${serverDir}/.drafts/$1.xml

    # replace the url
    sed -i -e "s/<URLREPLACE>/${server}\/${blog}\#${id}/" ${serverDir}/.drafts/$1.xml

    # replace the content
    sed -i -e "/<\!\[CDATA\[/ r ${tmpFile}" ${serverDir}/.drafts/$1.xml

    # add to xml file
    sed -i -e "/${matchBlog}/ r ${serverDir}/.drafts/$1.xml" ${serverDir}/${rss}

    # change last update date
    # the regex strings *should* be correct, but apparently they are not.
    #sed -i -e "s/Letzte Aktualisierung: \d{1,2}\.\d{1,2}\.\d{2,4}, \d{1,2}:\d{1,2}/Letzte Aktualisierung: $(date "+%d.%m.%Y, %H:%M")/" ${serverDir}/${blog}
    #sed -i -e "s/<lastBuildDate>\w{3}, \d{2} \w{3} \d{4} \d{2}:\d{2}:\d{2} \w{0,4}/<lastBuildDate>$(date "+%a, %d %b %Y %H:%M:%S %Z")/" ${serverDir}/${rss}

    # remove tmp files and the drafts published just now
    rm ${serverDir}/.drafts/$1{,.xml}
    rm ${tmpFile}
}

# delete selected blog posts
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

# edit selected blog post
function editBlogPost ()
{
    local tmpFiles=$(getDir)

    if [[ ${tmpFiles[@]} > 0 ]] ; then
        local selPost=$(dialog --no-tags \
            --stdout \
            --backtitle "by hringriin" \
            --title "Blogscript" \
            --default-button "Cancel" \
            --radiolist "Select the posts to delete. This is IRREVERSIBLE!" 0 0 0 ${tmpFiles})

        ${EDITOR} ${serverDir}/.drafts/${files[${selPost}]}

        dialog --no-tags \
            --stdout \
            --backtitle "by hringriin" \
            --title "Blogscript" \
            --msgbox "Blostpost edited." 0 0
    fi
}

# publish selected blog posts
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

# print usesage information to the shell
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

function uploadLive()
{
    scp ${serverDir}/${blog} ${serverDir}/${rss} ${scpPath}/
    dialog --no-tags \
        --stdout \
        --backtitle "by hringriin" \
        --title "Blogscript" \
        --msgbox "Blog uploaded! Check ${server}" 0 0

}

# main menu, select what to do
function main()
{
    local actionSelect=$(dialog --no-tags \
        --stdout \
        --backtitle "by hringriin" \
        --title "Blogscript" \
        --menu "What do you want to do?" 0 0 0 \
            10 "Write a new blogpost" \
            40 "Edit a blogpost" \
            30 "Delete one or more blogposts" \
            20 "Publish one or more blogposts" \
            50 "Upload to live server" \
            60 "Exit")

    # if arguments are passed, check for flags
    case ${actionSelect} in
        "10")
            selectServer
            newEntry
            main
            ;;
        "20")
            selectServer
            checkDrafts
            publishBlogPost
            main
            ;;
        "30")
            selectServer
            checkDrafts
            delBlogPost
            main
            ;;
        "40")
            selectServer
            checkDrafts
            editBlogPost
            main
            ;;
        "50")
            selectServer
            uploadLive
            main
            ;;
        "60")
            exit 0
            ;;
    esac
}

main
exit 0

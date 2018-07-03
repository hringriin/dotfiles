#!/bin/bash
# myGitlabClone - clont ein gitlab repository + wiki

version="v0.1"
# Setting values
confDir="${HOME}/.config/myGitlabClone"
confFile="conf"

# e.g. github.com
defServer=""

# e.g. ~/Repositories
useRepPath=""
defRepPath=""

# check for link in /usr/local/bin
checkLink()
{
    if [[ ! -e /usr/local/bin/myGitlabClone ]] ; then
        echo "This tool is not linked to your /usr/local/bin directory. Do you want to link it? [Y/n]"
        read -p ">>: " linkmglc

        if [[ "${linkmglc}" == "" || "${linkmglc}" == "y" || "${linkmglc}" == "Y" ]] ; then
            if [[ -e myGitlabClone.bash ]] ; then
                tmpDir=$(pwd)
                cd /usr/local/bin
                ln -s ${tmpDir}/myGitlabClone.bash myGitlabClone
                echo "You can now type 'myGitlabClone' from everywhere."
            fi
        fi
    fi
}

# setting config
setConfig()
{
    # setup default server
    echo "Please specify your default git provider (e.g. github.com)!"
    read -p ">>: " defgitserver
    defServer="${defgitserver}"

    # setup default rep path
    echo "Do you want to use a default folder for your repositories? [y/n]"
    read -p ">>: " defdir

    if [[ "${defdir}" == "y" || "${defdir}" == "Y" ]] ; then
        echo "Please provide the FULL QUALIFIED path to your folder"
        read -p ">>: " defdirpath
        useRepPath=true
        defRepPath="${defdirpath}"
    elif [[ "${defdir}" == "n" || "${defdir}" == "N" ]] ; then
        echo "No default path will be configured. You can change this later in '${confDir}/${confFile}'."
        useRepPath=false
        defRepPath=""
    else
        echo "Invalid entry - setConfig()"
        exit 127
    fi

    echo ${defServer} > ${confDir}/${confFile}
    echo ${useRepPath} >> ${confDir}/${confFile}
    echo ${defRepPath} >> ${confDir}/${confFile}

    echo "Configuration saved"

    exit 0
}


checkConfig()
{
    if [[ ! -e ${confDir}/${confFile} ]] ; then
        echo "No configuration file found."
        echo "Assuming no initial configuration has been made."

        mkdir -p ${confDir}
        touch ${confDir}/${confFile}

        echo "Please specify the default configuration!"

        setConfig
    else
        defServer="$(cat ${confDir}/${confFile} | sed -n 1p)"
        useRepPath="$(cat ${confDir}/${confFile} | sed -n 2p)"
        defRepPath="$(cat ${confDir}/${confFile} | sed -n 3p)"
    fi
}

cloneRepoSSH()
{
    # repo
    if [[ ! -d ${defRepPath}/$3/$1/$2/repo ]] ; then
        mkdir -p ${defRepPath}/$3/$1/$2/repo
        git clone git@$3:$1/$2.git ${defRepPath}/$3/$1/$2/repo
    else
        echo "Directory exists. Delete and clone new? [y/n]"
        read -p ">>: " cloneie

        if [[ "${cloneie}" == "y" || "${cloneie}" == "Y" ]] ; then
            echo "Deleting and cloning new ..."
            git clone git@$3:$1/$2.git ${defRepPath}/$3/$1/$2/repo
        elif [[ "${cloneie}" == "n" || "${cloneie}" == "N" ]] ; then
            echo "Nothing will happen ..."
        else
            echo "Invalid entry"
            exit 127
        fi

    fi
}

cloneWikiSSH()
{
    # wiki
    if [[ ! -d ${defRepPath}/$3/$1/$2/wiki ]] ; then
        mkdir -p ${defRepPath}/$3/$1/$2/wiki
        git clone git@$3:$1/$2.wiki.git ${defRepPath}/$3/$1/$2/wiki
    else
        echo "Directory '${defRepPath}/$1/$2/wiki' exists. Delete and clone new? [y/n]"
        read -p ">>: " cloneie

        if [[ "${cloneie}" == "y" || "${cloneie}" == "Y" ]] ; then
            echo "Deleting and cloning new ..."
            git clone git@$3:$1/$2.wiki.git ${defRepPath}/$3/$1/$2/wiki
        elif [[ "${cloneie}" == "n" || "${cloneie}" == "N" ]] ; then
            echo "Nothing will happen ..."
        else
            echo "Invalid entry"
            exit 127
        fi

    fi
}

cloneRepoHTTPS()
{
    # repo
    if [[ ! -d ${defRepPath}/$3/$1/$2/repo ]] ; then
        mkdir -p ${defRepPath}/$3/$1/$2/repo
        git clone https://$3/$1/$2.git ${defRepPath}/$3/$1/$2/repo
    else
        echo "Directory exists. Delete and clone new? [y/n]"
        read -p ">>: " cloneie

        if [[ "${cloneie}" == "y" || "${cloneie}" == "Y" ]] ; then
            echo "Deleting and cloning new ..."
            git clone https://$3/$1/$2.git ${defRepPath}/$3/$1/$2/repo
        elif [[ "${cloneie}" == "n" || "${cloneie}" == "N" ]] ; then
            echo "Nothing will happen ..."
        else
            echo "Invalid entry"
            exit 127
        fi

    fi
}

cloneWikiHTTPS()
{
    # wiki
    if [[ ! -d ${defRepPath}/$3/$1/$2/wiki ]] ; then
        mkdir -p ${defRepPath}/$3/$1/$2/wiki
        git clone https://$3/$1/$2.wiki.git ${defRepPath}/$3/$1/$2/wiki
    else
        echo "Directory exists. Delete and clone new? [y/n]"
        read -p ">>: " cloneie

        if [[ "${cloneie}" == "y" || "${cloneie}" == "Y" ]] ; then
            echo "Deleting and cloning new ..."
            git clone https://$3/$1/$2.wiki.git ${defRepPath}/$3/$1/$2/wiki
        elif [[ "${cloneie}" == "n" || "${cloneie}" == "N" ]] ; then
            echo "Nothing will happen ..."
        else
            echo "Invalid entry"
            exit 127
        fi

    fi
}

getInfo()
{
    https=false
    wiki=true

    # check whether to use https or ssh
    echo "Clone with HTTPS or SSH? [https/SSH]"
    read -p ">>: " httpsssh

    if [[ "${httpsssh}" == "https" ]] ; then
        echo "Using HTTPS"
        https=true
    elif [[ "${httpsssh}" == "" || "${httpsssh}" == "ssh" ]] ; then
        echo "Using SSH"
        https=false
    else
        echo "Invalid entry"
        exit 127
    fi

    # want to clone wiki ?
    echo "Do you want to clone the respective wiki as well? [Y/n]"
    read -p ">>: " clwiki

    if [[ "${clwiki}" == "n" || "${clwiki}" == "N" ]] ; then
        echo "Will not clone wiki"
        wiki=false
    elif [[ "${clwiki}" == "" || "${clwiki}" == "y" || "${clwiki}" == "Y" ]] ; then
        echo "Wiki will be cloned"
        wiki=true
    else
        echo "Invalid entry"
        exit 127
    fi

    # check gitlab server
    echo "Default to ${defServer}? [Y/n]"
    read -p ">>: " gliub

    if [[ "${gliub}" == "n" || "${gliub}" == "N" ]] ; then
        echo "Please enter a URL to your git provider"
        read -p ">>: " gprov
        server=${gprov}
    elif [[ "${gliub}" == "" || "${gliub}" == "y" || "${gliub}" == "Y" ]] ; then
        echo "Defaulting to ${defServer}"
        server=${defServer}
    else
        echo "Invalid entry"
        exit 127
    fi

    echo "What is the Group name? If you do not want to clone a repository of a group, give your username here!"
    read -p ">>: " tmpGroup
    echo "What is the repository's name? [NEEDED]"
    read -p ">>: " tmpRepo

    if [[ ${https} == true ]] ; then
        if [[ ${wiki} == false ]] ; then
            echo "Cloneing Repository '${tmpRepo}' in group '${tmpGroup}' via HTTPS at '${server}'."
            cloneRepoHTTPS ${tmpGroup} ${tmpRepo} ${server}
        else
            echo "Cloneing Repository '${tmpRepo}' in group '${tmpGroup}' via HTTPS at '${server}' with wiki."
            cloneRepoHTTPS ${tmpGroup} ${tmpRepo} ${server}
            cloneWikiHTTPS ${tmpGroup} ${tmpRepo} ${server}
        fi
    elif [[ ${https} == false ]] ; then
        if [[ ${wiki} == false ]] ; then
            echo "Cloneing Repository '${tmpRepo}' in group '${tmpGroup}' via SSH at '${server}'."
            cloneRepoSSH ${tmpGroup} ${tmpRepo} ${server}
        else
            echo "Cloneing Repository '${tmpRepo}' in group '${tmpGroup}' via SSH at '${server}' with wiki."
            cloneRepoSSH ${tmpGroup} ${tmpRepo} ${server}
            cloneWikiSSH ${tmpGroup} ${tmpRepo} ${server}
        fi
    else
        echo "Something went wrong!"
        exit 127
    fi
}

while getopts "cdhpsv" opt; do
    case $opt in
        c)
            #echo "-a was triggered, Parameter: $OPTARG" >&2
            checkConfig
            exit 0
            ;;
        d)
            # delete config file
            echo "Do you really with to permanently delete your config file? [y/N]"
            read -p ">>: " delcfg

            if [[ "${delcfg}" == "y" || "${delcfg}" == "Y" ]] ; then
                echo "Deleting config file"
                $(rm -rf ${confDir})
            else
                echo "Config files will not be removed."
            fi
            exit 0
            ;;
        h)
            # displays all flags (help)
            myGitlabCloneNew -v
            echo ""
            echo "Usage:"
            echo "    myGitlabClone [OPTIONS]"
            echo ""
            echo "Valid options are:"
            echo "    -c"
            echo "        Recheck your config"
            echo ""
            echo "    -d"
            echo "        Delete your whole config directory in ${confDir}/${confFile}"
            echo ""
            echo "    -h"
            echo "        Print this help"
            echo ""
            echo "    -p"
            echo "        Print the current configuration"
            echo ""
            echo "    -s"
            echo "        Work through the configuration again"
            echo ""
            echo "    -v"
            echo "        Print the version number"
            echo ""
            echo "Configuration values:"
            echo "    defServer [String]"
            echo "        The default git server (e.g. github.com)"
            echo ""
            echo "    useRepPath [True|False]"
            echo "        Whether to use a default path where to store all your repositories cloned with this tool."
            echo ""
            echo "    defRepPath [String]"
            echo "        The default path. Has to be empty string if \${useRepPath} == false to prevent malfunction."

            exit 0
            ;;
        p)
            # print config
            if [[ ! -e ${confDir} ]] ; then
                echo "No config file present, aborting!"
                exit 127
            else
                tmp1=$(cat ${confDir}/${confFile} | sed -n 1p)
                tmp2=$(cat ${confDir}/${confFile} | sed -n 2p)
                tmp3=$(cat ${confDir}/${confFile} | sed -n 3p)

                echo -e "Default Server: \n\t ${tmp1}"
                echo -e "Use default repository path: \n\t ${tmp2}"
                echo -e "Default repository path: \n\t ${tmp3}"
            fi
            exit 0
            ;;
        s)
            # set config
            setConfig
            ;;
        v)
            # print version
            echo "myGitLabClone ${version} -- author: hringriin (https://github.com/hringriin)"
            exit 0
            ;;
        \?)
            #echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            #echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

checkConfig
checkLink
getInfo

echo "Exiting normally"

exit 0

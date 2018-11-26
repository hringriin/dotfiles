#!/bin/zsh
# subnet.zsh
#
# select one of the listed devices to check all domain names of hosts in your
# current network

echo -e "What is your device? Enter the number only!"
devices=($(ip addr | grep -E "^[0-9]+:" | awk '{print $1 $2}' | sed -e 's/:$//' | tr " " "\n"))

for i in ${devices[@]} ; do
    echo $i
done

read -r theDev

if [[ ${theDev} -lt 1 ]] ; then
    exit 0
fi

theDevName=$(echo ${devices[${theDev}]} | sed -e 's/:/ /' | awk '{print $2}')

myIP=$(ip addr show ${theDevName} | grep -E "inet[^0-9]" | awk '{print $2}')

if [[ -z ${myIP} ]] ; then
    echo "No IP assigned to device ${theDevName}"
    exit 1
fi

netAddr=$(ipcalc -b ${myIP} | grep Network | awk '{print $2}' | sed -e 's/\/[0-9]*//' | sed -e 's/\./ /g')
broadAddr=$(ipcalc -b ${myIP} | grep Broadcast | awk '{print $2}' | sed -e 's/\./ /g')

firstMin=$(echo ${netAddr} | awk '{print $1}')
firstMax=$(echo ${broadAddr} | awk '{print $1}')
secondMin=$(echo ${netAddr} | awk '{print $2}')
secondMax=$(echo ${broadAddr} | awk '{print $2}')
thirdMin=$(echo ${netAddr} | awk '{print $3}')
thirdMax=$(echo ${broadAddr} | awk '{print $3}')
fourthMin=$(echo ${netAddr} | awk '{print $4}')
fourthMax=$(echo ${broadAddr} | awk '{print $4}')

echo -e "Starting ...\n\\n\nn"

for i in {${firstMin}..${firstMax}}.{${secondMin}..${secondMax}}.{${thirdMin}..${thirdMax}}.{${fourthMin}..${fourthMax}} ; do
    a=$(dig +short -x $i | sed -e 's/^/    /m' )

    if [[ -n $a ]] ; then
        printf "\e[1;33m$i\e[0m: \n\e[0;36m%s\e[0m\n" "$a"
    fi
done

echo -e "\n\n... finished!"

unset devices
unset theDev
unset theDevName
unset myIP
unset netAddr
unset broadAddr
unset firstMin firstMax
unset secondMin secondMax
unset thirdMin thirdMax
unset fourthMin fourthMax

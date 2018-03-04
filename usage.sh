                  ####################################################################################################
                  #                                        Usage.sh                                                  #
                  # Written by Ali Hallaji                                                                           #
                  # If any bug, report me in my Github page at below                                                 #
                  # Free to use/edit/distribute the code below by                                                    #
                  # giving proper credit to Author                                                                   #
                  #                                                                                                  #
                  ####################################################################################################
#! /bin/bash
# unset any variable which system may be using

# clear the screen
clear

unset constant_cmd os architecture kernelrelease internalip externalip nameserver loadaverage

while getopts iv name
do
        case $name in
          i)iopt=1;;
          v)vopt=1;;
          *)echo "Invalid arg";;
        esac
done

if [[ ! -z $iopt ]]
then
{
wd=$(pwd)
basename "$(test -L "$0" && readlink "$0" || echo "$0")" > /tmp/scriptname
scriptname=$(echo -e -n $wd/ && cat /tmp/scriptname)
su -c "cp $scriptname /usr/bin/monitor" root && echo "Congratulations! Script Installed, now run monitor Command" || echo "Installation failed"
}
fi

if [[ ! -z $vopt ]]
then
{
echo -e "This script shows you most usage of Linux OS resources"
}
fi

if [[ $# -eq 0 ]]
then
{


# Define Variable constant_cmd
constant_cmd=$(tput sgr0)

# Check if connected to Internet or not
ping -c 1 google.com &> /dev/null && echo -e '\E[32m'"Internet: $constant_cmd Connected" || echo -e '\E[32m'"Internet: $constant_cmd Disconnected"

# Check OS Type
os=$(uname -o)
echo -e '\E[32m'"Operating System Type :" $constant_cmd $os

# Check OS Release Version and Name
cat /etc/os-release | grep 'NAME\|VERSION' | grep -v 'VERSION_ID' | grep -v 'PRETTY_NAME' > /tmp/osrelease
echo -n -e '\E[32m'"OS Name :" $constant_cmd  && cat /tmp/osrelease | grep -v "VERSION" | cut -f2 -d\"
echo -n -e '\E[32m'"OS Version :" $constant_cmd && cat /tmp/osrelease | grep -v "NAME" | cut -f2 -d\"

# Check Architecture
architecture=$(uname -m)
echo -e '\E[32m'"Architecture :" $constant_cmd $architecture

# Check Kernel Release
kernelrelease=$(uname -r)
echo -e '\E[32m'"Kernel Release :" $constant_cmd $kernelrelease

# Check hostname
echo -e '\E[32m'"Hostname :" $constant_cmd $HOSTNAME

# Check Cpu Usage
#cpuUsage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
cpuUsage=$(cat <(grep 'cpu ' /proc/stat) <(sleep 1 && grep 'cpu ' /proc/stat) | awk -v RS="" '{print ($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5) "%"}')
echo -e '\E[32m'"Cpu Usage :" $constant_cmd $cpuUsage

# Check Internal IP
internalip=$(hostname -I)
echo -e '\E[32m'"Internal IP :" $constant_cmd $internalip

# Check External IP
#externalip=$(curl -s ipecho.net/plain;echo)
#echo -e '\E[32m'"External IP : $constant_cmd "$externalip

# Check DNS
nameservers=$(cat /etc/resolv.conf | sed '1 d' | awk '{print $2}')
echo -e '\E[32m'"Name Servers :" $constant_cmd $nameservers 

# Check Logged In Users
who>/tmp/who
echo -e '\E[32m'"Logged In users :" $constant_cmd && cat /tmp/who 

# Check RAM and SWAP Usages
free -h | grep -v + > /tmp/ramcache
echo -e '\E[32m'"Ram Usages :" $constant_cmd
cat /tmp/ramcache | grep -v "Swap"
echo -e '\E[32m'"Swap Usages :" $constant_cmd
cat /tmp/ramcache | grep -v "Mem"

# Check Disk Usages
#df -h| grep 'Filesystem\|/dev/mmcblk0p*' > /tmp/diskusage
#df -h| grep 'Filesystem\|/dev/root*' >> /tmp/diskusage
df -h| grep 'Mounted on\|/' > /tmp/diskusage
#sed -e '3d' /tmp/diskusage > /tmp/diskusage1
echo -e '\E[32m'"Disk Usages :" $constant_cmd 
cat /tmp/diskusage

# Check Load Average
loadaverage=$(top -n 1 -b | grep "load average:" | awk '{print $10 $11 $12}')
echo -e '\E[32m'"Load Average :" $constant_cmd $loadaverage

# Check System Uptime
tecuptime=$(uptime | awk '{print $3,$4}' | cut -f1 -d,)
echo -e '\E[32m'"System Uptime Days/(HH:MM) :" $constant_cmd $tecuptime

# Unset Variables
unset constant_cmd os architecture kernelrelease internalip externalip nameserver loadaverage

# Remove Temporary Files
rm /tmp/osrelease /tmp/who /tmp/ramcache /tmp/diskusage
}
fi
shift $(($OPTIND -1))

#!/bin/bash

INET=eth0
IP=$(ip a | grep eth0 -A 4 | grep '\<inet\>' | awk '{print $2}')
#while read GW
#do
#    nmcli con add type ethernet con-name ${INET} ifname ${INET} ip4 "${IP}" gw4 "${GW}"
#    ls
#done < $1
for GW in $(cat gw.txt)
do
    nmcli con delete ${INET}
    nmcli con reload
    nmcli con add type ethernet con-name ${INET} ifname ${INET} ip4 "${IP}" gw4 "${GW}"
    nmcli con reload
    nmcli con up ${INET}
    if [ $? -eq 0 ];then
        ping -c 3 -W 3 ${IP} &> /dev/null
        if [ $? -eq 0];then
            echo "${IP}\tis OK" >> ok.txt
        else
            echo "${IP}\tis not OK" >>fail.txt
        fi
    else
        echo "Please check config."
    fi
    flag=true
    while flag
    do
        STAT=$(ip a |grep "${INET}:"|awk -F "<" '{print $3}'|awk -F "," 'print {$1}')
        if [ STAT != "UP" ];then
            sleep 15
            flag=true
        else
            flag=false
        fi
    done
done

#!/bin/bash
for IP in $(cat /home/admin/shtest/ip.text)
do
    ping -c 5 -w 3 $IP
    if [ $? -eq 0 ];then
        echo "$IP is online"
    else
        echo "$IP is offline"
    fi
done

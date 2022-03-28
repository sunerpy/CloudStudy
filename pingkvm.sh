#!/bin/bash
hostname_prefix=$1
host_num=$2
for i in $(seq ${host_num})
do
    host_name=${hostname_prefix}$i
    ping -c 4 -w 2 -i 0.1 ${host_name}
    wait
done

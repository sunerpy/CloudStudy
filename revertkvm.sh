#!/bin/bash
hostname_prefix=$1
host_num=$2
for i in $(seq ${host_num})
do
    host_name=${hostname_prefix}$i
    sudo virsh snapshot-list ${host_name}|grep shutoff|sed -r 's/^( *)(.*)( *)([0-9]{4}-[0-9]{2}-[0-9]{2})(.*)/\2/'
    wait
done

#!/bin/bash
#**************************************************************#
# File Name: ping_ip_file.sh
# Version: 0.0.1
# Date: 0.1
# Author: zsn
# Remark: 从IP文本获取IP进行连通性测试
#**************************************************************#
NUM=20 #控制进程数

errcode() {
    echo "$1"
    case $2 in
    1)
        exit
        ;;
    *)
        echo "$2"
        ;;
    esac
}

multi_ping() {
    ping -c2 -i0.1 -W1 "$1" &>/dev/null
    if [[ $? -eq 0 ]]; then
        echo -e "$1\t$2\tis up." >>"${TMPFILE}"
    else
        echo -e "$$1\t$2\tis down." >>"${TMPFILE}"
    fi
}

SCRIPT_PATH=${0%/*}
if [[ "X${SCRIPT_PATH}" == "X$0" || "X${SCRIPT_PATH}" == "X." ]]; then
    SCRIPT_PATH=$(pwd)
else
    SCRIPT_PATH=$(pwd)/${SCRIPT_PATH}
fi

SCRIPT_PATH=${SCRIPT_PATH}/tmpfile
if [[ ! -d ${SCRIPT_PATH} ]]; then
    mkdir "${SCRIPT_PATH}"
else
    errcode "Directory is existing!"
fi
read -r -p "Please input your ip file: " IPFILE
PIPEFILE=${SCRIPT_PATH}/multiping_$$.tmp
TMPFILE=${SCRIPT_PATH}/$(date +%Y%m%d_%H%M%S).tmp
touch "${TMPFILE}"
FINALRECORD=${TMPFILE%tmp}file
touch "${FINALRECORD}"

mkfifo "${PIPEFILE}"
exec 120<>"${PIPEFILE}"
for i in $(seq $NUM); do
    echo "" >&120 &
done

while read -r line; do
    read -r -u120
    {
        vmName=$(echo "$line" | awk '{print $1}')
        proIp=$(echo "$line" | awk '{print $2}')
        multi_ping "${vmName}" "${proIp}"
        echo "" >&120
    } &
done <"${IPFILE}"
wait
exec 120>&-
exec 120<&-
rm -rf "${PIPEFILE}"
sort "${TMPFILE}" -r -k 3 -u >"${FINALRECORD}"
rm -rf "${TMPFILE}"
cat "${FINALRECORD}"

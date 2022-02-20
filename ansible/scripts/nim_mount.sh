#!/bin/bash
export LANG=en_US.utf-8
##########################################################################
#    @File    :   nim_mount.sh
#    @Time    :   2022/02/19 21:23:57
#    @Author  :   sunerpy
#    @Version :   1.0
#    @Contact :   sunerpy<nkuzhangshn@gmail.com>
#    @Desc    :   None

LOGFILE=/tmp/acrs_$(date +%Y%m%d).log
date >"${LOGFILE}"
appUser=$1


logDebug() {
    debugMsg=$1
    echo "[DEBUG] [$(date "+%Y-%m-%d %H:%M:%S")] ${debugMsg} " >>"${LOGFILE}"
}

logINfo() {
    infoMsg=$1
    echo "[INFO]  [$(date "+%Y-%m-%d %H:%M:%S")] ${infoMsg} " >>"${LOGFILE}"
}

logError() {
    errorMsg=$1
    if [ -n "$2" ]; then
        exitCode=$2
    else
        exitCode=1
    fi
    echo "[ERROR] [$(date "+%Y-%m-%d %H:%M:%S")] ${errorMsg} " >>"${LOGFILE}"
    exit "${exitCode}"
}

suCmd() {
    osuser=$1
    cmd=$2
    su - "${osuser}" -c "${cmd}"
}

yumInstall() {
    sn=$1
    sb=$2
    alreadyInstalled=$(rpm -qa | grep -c "^${sn}-[0-9].*\.${sb}$")
    if [ "$alreadyInstalled" -eq 0 ]; then
        yum install "$1"."$2" -y >>"${LOGFILE}" 2>&1
        return $?
    else
        echo "$sn.$sb 已安装"
        return 0
    fi
}

osCheck() {
    :
}

ipJudge() {
    :

}

jrscYqPath=/home/dbbackup01/jrsc1/backup/
jrscNhPath=/home/dbbackup01/jrsc/
yqNim=128.199.31.124
nhNim=128.200.20.33
mountPath=/home/dbbackup
if [ ! -d ${mountPath} ]; then
    mkdir ${mountPath}
else
    mount -l | grep "${mountPath}"

fi

chmod -R 777 ${mountPath}
#!/bin/bash
export LANG=en_US.utf-8
##########################################################################
#    @File    :   update_bsdate.sh
#    @Time    :   2022/02/18 23:45:30
#    @Author  :   sunerpy
#    @Version :   1.0
#    @Contact :   sunerpy<nkuzhangshn@gmail.com>
#    @Desc    :   None

LOGFILE=/tmp/acrs.log
date >${LOGFILE}

appUser=$1
envLine=$2
dbChange=$3
dbSid=$4

logDebug() {
    msg=$1
    echo "[DEBUG] [$(date "+%Y-%m-%d %H:%M:%S")] ${msg} " >>${LOGFILE}
}

logINfo() {
    msg=$1
    echo "[INFO]  [$(date "+%Y-%m-%d %H:%M:%S")] ${msg} " >>${LOGFILE}
}

logError() {
    msg=$1
    echo "[ERROR] [$(date "+%Y-%m-%d %H:%M:%S")] ${msg} " >>${LOGFILE}
}

acrsExit() {
    exitCode=$1
    logINfo "任务日志${LOGFILE}"
    exit "${exitCode}"
}

suCmd() {
    osuser=$1
    cmd=$2
    su - "${osuser}" -c "${cmd}"
}

getMedia() {
    file=$1
    filename=$(echo "$file" | awk -F '/' '{print $NF}')
    if [ -f "$filename" ]; then
        rm -f "$filename"
        if [ $? -ne 0 ]; then
            logError "清理已存在介质文件失败"
            return 1
        fi
    fi
    logDebug "开始下载$file"
    logDebug "使用洋桥介质库站点"
    filePath="http://128.199.43.67:1080/media/upload/zsn/$file"
    
    wget -t 2 --connect-timeout=20 "$filePath" &>/dev/null
    if [ $? -ne 0 ]; then
        logError "文件$file下载失败."
        return 1
    else
        logDebug "文件$file下载成功."
    fi
}

if [ $(id -u "$appUser") -eq 0 ]; then
    logError "The user cannot be root!"
    acrsExit 1
fi
dateDir=/opt/biz_date
if [ -d ${dateDir} ]; then
    if [ ! -d ${dateDir}_$(date +%Y%m%d) ]; then
        mv ${dateDir} ${dateDir}_$(date +%Y%m%d)
        mkdir ${dateDir}
    fi
else
    mkdir ${dateDir}
fi
cd ${dateDir} || acrsExit 2
bsdateFile="xxxx${envLine}.tar.gz"
getMedia "jrsc/bsdate/${bsdateFile}"
tar xf "${bsdateFile}"


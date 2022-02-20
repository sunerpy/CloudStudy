#!/bin/bash
export LANG=en_US.utf-8
##########################################################################
#    @File    :   update_bsdate.sh
#    @Time    :   2022/02/18 23:45:30
#    @Author  :   sunerpy
#    @Version :   1.0
#    @Contact :   sunerpy<nkuzhangshn@gmail.com>
#    @Desc    :   None
#   user_scripts/zhangshaonan.zh/update_bsdate.sh {{appUser}} {{envLine}} {{dbChange}} {{dbSid}}
LOGFILE=/tmp/acrs.log
date >${LOGFILE}

appUser=$1
envLine=$2
dbChange=$3
dbSid=$4
envLine=$(echo "$envLine" | tr '[:upper:]' '[:lower:]')

logDebug() {
    debugMsg=$1
    echo "[DEBUG] [$(date "+%Y-%m-%d %H:%M:%S")] ${debugMsg} " >>${LOGFILE}
}

logINfo() {
    infoMsg=$1
    echo "[INFO]  [$(date "+%Y-%m-%d %H:%M:%S")] ${infoMsg} " >>${LOGFILE}
}

logError() {
    errMsg=$1
    if [ -n "$2" ]; then
        exitCode=$2
    else
        exitCode=1
    fi
    echo "[ERROR] [$(date "+%Y-%m-%d %H:%M:%S")] ${errMsg} " >>${LOGFILE}
    exit "${exitCode}"
}

suCmd() {
    osuser=$1
    cmd=$2
    su - "${osuser}" -c "${cmd}"
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

#Parameters judge:
if [ $# -ne 4 ] && [ $# -ne 3 ]; then
    logError "Parameters wrong."
fi

id -u "${appUser}" &>/dev/null
if [ $? -ne 0 ] || [ $(id -u "$appUser") -eq 0 ]; then
    logError "The user ${appUser} is not existting. "
fi

envRanges=(pl1 pl2 pl3 pl4 vt)
envNum=0
for envRange in "${envRanges[@]}"; do
    if [ "${envLine}" == "${envRange}" ]; then
        envNum+=1
        break
    fi
done

if [ ${envNum} -ne 1 ]; then
    logError "Env is out of range."
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

cd ${dateDir} || logError "${dateDir} maybe is not existting."
if [ "${dbChange}" == "Y" ]; then
    #oracle judge
    suCmd oracle "sqlplus ${dbSid}"
    oracleJudge=1
    bsdateFile="xxxx${envLine}.tar.gz"
elif [ "${dbChange}" == "N" ]; then
    bsdateFile="xxxx${envLine}.tar.gz"
else
    logError "Parameters wrong"
fi

getMedia "jrsc/bsdate/${bsdateFile}"
tar xf "${bsdateFile}"
sed -i "/APP_USER/cAPP_USER=$appUser"
if [ ${oracleJudge} -eq 1 ]; then
    sed -i "/db_conn/cdb_conn_inf=${dbSid}"
fi

logINfo "Success!"

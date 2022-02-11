#!/bin/bash
#author
[[ $(id -u) != "0" ]] && { echo "错误": 该脚本需要以root权限执行。（ERROR：1010）; exit 10;}

set -o errexit
set -o nounset

CURRENTDIR=$(pwd)
#固定用户
ACCOUNT="cloud"
#产品型号
PRODUCT_TYPE="NF-7400L"
PORT=10080
PROXY=

#通信端口
ARRAY_PORT=(10080 10443)
#通信IP池
ARRAY_IP=(11.35.7.43 11.35.7.44 11.35.7.45 11.35.7.46 11.35.7.47 11.35.7.48)
#随即获取IP池的某个IP
ran_num=$[RANDOM%6]
IP="${ARRAY_IP[$ran_num]}"
#随即获取1-6的值，用户安装前的睡眠时间
SLEEP_TIME=$[RANDOM%6+1]

check_port(){
    CIP=$1
    CPORT=$2
    CONN="Escape character is '^]'"

    echo "端口检查:SIP:$CIP 端口:$CPORT"
    RESULT=`echo ""|telnet $CIP $CPORT`
    if [[ $RESULT == *$CONN* ]];then
        echo "SIP:$CIP 端口:$CPORT 可以正常连接"
    else
        echo "SIP:$CIP 端口:$CPORT 无法正常连接"
    fi
}

check_url_port(){
    HASPORT=`echo $1|grep :`
    if [[ $HASPORT == "" ]];then
        IP=$1
        check_port ${IP} ${ARRAY_PORT[0]}
        check_port ${IP} ${ARRAY_PORT[1]}
    else
        IP=`echo $1 | sed -e "s/:/ /" |awk '{print $1}'`
        check_port ${IP} ${ARRAY_PORT[0]}
        check_port ${IP} ${ARRAY_PORT[1]}
    fi
}

check_os(){
    OS_BIT=$(getconf LONG_BIT)

    #获取Centos,RedHat版本
    if [[ -r /etc/redhat-release ]];then
        eval $(awk '/release/ {for(i=1;i<=NF;i++) if($i ~ /[0-9.]+/) {print "OS="$1"\nOS_VERSION="$i}}' /etc/redhat-release )
        [[ "$OS" == "Red" ]] && OS="RedHat"
        [[ -n "$OS" && -n "$OS_VERSION" ]] && return
    fi

    error "脚本暂不支持此系统。（ERROR:1011）" 11
}

install_depends(){
    echo "安装依赖包，请确认存在软件源"
    case "${OS}" in
        "CentOS"|"RedHat")
            packages="pciutils dmidecode net-tools psmisc mlocaate lsof zip"
            for i in $packages;do
                rpm -q $i &> /dev/null || {
                    echo "安装依赖包 $i ..."
                    yum install -y $i > /dev/null || error "依赖安装失败。（ERROR:1006）"  6
                }
            done
            ;;
    esac
}

check_url(){
    [[ -n ${soft_url:-} ]] && return
    name="$2"
    url="$1$2"
    echo "$url"

    code=$(curl -sgk | $url -w %{http_code} -o /dev/null ||:)
    if [[ $code == 200 ]] ;then
        soft_name=$name
        soft_url=$url
    fi
}

set_python_path(){
    if command -v python &> /dev/null;then
        python_path=$(which python)
        return
    else
        error "当前系统未发现python,请安装后重试。(ERROR:1014)" 14
    fi
}

error(){
    echo "错误：$1"
    clean
    [[ "$2" > 0 ]] && exit $2
    exit 1
}

clean(){
    [[ -d "$tmp_dir" ]] && rm -rf $tmp_dir
}

sdserver_install(){
    set_python_path
    case "$WEB_TYPE" in
        "web_no")
            echo "安装主机安全轻量化agent"
            #disable_selinux
            tmp_dir=$CURRENTDIR/sdserver_installer_$(date +%s)
            ;;
    esac
    mkdir -p $tmp_dir
    pushd $tmp_dir > /dev/null
    if [[ -z "$ACCOUNT" ]];then
        check_url "http://$IP:${ARRAY_PORT[0]}/safe/soft/" "$soft_name" 
        check_url "https://$IP:${ARRAY_PORT[1]}/safe/soft/" "$soft_name"
    elif [[ -z "$PRODUCT_TYPE" ]];then
        check_url "http://$IP:${ARRAY_PORT[0]}/safe/soft/agents/" "${ACCOUNT}-$soft_name" 
        check_url "https://$IP:${ARRAY_PORT[1]}/safe/soft/agents/" "${ACCOUNT}-$soft_name" 
    else
        check_url "http://$IP:${ARRAY_PORT[0]}/safe/soft/agents/$PRODUCT_TYPE/" "${ACCOUNT}-$soft_name" 
        check_url "https://$IP:${ARRAY_PORT[1]}/safe/soft/agents/$PRODUCT_TYPE/" "${ACCOUNT}-$soft_name" 
        check_url "http://$IP:${ARRAY_PORT[0]}/safe/soft/agents/$PRODUCT_TYPE/" "${ACCOUNT}-safedog_$soft_name" 
        check_url "https://$IP:${ARRAY_PORT[1]}/safe/soft/agents/$PRODUCT_TYPE/" "${ACCOUNT}-safedog_$soft_name" 
    fi
    if [[ -f $CURRENTDIR/$soft_name ]];then
        echo "当前目录已存在文件：$soft_name,将使用该文件安装"
        cp $CURRENTDIR/$soft_name $soft_name
    else
        if [[ -z ${soft_url:-} ]];then
            error "客户端检查失败，请检查服务器IP配置是否正确。(ERROR:1012)" 12
        else
            echo "下载客户端： $soft_url"
            sleep $SLEEP_TIME && echo "$SLEEP_TIME"
            curl -sgk $soft_url -o $soft_name
        fi
    fi
    tar xzf $soft_name
    cd $(tar tzf $soft_name | head -1)
    if [[ -d "/etc/safedog/sdcc/" ]];then
        cp ./install_files/sdcc/conf/safedog_user.psf /etc/safedog/sdcc/ -f
    fi

    chmod +x ./install.py
    if [[ $WEB_TYPE == web_no ]] ;then
        if [[ -n $(find install_files -maxdepth 1 -type d -name "safedog_apache*" -or -name "safedog_java*") ]];then
            $python_path ./install.py -s $IP:$PORT -w web_no $PROXY
        else
            $python_path ./install.py -s $IP:$PORT $PROXY
        fi
    else
        $python_path ./install.py -s $IP:$PORT -w $WEB_TYPE $PROXY
    fi
    popd > /dev/null
    clean
}

OS_BIT=$(getconf LONG_BIT)
WEB_TYPE="web_no"
[[ $OS_BIT == 64 ]] && PRODUCT_TYPE=${PRODUCT_TYPE}64
soft_name=${PRODUCT_TYPE}.tar.gz
sdserver_install


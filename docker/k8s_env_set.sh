#!/bin/bash
export LANG=en_US.utf-8
##########################################################################
#    @File    :   k8s_env_set.sh
#    @Time    :   2022/02/09 11:56:00
#    @Author  :   sunerpy
#    @Version :   1.0
#    @Contact :   sunerpy<nkuzhangshn@gmail.com>
#    @Desc    :   None

LOGFILE=/tmp/acrs.log
date >${LOGFILE}

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
    logINfo "任务日志LOGFILE"
    exit "${exitCode}"
}


#eg: sh hosts_set.sh k8snode 3 192.168.122.246
hosts_name=$1
host_num=$2
ip_init=$3

add_ssh_key() {
    local node_name
    node_name=$1
expect <<EOF
set timeout 60
spawn ssh-copy-id -i /home/admin/.ssh/id_rsa.pub "${node_name}"
expect {
"yes/no" {send "yes\r";exp_continue}
"password" {send "redhat\r"}
}
expect eof
EOF
}

check_ssh_key() {
    local host_nameid
    host_nameid=$1
    ssh "${host_nameid}" -o StrictHostKeyChecking=no -o ConnectTimeout=3 -o PreferredAuthentications=publickey date &>/dev/null
    if [ $? -eq 0 ]; then
        logDebug "${host_nameid} has been added."
        return 0
    else
        logDebug "${host_nameid} hasn't been added. Just wait a moment.  "
        return 2
    fi

}
set_env() {
    for i in $(seq "${host_num}"); do
        host_tmp=${hosts_name}$i
        # shellcheck disable=SC2086
        ip_tmp=$(echo "${ip_init}" | awk -F "." 'BEGIN{OFS="."} $4=($4-"'$i'"+1) {print $0 }')
        ip_record=$(echo "${ip_tmp}" | awk -F "." 'BEGIN{OFS="."} $4=($4+1) {print $0 }')
        sudo sed -i "/${host_tmp}/d" /etc/hosts
        sudo sed -i "/${ip_record}/a ${ip_tmp} ${host_tmp}" /etc/hosts
        grep -oqE "${host_tmp}|${ip_tmp}" ~/.ssh/config
        if [ $? -ne 0 ]; then
            {
                echo -e "\nHost ${host_tmp}"
                echo -e "Hostname ${ip_tmp}"
                echo -e "Port 22"
                echo -e "User root"
            } >>~/.ssh/config
        fi
        check_ssh_key "${host_tmp}"
        if [ $? -ne 0 ];then
            add_ssh_key "${host_tmp}"

        fi
    done
}

checkIpforward() {
    pass
    local checknum
    checknum=$(sysctl -a | awk -F "[ =]" '/net.ipv4.ip_forward[ =]/{print $NF}')
    if [ "${checknum}" -ne 1 ]; then
        
cat <<EOF >/etc/sysctl.d/docker.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward=1
EOF
        sysctl -p /etc/sysctl.d/docker.conf
    fi
}

installDocker() {
    yum -y install yum-utils
    yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/Centos-7.repodocker-ce.repo
    yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
}

if [ $# -ne 3 ]; then
    echo "Arguments Error!"
    echo "# sh hosts_set.sh k8snode 3 192.168.122.246"
    exit 1
fi
set_env
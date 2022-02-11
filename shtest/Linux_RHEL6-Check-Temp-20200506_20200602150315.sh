#!/bin/bash
LANG=en_us
if [ -n "$1" ];then
	while getopts :n: opt
	do
		case $opt in
			n)HCResult=$OPTARG
			  ;;
			*)echo "unknown options! script stop!"
			  echo "Usage:"
			  echo "$0 -n <config_log_path>"
			  exit
			  ;;
		esac
	done
fi

echo CES_HC_ITEM_KEY=ac041734-fcea-468b-a9f8-84ff0e9fea25 >> $HCResult
cat >>/tmp/CES_HC_ITEMaac041734fcea468ba9f884ff0e9fea25.sh <<CES_EVO_HC_EOF
mcefile=/var/log/mcelog
count1=\`cat \$mcefile |wc -l\`
if [ ! -f \$mcefile ] 
then
	echo "\$mcefile:true"
elif [ \$count1 = 0 ]
then
	echo "\$mcefile:ture"
else
	echo "\$mcefile:false"
fi
count2=\`tail -10000 /var/log/messages | grep -iE "error|fail|Machine Check Exception|Out of memory|soft lockup|EXT4-fs error|qla2xxx|Failing path|Kernel panic" |grep -Ev "failed to assign|sftp-server"|wc -l\`
if [ \$count2 = 0 ]
then
	echo "/var/log/messages:true"
else
	echo "/var/log/messages:false"
fi
count3=\`cat /var/log/dmesg | grep -iE "error|fail|Machine Check Exception|Out of memory|soft lockup| I\/O error|EXT4-fs error|qla2xxx|Failing path|Kernel panic|NIC Link is Down" | grep -v "failed to assign"|wc -l\`
if [ \$count3 = 0 ]
then
        echo "/var/log/dmesg:true"
else
        echo "/var/log/dmesg:false"
fi
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMaac041734fcea468ba9f884ff0e9fea25.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMaac041734fcea468ba9f884ff0e9fea25.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=7b8cf167-bcdb-41f9-8bcb-d4d8c66c8ee6 >> $HCResult
cat >>/tmp/CES_HC_ITEMa7b8cf167bcdb41f98bcbd4d8c66c8ee6.sh <<CES_EVO_HC_EOF
#Uninteruptible sleep
N=\` ps axo user,pid,%cpu,%mem,rss,stat,time,command | grep -e '^[Dd]\$' |wc -l\`
if [ \$N = 0 ];then
        echo "Uninteruptible sleep processes,\$N,1"
else
        echo "Uninteruptible sleep processes,\$N,0"
fi
#Defunct processes
M=\` ps axo user,pid,%cpu,%mem,rss,stat,time,command | grep -e '^[Zz]\$' |wc -l\`
if [ \$M = 0 ];then
        echo "Defunct processes,\$N,1"
else
        echo "Defunct processes,\$N,0"
fi
#Time zone
K=\`grep ZONE /etc/sysconfig/clock | awk -F'"' '{print \$2}'\`
if [ \$K == 'Asia/Shanghai' ];then
        echo "Time zone,\$K,1"
else
        echo "Time zone,\$K,0"
fi
#NTP
L1=\`ntpstat 2>/dev/null| grep synchronised|awk '{print \$1}'\`
ntpstat >/dev/null 2>&1
N1=\$?
crontab  -l| grep ntpdate >/dev/null 2>&1
N2=\$?
#if [[ -n \$L && \$L == 'synchronised' ]];then
if [ \$N1 = 0 ];then
        echo "NTP synchronized,use ntpd \$L1,1"
elif [ \$N1 = 1 ];then
        echo "NTP synchronized,use ntpd \$L1,0"
elif [[ \$N1 == 2 && \$N2 == 0 ]];then
        echo "NTP synchronized,use ntpdate:\$(crontab  -l| grep ntpdate 2>/dev/null),1"
else
        echo "NTP synchronized,not config,0"   

fi
#kdump
P=\`service kdump status | awk -F'is' '{print \$2}' | sed  's/^[ ]*//'\`
if [ "\$P" == 'operational' ];then
        echo "kdump service,\$P,1"
else
        echo "kdump service,\$P,0"
fi

#mce check
file=/var/log/mcelog
#count=\`cat \$file |wc -l\` 
if [ ! -f \$file ] 
then
        echo "mce log,normal,1"
elif [ \$(cat \$file |wc -l) = 0 ]
then
        echo "mce log,normal,1"
else
        echo "mce log,abnormal,0"
fi
#selinux check
stat=\`getenforce\`
if [ \$stat == 'Disabled' ];then
	echo "selinux service,\$stat,1"	
else

	echo "selinux service,\$stat,0"	
fi
#netif redundancy check
HOSTTYPE=\$(dmidecode -s system-product-name|awk '{print \$1}')
Teamc=\$(nmcli connection show 2>/dev/null | awk '\$3 == "team"  {print \$1}'| wc -l)
if [[ \$HOSTTYPE != "VMware" && \$HOSTTYPE != "KVM" ]];then
  if [ -e /proc/net/bonding ];then
        bond=\`ls  /proc/net/bonding\`
        count=\`ls  /proc/net/bonding |wc -l\`
  fi
  if [[ (! -e /proc/net/bonding || \$count = 0) && \$Teamc = 0 ]];then
        echo "netif redundancy,no,0"
   elif [[  -e /proc/net/bonding && \$count != 0 || \$Teamc != 0 ]];then
        echo "netif redundancy,normal,1"
  fi
else
  echo "netif redundancy,host is virtual,1"
fi
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa7b8cf167bcdb41f98bcbd4d8c66c8ee6.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa7b8cf167bcdb41f98bcbd4d8c66c8ee6.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=980b1ccf-66f5-46d3-b1a8-5a6bf18635d9 >> $HCResult
cat >>/tmp/CES_HC_ITEMa980b1ccf66f546d3b1a85a6bf18635d9.sh <<CES_EVO_HC_EOF
echo 8,2019-5-7,2024-5-7,2025-5-7,2029-5-7,TBD
echo 7,2014-6-10,2019-8-6,2020-8-6,2024-6-30,N/A
echo 6,2010-11-10,2016-5-10,2017-5-10,2020-11-30,2024-6-20
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa980b1ccf66f546d3b1a85a6bf18635d9.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa980b1ccf66f546d3b1a85a6bf18635d9.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=b090b92f-649b-4cd8-9473-0ba7513e03d9 >> $HCResult
cat >>/tmp/CES_HC_ITEMab090b92f649b4cd894730ba7513e03d9.sh <<CES_EVO_HC_EOF
echo "hostname:\$(hostname)"
echo "Product Name:\$(dmidecode |grep "Product Name:"|head -n 1| awk -F":" '{print \$2}')"
echo "Serial Number:\$(dmidecode -s system-serial-number)"
echo "UUID:\$(dmidecode -t 1 | grep UUID | awk '{print \$2}')"
echo "Arch:\$(uname -p)"
echo "CPUs:\$(cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l)"
echo "Total Memory:\`free -m|grep Mem|awk '{print \$2"MB"}'\`"
echo "IP address:\`ip a|grep -w inet|grep -v "127.0.0"|awk  '{print \$2}'|head -1\`"
echo "Distro:\$(head /etc/redhat-release)"
echo "OS kernel:\$(uname -r)"
echo "Runlevel:\$(runlevel)"
echo "Default Runlevel:\$(grep initdefault /etc/inittab | grep -v '^#' | cut -d ':' -f 2)"
echo "Uptime:\`cat /proc/uptime | awk '{print \$1/60"min"}'\` " 
echo "Local Time:\$(date '+%Y-%m-%d %H:%M:%S')" 
echo "Time zone:\$(grep ZONE /etc/sysconfig/clock | awk -F'"' '{print \$2}')"
echo "SELinux:\$(sestatus -v | grep "SELinux status" | awk -F":" '{print \$2}')"
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMab090b92f649b4cd894730ba7513e03d9.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMab090b92f649b4cd894730ba7513e03d9.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=ad09721a-732a-4f7c-9346-9adf236e3431 >> $HCResult
cat >>/tmp/CES_HC_ITEMaad09721a732a4f7c93469adf236e3431.sh <<CES_EVO_HC_EOF
echo "#Network card info"
lspci| grep "Ethernet controller"
echo "#HBA info"
lspci | grep "Fibre Channel"
echo "#Storage info"
lspci | grep "RAID bus controller"
lspci | grep "SCSI storage controller"
lspci | grep "SATA controller"
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMaad09721a732a4f7c93469adf236e3431.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMaad09721a732a4f7c93469adf236e3431.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=3f2768ad-30a3-4783-8a9e-8ae3d4d9bf05 >> $HCResult
cat >>/tmp/CES_HC_ITEMa3f2768ad30a347838a9e8ae3d4d9bf05.sh <<CES_EVO_HC_EOF
#cpu info
cat /proc/cpuinfo  | grep "model name"| uniq| awk -F : '{print "cpu modle," \$2}'
echo "Physical CPU Count, \`cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l\`"
echo "CPU Core Count,\`cat /proc/cpuinfo | grep "core id" | uniq | wc -l\`"
echo "Logical CPU Count,\`cat /proc/cpuinfo | grep "processor" | wc -l\`"
#cpu load
cat /proc/loadavg | awk '{print "cpu load," \$1,\$2,\$3}'
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa3f2768ad30a347838a9e8ae3d4d9bf05.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa3f2768ad30a347838a9e8ae3d4d9bf05.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=7c0c9554-e2cc-4734-bf21-8eabbf2a15c8 >> $HCResult
cat >>/tmp/CES_HC_ITEMa7c0c9554e2cc4734bf218eabbf2a15c8.sh <<CES_EVO_HC_EOF
vmstat  1 10| grep -v procs| grep -v  cache|cat -n | awk '{print \$1","\$2"," \$3 ","\$14","\$15","\$16 ","\$17"," \$18}'
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa7c0c9554e2cc4734bf218eabbf2a15c8.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa7c0c9554e2cc4734bf218eabbf2a15c8.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=bdca3ac2-f4f4-44dd-b35b-7c4b085ee142 >> $HCResult
cat >>/tmp/CES_HC_ITEMabdca3ac2f4f444ddb35b7c4b085ee142.sh <<CES_EVO_HC_EOF
cat /proc/meminfo  | awk '{print \$1 \$2}' | grep -E 'MemTotal|MemFree|MemAvailable|Buffers|^Cached|SwapTotal|SwapFree' 
cat /proc/meminfo  | grep 'HugePages_Total'| awk '{print \$1 \$2*1024*1024}'
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMabdca3ac2f4f444ddb35b7c4b085ee142.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMabdca3ac2f4f444ddb35b7c4b085ee142.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=d63fc3bc-a94a-4652-aed1-c34ac4a7fb53 >> $HCResult
cat >>/tmp/CES_HC_ITEMad63fc3bca94a4652aed1c34ac4a7fb53.sh <<CES_EVO_HC_EOF
free -m | sed -n '2p' | awk '{print "Percent_mem_used:"(\$3/\$2)*100"%"}'
free -m | sed -n '2p' | awk '{print "Percent_mem_buffcache:"((\$6+\$7)/\$2)*100"%"}'
free -m | sed -n '4p' | awk '{if (\$2 != 0) print "Percent_swap_used:"(\$3/\$2)*100"%"}'
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMad63fc3bca94a4652aed1c34ac4a7fb53.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMad63fc3bca94a4652aed1c34ac4a7fb53.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=7542ab9a-963a-4600-9a38-889db88a0ad9 >> $HCResult
cat >>/tmp/CES_HC_ITEMa7542ab9a963a46009a38889db88a0ad9.sh <<CES_EVO_HC_EOF
df -hTP| grep -v /dev/sr| grep -v tmpfs
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa7542ab9a963a46009a38889db88a0ad9.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa7542ab9a963a46009a38889db88a0ad9.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=640440a2-4f4d-45ae-8830-2a92b3db9b9a >> $HCResult
cat >>/tmp/CES_HC_ITEMa640440a24f4d45ae88302a92b3db9b9a.sh <<CES_EVO_HC_EOF
df -hiP| grep -v tmpfs |grep -v /dev/sr|grep -v efi
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa640440a24f4d45ae88302a92b3db9b9a.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa640440a24f4d45ae88302a92b3db9b9a.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=def5d219-b3e9-41b0-9623-0af7a2527b4d >> $HCResult
cat >>/tmp/CES_HC_ITEMadef5d219b3e941b096230af7a2527b4d.sh <<CES_EVO_HC_EOF
for netif in \$(ls /sys/class/net)
 do
   rx_before=\$(cat /sys/class/net/\$netif/statistics/rx_bytes)
   tx_before=\$(cat /sys/class/net/\$netif/statistics/tx_bytes)
   sleep 5
   rx_after=\$(cat /sys/class/net/\$netif/statistics/rx_bytes)
   tx_after=\$(cat /sys/class/net/\$netif/statistics/tx_bytes)
   rx_result=\$(awk 'BEGIN{printf "%0.2f",("'\$rx_after'"-"'\$rx_before'")/1024/5*8}')
   tx_result=\$(awk 'BEGIN{printf "%0.2f",("'\$tx_after'"-"'\$tx_before'")/1024/5*8}')
   cat /sys/class/net/\$netif/speed > /dev/null 2>&1
   if [ \$? -eq 0 ];then
       Speed=\$(cat /sys/class/net/\$netif/speed)
       banduse=\$(awk 'BEGIN{printf "%4.1f",("'\$rx_result'" + "'\$tx_result'")/1024/"'\$Speed'"*100;print "%"}')
       echo "\$netif:\${rx_result}Kbps:\${tx_result}Kbps:\${Speed}Mbps:\$banduse"
     else
       Speed=-1
       banduse=-1%
       echo "\$netif:\${rx_result}Kbps:\${tx_result}Kbps:\${Speed}:\$banduse"
   fi
done
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMadef5d219b3e941b096230af7a2527b4d.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMadef5d219b3e941b096230af7a2527b4d.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=aab94926-6928-4047-93d0-d4d769016631 >> $HCResult
cat >>/tmp/CES_HC_ITEMaaab949266928404793d0d4d769016631.sh <<CES_EVO_HC_EOF
ps aux |grep -v USER|sort -nr -k4|head -10|awk '{print \$11","\$1","\$2","\$3","\$4}'
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMaaab949266928404793d0d4d769016631.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMaaab949266928404793d0d4d769016631.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=a4b77651-3e42-44fa-aceb-967915c14b54 >> $HCResult
cat >>/tmp/CES_HC_ITEMaa4b776513e4244faaceb967915c14b54.sh <<CES_EVO_HC_EOF
ps aux|head -1;ps aux|grep -v PID|sort -rn -k +3|head -5|awk '{print \$11","\$1","\$2","\$3}'
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMaa4b776513e4244faaceb967915c14b54.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMaa4b776513e4244faaceb967915c14b54.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=ecfc6106-9bfa-4ee0-b31c-8933d07f4b24 >> $HCResult
cat >>/tmp/CES_HC_ITEMaecfc61069bfa4ee0b31c8933d07f4b24.sh <<CES_EVO_HC_EOF
#kexec-tools rpm
echo "kexec-tools,rpm version,\$(rpm -qa | grep kexec-tools)"
#kdump.service
echo "kdump.service,is-operational,\$(service kdump status | awk -F'is' '{print \$2}')"
echo "kdump.service,is-on,\$(chkconfig --list kdump | awk '{print \$5,\$6,\$7}')"
#Memory reservation config
Crashkernel1=\$(grep -m 1 crashkernel /proc/cmdline | awk '{for(i=1;i<=NF;i++) if (\$i ~ "crashkernel") {print \$i;break;}}
')
if [ -n "\$Crashkernel1" ]; then
        echo "/proc/cmdline,Memory reservation config,\$Crashkernel1"
else
        echo "/proc/cmdline,Memory reservation config,no config"
fi
Crashkernel2=\$(grep -m 1 crashkernel /etc/grub.conf  | awk '{for(i=1;i<=NF;i++) if (\$i ~ "crashkernel") {print \$i;break;}}')
if [ -n "\$Crashkernel2" ]; then
        echo "grub.conf,Memory reservation config,\$Crashkernel2"
else
        echo "grub.conf,Memory reservation config,no config"
fi
#kdump.conf
echo "kdump.conf,kdump ,\$(grep ^path /etc/kdump.conf )"
#kdump.conf "path" available space
echo "system memTotal,\$(grep MemTotal /proc/meminfo|awk -F: '{print \$1","\$2}')"
echo "/var/crash,Available free space,\$(df -hP /var/crash |grep -v Filesystem| awk '{print \$4}')"
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMaecfc61069bfa4ee0b31c8933d07f4b24.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMaecfc61069bfa4ee0b31c8933d07f4b24.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=c33e1702-fa08-47f9-b480-bcb5f8fe75b2 >> $HCResult
cat >>/tmp/CES_HC_ITEMac33e1702fa0847f9b480bcb5f8fe75b2.sh <<CES_EVO_HC_EOF
rpm -Va
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMac33e1702fa0847f9b480bcb5f8fe75b2.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMac33e1702fa0847f9b480bcb5f8fe75b2.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=2e28465e-f92b-4629-a4d2-85cf232cf994 >> $HCResult
cat >>/tmp/CES_HC_ITEMa2e28465ef92b4629a4d285cf232cf994.sh <<CES_EVO_HC_EOF
interface=\`ip addr | grep '^[0-9]' |awk -F':' '{print \$2}' | grep -v lo\`
for i in \$interface 
do
	echo \$i,\
	\`ethtool \$i 2>/dev/null | grep -i "Link detected"|awk -F  ":" '{print \$2}'\`,\
 	\`ethtool \$i 2>/dev/null| grep -i "Speed"|awk -F  ":" '{print \$2}'\`,\
 	\`ethtool \$i 2>/dev/null| grep -i "Duplex"|awk -F  ":" '{print \$2}'\`,\
 	\`ethtool \$i 2>/dev/null | grep -i "Supported ports"|awk -F  ":" '{print \$2}'\`,\
 	\`ethtool -i \$i 2>/dev/null| grep -i "driver"|awk -F  ":" '{print \$2}'\`,\
 	\`ethtool -i \$i 2>/dev/null| grep -i "version"|awk -F  ":" '{print \$2}'\`
done
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa2e28465ef92b4629a4d285cf232cf994.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa2e28465ef92b4629a4d285cf232cf994.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=524a1ca1-8713-4a88-85f9-0fef41b70371 >> $HCResult
cat >>/tmp/CES_HC_ITEMa524a1ca187134a8885f90fef41b70371.sh <<CES_EVO_HC_EOF
interface=\`ifconfig | grep -E -o "^[a-z0-9]+" | grep -v "lo" | uniq\`
for i in \$interface 
do
        echo "\$i,\
\`ifconfig \$i | grep HWaddr |awk '{print \$5}'\`,\
\`ifconfig \$i | grep txqueuelen|awk -F: '{print \$3}'\`,\
\`ifconfig \$i | grep inet | grep -v inet6 |awk -F "[ ]+|[:]" '{print \$4"/"\$8}'\`,\
\`ifconfig \$i | grep MTU | awk -F "[ ]+|[:]" '{print\$7}'\`"
done
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa524a1ca187134a8885f90fef41b70371.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa524a1ca187134a8885f90fef41b70371.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=300ea31b-286e-4165-b04c-cf3888430563 >> $HCResult
cat >>/tmp/CES_HC_ITEMa300ea31b286e4165b04ccf3888430563.sh <<CES_EVO_HC_EOF
if [ -e /proc/net/bonding ];then
        bond=\`ls  /proc/net/bonding\`
        count=\`ls  /proc/net/bonding |wc -l\`
fi
if [[ ! -e /proc/net/bonding || \$count = 0 ]];then
        echo -e "network bonding No configuration\n"
elif [[  -e /proc/net/bonding && \$count != 0 ]];then
        for i in \$bond
        do
                echo "###\$i config:"
                echo "\`cat /proc/net/bonding/\$i | grep "Bonding Mode"\`"
                echo "\`cat /proc/net/bonding/\$i | grep "Currently Active Slave"\`"
                echo "\`cat /proc/net/bonding/\$i | grep -E "Slave Interface|Permanent HW add"\`"
        done
fi
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa300ea31b286e4165b04ccf3888430563.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa300ea31b286e4165b04ccf3888430563.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=0fd98dad-07c2-44c5-bb7a-ee3091806c81 >> $HCResult
cat >>/tmp/CES_HC_ITEMa0fd98dad07c244c5bb7aee3091806c81.sh <<CES_EVO_HC_EOF
echo "#Total number of processes:"
ps -ef |wc -l
echo "#Total number of threads:"
ps -eLf |wc -l
echo "#Top users of CPU & MEM:"
ps axo user,pcpu,pmem,rss --no-heading | awk '{pCPU[\$1]+=\$2; pMEM[\$1]+=\$3; sRSS[\$1]+=\$4} END {for (user in pCPU) if (pCPU[user]>0 || sRSS[user]>10240) printf "%s:@%.1f%% of total CPU,@%.1f%% of total MEM@(%.2f GiB used)\n", user, pCPU[user], pMEM[user], sRSS[user]/1024/1024}' | column -ts@ | sort -rnk2
echo "#Defunct processes"
ps axo user,pid,%cpu,%mem,rss,stat,time,command | grep -e '^[Zz]\$'
echo "#Uninteruptible sleep"
ps axo user,pid,%cpu,%mem,rss,stat,time,command | grep -e '^[Dd]\$'
echo "#Top CPU-using processes"
ps aux|grep USER| head -n 1
ps aux|grep -v  USER|sort -rn -k +3|head -10
echo "#Top MEM-using processes"
ps aux|grep USER| head -n 1
ps aux|grep -v  USER|sort -rn -k +4|head -10
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa0fd98dad07c244c5bb7aee3091806c81.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa0fd98dad07c244c5bb7aee3091806c81.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=b29b5fc3-9e00-4d57-b3af-25b9ece0b0fd >> $HCResult
cat >>/tmp/CES_HC_ITEMab29b5fc39e004d57b3af25b9ece0b0fd.sh <<CES_EVO_HC_EOF
#Time zone
echo "##Time zone config"
echo "Time zone:\$(grep ZONE /etc/sysconfig/clock | awk -F'"' '{print \$2}')"
#NTP
echo "##NTP config"
ntpstat >/dev/null 2>&1
N1=\$?
crontab  -l| grep ntpdate >/dev/null 2>&1
N2=\$?
if [ \$N1 = 0 ];then
        echo "NTP server: \`grep ^server /etc/ntp.conf\`"
        echo "NTP status:\` ntpq -p\`"
        echo "NTP service: \` chkconfig --list ntpd\`"
elif [ \$N1 = 1 ];then
        echo "The ntpd service is running,but not synchronization!"
elif [[ \$N1 == 2 && \$N2 == 0 ]];then
        echo "Synchronization time use crontab:"
        echo "crontab conig: \`crontab  -l| grep ntpdate\`"
else
        echo "Synchronization time no config!"

fi
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMab29b5fc39e004d57b3af25b9ece0b0fd.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMab29b5fc39e004d57b3af25b9ece0b0fd.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=6c602c1a-42b0-47cf-ad8f-06dd94f6fc74 >> $HCResult
cat >>/tmp/CES_HC_ITEMa6c602c1a42b047cfad8f06dd94f6fc74.sh <<CES_EVO_HC_EOF
#ulimit.conf
echo "#ulimit.conf"
cat /etc/security/limits.conf | grep -Ev "^#|^\$"
#root user ulimit -a
echo "#root user ulimit -a"
ulimit -a
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa6c602c1a42b047cfad8f06dd94f6fc74.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa6c602c1a42b047cfad8f06dd94f6fc74.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=0cb70edf-712c-4be2-b11b-64acf36a9102 >> $HCResult
cat >>/tmp/CES_HC_ITEMa0cb70edf712c4be2b11b64acf36a9102.sh <<CES_EVO_HC_EOF
##lsblk
echo "#lsblk"
lsblk
##/dev/disk/by-path/
echo "#/dev/disk/by-path"
ls -al /dev/disk/by-path/
## lsscsi
echo "#lsscsi"
lsscsi -l      
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa0cb70edf712c4be2b11b64acf36a9102.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa0cb70edf712c4be2b11b64acf36a9102.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=5cc17a70-5bd5-4c94-b8b7-d9c74dd7784d >> $HCResult
cat >>/tmp/CES_HC_ITEMa5cc17a705bd54c94b8b7d9c74dd7784d.sh <<CES_EVO_HC_EOF
lsblk |grep ^s| grep -v ^sr |awk '{print \$1","\$2"," \$4"," \$6}'
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa5cc17a705bd54c94b8b7d9c74dd7784d.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa5cc17a705bd54c94b8b7d9c74dd7784d.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=2af4f215-2612-4d97-8db1-ca8639fcc207 >> $HCResult
cat >>/tmp/CES_HC_ITEMa2af4f21526124d978db1ca8639fcc207.sh <<CES_EVO_HC_EOF
#pvs
pvs
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa2af4f21526124d978db1ca8639fcc207.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa2af4f21526124d978db1ca8639fcc207.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=f8c53a77-f869-44da-a387-60ab1d8931e6 >> $HCResult
cat >>/tmp/CES_HC_ITEMaf8c53a77f86944daa38760ab1d8931e6.sh <<CES_EVO_HC_EOF
#vgs
vgs
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMaf8c53a77f86944daa38760ab1d8931e6.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMaf8c53a77f86944daa38760ab1d8931e6.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=33e264e2-1439-4362-963c-f5d731b1d9c4 >> $HCResult
cat >>/tmp/CES_HC_ITEMa33e264e214394362963cf5d731b1d9c4.sh <<CES_EVO_HC_EOF
lvs
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa33e264e214394362963cf5d731b1d9c4.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa33e264e214394362963cf5d731b1d9c4.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=11734262-a569-4675-bf03-f9124ea55780 >> $HCResult
cat >>/tmp/CES_HC_ITEMa11734262a5694675bf03f9124ea55780.sh <<CES_EVO_HC_EOF
powermt display dev=all >/dev/null 2>&1
if  [ \$? != 0 ];then
	echo "#System no Use EMC Powerpath"
else
	echo "#System  Use EMC Powerpath"
	echo "powermt dispaly dev=all"
	powermt display dev=all
fi
upadmin show vlun  >/dev/null 2>&1
if  [ \$? != 0 ];then
	echo "#System no Use Huawei Ultrapath"
else
	echo "#System  Use Huawei Ultrapath"
	echo "upadmin show vlun"
	upadmin show vlun
	
fi

multipath -ll  >/dev/null 2>&1
if  [ \$? != 0 ];then
	echo "#System no Use  Multipath"
else
	echo "#System  Use Multipath"
	echo "multipath -ll"
	multipath -ll
	echo "cat /etc/multipath.conf"
	cat /etc/multipath.conf
fi
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa11734262a5694675bf03f9124ea55780.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa11734262a5694675bf03f9124ea55780.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=e537a670-53b7-4557-8447-949bb582eb6a >> $HCResult
cat >>/tmp/CES_HC_ITEMae537a67053b745578447949bb582eb6a.sh <<CES_EVO_HC_EOF
#kernel
echo "kernel,sem,arry,\`cat /proc/sys/kernel/sem\`,for oracle:250 32000 100 128"
echo "kernel,threads-max,num,\`cat /proc/sys/kernel/threads-max\`,"
echo "kernel,shmall,4-KiB pages,\`cat /proc/sys/kernel/shmall\`,"
echo "kernel,shmmax,bytes,\` cat /proc/sys/kernel/shmmax\`,"
echo "kernel,shmmni,segments,\`cat /proc/sys/kernel/shmmni\`,"
#fs
echo "fs,file-max,num,\`cat /proc/sys/fs/file-max\`,"
echo "fs,nr_open,num,\`cat /proc/sys/fs/nr_open\`,"
#net
echo "net,core.rmem_default,bytes,\`cat /proc/sys/net/core/rmem_default\`,"
echo "net,core.wmem_default,bytes,\`cat /proc/sys/net/core/wmem_default\`,"
echo "net,core.rmem_max,bytes,\`cat /proc/sys/net/core/rmem_max\`,4M vaule:4194304"
echo "net,core.wmem_max,bytes,\`cat /proc/sys/net/core/wmem_max\`, 4M vaule:4194304"
echo "net,ipv4.ip_forward,bool,\`cat /proc/sys/net/ipv4/ip_forward\`,0"
echo "net,ipv4.ip_local_port_range,ports,\`cat /proc/sys/net/ipv4/ip_local_port_range\`,for oracle:9000 65500"
echo "net,ipv4.tcp_timestamps,bool,\`cat /proc/sys/net/ipv4/tcp_timestamps\`,1"
#vm
echo "vm,vm.swappiness,%,\`cat /proc/sys/vm/swappiness\`,10"
echo "vm,min_free_kbytes,kbytes,\`cat /proc/sys/vm/min_free_kbytes\`,"
echo "vm,dirty_ratio,%,\`cat /proc/sys/vm/dirty_ratio\`,15"
echo "vm,dirty_expire_centisecs,1/100s,\`cat /proc/sys/vm/dirty_expire_centisecs\`,500"
echo "vm,dirty_writeback_centisecs,1/100s,\`cat /proc/sys/vm/dirty_writeback_centisecs\`,100"
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMae537a67053b745578447949bb582eb6a.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMae537a67053b745578447949bb582eb6a.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=9823e059-f178-45f3-9bc8-625297ff97f3 >> $HCResult
cat >>/tmp/CES_HC_ITEMa9823e059f17845f39bc8625297ff97f3.sh <<CES_EVO_HC_EOF
##rsyslog service and log forward
FORW=\`grep "@[0-9]*\." /etc/rsyslog.conf | grep -v ^#\`
service rsyslog status > /dev/null 2>&1
A=\$?
if [ \$A = 0 ];then
  if [ -n "\$FORW" ];then
    echo  "rsyslog,running,"\$FORW",yes"
  else
    echo "rsyslog,running,not config,no"
  fi
elif [ -n "\$FORW" ];then
  echo "rsyslog,stopped,"\$FORW",yes" 
else
  echo "rsyslog,stopped,not config,no"
fi
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa9823e059f17845f39bc8625297ff97f3.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa9823e059f17845f39bc8625297ff97f3.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=0c2b5b97-974a-4572-8e89-5b2a9404be79 >> $HCResult
cat >>/tmp/CES_HC_ITEMa0c2b5b97974a45728e895b2a9404be79.sh <<CES_EVO_HC_EOF
tail -10000 /var/log/messages | grep -iE "error|fail|Machine Check Exception|Out of memory|soft lockup|EXT4-fs error|qla2xxx|Failing path|Kernel panic" |grep -Ev "failed to assign|sftp-server" 
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa0c2b5b97974a45728e895b2a9404be79.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa0c2b5b97974a45728e895b2a9404be79.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=da169910-acd0-41bc-a3e7-c02936e0159e >> $HCResult
cat >>/tmp/CES_HC_ITEMada169910acd041bca3e7c02936e0159e.sh <<CES_EVO_HC_EOF
tail -1000 /var/log/dmesg | grep -iE "error|fail|Machine Check Exception|Out of memory|soft lockup| I\/O error|EXT4-fs error|qla2xxx|Failing path|Kernel panic|NIC Link is Down" | grep -Ev "failed to assign|sftp-server" 
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMada169910acd041bca3e7c02936e0159e.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMada169910acd041bca3e7c02936e0159e.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
echo CES_HC_ITEM_KEY=69485078-88fe-4fa2-b76d-068ec61c9fce >> $HCResult
cat >>/tmp/CES_HC_ITEMa6948507888fe4fa2b76d068ec61c9fce.sh <<CES_EVO_HC_EOF
file=/var/log/mcelog
if [ ! -e \$file ];then
	echo "-- No entries --"
else
	tail -10 \$file
fi
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMa6948507888fe4fa2b76d068ec61c9fce.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMa6948507888fe4fa2b76d068ec61c9fce.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult
cat >>/tmp/CES_HC_ITEMbf8ef62df5c64632813e1d824db4dc46.sh <<CES_EVO_HC_EOF
echo "bf8ef62d-f5c6-4632-813e-1d824db4dc46CESEVO`hostname`"
CES_EVO_HC_EOF
sh /tmp/CES_HC_ITEMbf8ef62df5c64632813e1d824db4dc46.sh >> $HCResult
rm -f /tmp/CES_HC_ITEMbf8ef62df5c64632813e1d824db4dc46.sh
echo "########CES_HC_ITEM_SEPARATOR########" >> $HCResult

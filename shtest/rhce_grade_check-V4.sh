#!/bin/bash
#v8.0 xuegod 2018/03/19
#===============================RHCSA=================================

# 01 - SELinux
check_01_selinux() {
  #Check SELinux
  ssh root@server0 getenforce | grep -q 'Enforcing' && s_selinux=ok || s_selinux=fail
  ssh root@desktop0 getenforce | grep -q 'Enforcing' && d_selinux=ok || d_selinux=fail
  if [ "$s_selinux" = "ok" -a "$d_selinux" = "ok" ] ; then
    echo -e "01 SELinux: \t\t\tok" >> $RHCE_GRADE
    rhce_grade_01=1
  else
    echo -e "01 SELinux: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_01=0
  fi
}

# 02 - SSH
# dualt
check_02_ssh() {
  # check /etc/hosts.allow on both
  S_SSH_ALLOW=`ssh root@server0 grep 'sshd' /etc/hosts.allow | gawk -F":" '{print $2}' | tr -d " "`
  D_SSH_ALLOW=`ssh root@desktop0 grep 'sshd' /etc/hosts.allow | gawk -F":" '{print $2}' | tr -d " "`

  # check /etc/hosts.deny on both
  S_SSH_DENY=`ssh root@server0 grep 'sshd' /etc/hosts.deny | gawk -F":" '{print $2}' | tr -d " "`
  D_SSH_DENY=`ssh root@desktop0 grep 'sshd' /etc/hosts.deny | gawk -F":" '{print $2}' | tr -d " "`
  
  #S_SSH_FIREWALLD=`ssh root@server0 firewall-cmd --zone=public --list-rich-rules | grep 'service name="ssh"' | gawk '{print $NF}'`
  #D_SSH_FIREWALLD=`ssh root@desktop0 firewall-cmd --zone=public --list-rich-rules | grep 'service name="ssh"' | gawk '{print $NF}'`
  if [ "$S_SSH_ALLOW" = "172.25.0.0/24" ] && [ "$S_SSH_DENY" = "172.24.3.0/24" -o "$S_SSH_FIREWALLD" = "reject" -o "$S_SSH_FIREWALLD" = "drop" ] && [ "$D_SSH_ALLOW" = "172.25.0.0/24" ] && [ "$D_SSH_DENY" = "172.24.3.0/24" -o "$D_SSH_FIREWALLD" = "reject" -o "$D_SSH_FIREWALLD" = "drop" ] ; then
    echo -e "02 SSH: \t\t\tok" >> $RHCE_GRADE
    rhce_grade_02=1
  else
    echo -e "02 SSH: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_02=0
  fi
}

# 03 - ALIAS
check_03_alias() {
  # check
  ssh root@server0 grep -q "alias qstat='/bin/ps -Ao pid,tt,user,fname,rsz'" /etc/bashrc &> /dev/null && s_alias=ok || s_alias=fail
  ssh root@desktop0 grep -q "alias qstat='/bin/ps -Ao pid,tt,user,fname,rsz'" /etc/bashrc &> /dev/null && d_alias=ok || d_alias=fail
  if [ "$s_alias" = "ok" -a "$d_alias" = "ok" ] ; then
    echo -e "03 Alias: \t\t\tok" >> $RHCE_GRADE
    rhce_grade_03=1
  else
    echo -e "03 Alias: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_03=0
  fi
}

# 04 - FORWARD PORT
check_04_forward_port() {
  # check
  ssh root@server0 firewall-cmd --zone=public --list-rich-rules |grep -q 'source address="172.25.0.0/24" forward-port port="5423" protocol="tcp" to-port="80"' && s_forward_port=ok || s_forward_port=fail
  if [ "$s_forward_port" = "ok" ] ; then
    echo -e "04 Forward port: \t\tok" >> $RHCE_GRADE
    rhce_grade_04=1
  else
    echo -e "04 Forward port: \t\tfail" >> $RHCE_GRADE
    rhce_grade_04=0
  fi
}

# 05 - TEAM
check_05_team() {
  # check team0's IP
  ssh root@server0 ip addr show team0 | grep -q '172.16.0.20/24' && s_team_ip=ok || s_team_ip=fail
  ssh root@desktop0 ip addr show team0 | grep -q '172.16.0.25/24' && d_team_ip=ok || d_team_ip=fail

  # check team0's "runner: activebackup"
  ssh root@server0 teamdctl team0 state | grep -q 'runner: activebackup' && s_team_runner=ok || s_team_runner=fail
  ssh root@desktop0 teamdctl team0 state | grep -q 'runner: activebackup' && d_team_runner=ok || d_team_runner=fail

  # check team0's "link summary: up"
  S_TEAM_LINK_SUMMARY=`ssh root@server0 teamdctl team0 state | grep 'link summary: up' | wc -l`
  D_TEAM_LINK_SUMMARY=`ssh root@desktop0 teamdctl team0 state | grep 'link summary: up' | wc -l`

  # check team0's "link: up"
  S_TEAM_LINK=`ssh root@server0 teamdctl team0 state | grep 'link: up' | wc -l`
  D_TEAM_LINK=`ssh root@desktop0 teamdctl team0 state | grep 'link: up' | wc -l`

  # ping each other's IP
  ssh root@server0 ping -c 1 172.16.0.25 &> /dev/null && s_team_ping=ok || s_team_ping=fail
  ssh root@desktop0 ping -c 1 172.16.0.20 &> /dev/null && d_team_ping=ok || d_team_ping=fail
  if [ "$s_team_ip" = "ok" -a "$s_team_runner" = "ok" -a "$S_TEAM_LINK_SUMMARY" = "2" -a "$S_TEAM_LINK" = "2" -a "$s_team_ping" = "ok" ] && [ "$d_team_ip" = "ok" -a "$d_team_runner" = "ok" -a "$D_TEAM_LINK_SUMMARY" = "2" -a "$D_TEAM_LINK" = "2" -a "$d_team_ping" = "ok" ] ; then
    echo -e "05 Team: \t\t\tok" >> $RHCE_GRADE
    rhce_grade_05=1
  else
    echo -e "05 Team: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_05=0
  fi
}

# 06 - IPv6
check_06_ipv6() {
  # check eth0's IPv6
  ssh root@server0 ip addr show eth0 | grep 'inet6' | grep -q '2003:ac18::305/64' && s_ipv6=ok || s_ipv6=fail
  ssh root@desktop0 ip addr show eth0 | grep 'inet6' | grep -q '2003:ac18::306/64' && d_ipv6=ok || d_ipv6=fail

  # ping each other IPv6
  ssh root@server0 ping6 -c 1 2003:ac18::306 &> /dev/null && s_ipv6_ping=ok || s_ipv6_ping=fail
  ssh root@desktop0 ping6 -c 1 2003:ac18::305 &> /dev/null && d_ipv6_ping=ok || d_ipv6_ping=fail
  if [ "$s_ipv6" = "ok" -a "$s_ipv6_ping" = "ok" ] && [ "$d_ipv6" = "ok" -a "$d_ipv6_ping" = "ok" ] ; then
    echo -e "06 IPv6: \t\t\tok" >> $RHCE_GRADE
    rhce_grade_06=1
  else
    echo -e "06 IPv6: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_06=0
  fi
}

# 07 - MAIL
check_07_mail() {
  # check mail's service status on both
  S_MAIL_STATUS=`ssh root@server0 systemctl status postfix.service | grep 'Active:' | gawk '{print $2" "$3}'`
  D_MAIL_STATUS=`ssh root@desktop0 systemctl status postfix.service | grep 'Active:' | gawk '{print $2" "$3}'`
  if [ "$S_MAIL_STATUS" = "active (running)" -a "$D_MAIL_STATUS" = "active (running)" ] ; then
    # check mail test on desktop0
    ssh root@desktop0 mail -u student &> /dev/null && d_mail_test=ok || d_mail_test=fail
    if [ "$d_mail_test" = "ok" ] ; then
      echo -e "07 Mail: \t\t\tok" >> $RHCE_GRADE
      rhce_grade_07=1
    else
      echo -e "07 Mail: \t\t\tfail" >> $RHCE_GRADE
      rhce_grade_07=0
    fi
  else
    echo -e "07 Mail: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_07=0
  fi
}

# 08 - SAMBA 01
check_08_samba_01(){
  # check samba's service status on server0
  S_SMB_STATUS=`ssh root@server0 systemctl status smb.service | grep 'Active:' | gawk '{print $2" "$3}'`
  S_NMB_STATUS=`ssh root@server0 systemctl status nmb.service | grep 'Active:' | gawk '{print $2" "$3}'`
  if [ "$S_SMB_STATUS" = "active (running)" -a "$S_NMB_STATUS" = "active (running)" ] ; then
    # check smbclient connection on desktop0
    ssh root@desktop0 echo "kerberos" | smbclient -L server0 -U harry &> /dev/null && smbclient1=ok || smbclient1=fail
    ssh root@desktop0 echo "kerberos" | smbclient -L server0 -U kenji &> /dev/null && smbclient2=ok || smbclient2=fail
    if [ "$smbclient1" = "ok" -o "$smbclient2" = "ok" ] ; then
      # check the workgroup
      SMB_WORKGROUP1=`ssh root@desktop0 echo "kerberos" | smbclient -L server0 -U harry | tail -1`
      WORKGROUP1=`echo $SMB_WORKGROUP1 | gawk '{print $1}'`

      SMB_WORKGROUP2=`ssh root@desktop0 echo "kerberos" | smbclient -L server0 -U kenji | tail -1`
      WORKGROUP2=`echo $SMB_WORKGROUP2 | gawk '{print $1}'`
      if [ "$WORKGROUP1" = "STAFF" -o "$WORKGROUP2" = "STAFF" ] ; then
        echo -e "08 Samba 01: \t\t\tok" >> $RHCE_GRADE
        rhce_grade_08=1
      else
        echo -e "08 Samba 01: \t\t\tfail" >> $RHCE_GRADE
        rhce_grade_08=0
      fi
    else
      echo -e "08 Samba 01: \t\t\tfail" >> $RHCE_GRADE
      rhce_grade_08=0
    fi
  else
    echo -e "08 Samba 01: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_08=0
  fi
  # check samba's service status on server0 - START
}

# 09 - SAMBA 02
check_09_samba_02(){
  # check rhce_grade_08
  if [ "$rhce_grade_08" = "1" ] ; then
    # check samba mount on desktop0
    ssh root@desktop0 "df | grep '/mnt/dev' | grep '/devops'" && d_smb_mount=ok || d_smb_mount=fail
    if [ "$d_smb_mount" = "ok" ] ; then
#    ssh root@desktop0 "cifscreds add -u kenji server0 && touch /mnt/dev/zero" || kenji_cifs=fail
#    ssh root@desktop0 "cifscreds add -u chihiro server0 && touch /mnt/dev/zero" || chihiro_cifs=fail
	echo -e "09 Samba 02: \t\t\tok" >> $RHCE_GRADE
    else
	echo -e "09 Samba 02: \t\t\tfail" >> $RHCE_GRADE

    fi
  fi
}

# 10 - NFS 01
check_10_nfs_01() {
  # check nfs-secure-server.service & nfs-server.service status
  S_NFS_SECURE_SERVER_STATUS=`ssh root@server0 systemctl status nfs-secure-server.service | grep 'Active:' | gawk '{print $2" "$3}'`
  S_NFS_SERVER_STATUS=`ssh root@server0 systemctl status nfs-server.service | grep 'Active:' | gawk '{print $2" "$3}'`

  # check if service:mountd,nfs,rpc-bind on firewalld
  ssh root@server0 firewall-cmd --zone=public --list-services | grep -q 'mountd' && s_firewalld_mountd=ok || s_firewalld_mountd=fail
  ssh root@server0 firewall-cmd --zone=public --list-services | grep -q 'nfs' && s_firewalld_nfs=ok || s_firewalld_nfs=fail
  ssh root@server0 firewall-cmd --zone=public --list-services | grep -q 'rpc-bind' && s_firewalld_rpc_bind=ok || s_firewalld_rpc_bind=fail
  if [ "$S_NFS_SECURE_SERVER_STATUS" = "active (running)" -a "$S_NFS_SERVER_STATUS" = "active (exited)" ] && [ "$s_firewalld_mountd" = "ok" -a "$s_firewalld_nfs" = "ok" -a "$s_firewalld_rpc_bind" = "ok" ] ; then
    # check nfs exportfs
    S_NFS_RW=`ssh root@server0 exportfs -rv | grep '/protected' | gawk '{print $2}' | gawk -F":" '{print $1}'`
    S_NFS_RO=`ssh root@server0 exportfs -rv | grep '/public' | gawk '{print $2}'| gawk -F":" '{print $1}'`
    if [ "$S_NFS_RW" = "172.25.0.0/24" -a "$S_NFS_RO" = "172.25.0.0/24" ] ; then
      echo -e "10 NFS 01: \t\t\tok" >> $RHCE_GRADE
      rhce_grade_10=1
    else
      echo -e "10 NFS 01: \t\t\tfail" >> $RHCE_GRADE
      rhce_grade_10=0
    fi
  else
    echo -e "10 NFS 01: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_10=0
  fi
}

# 11 - NFS 02
check_11_nfs_02() {
  if [ "$rhce_grade_10" = 1 ] ; then
    # check nfs-secure.service status
    D_NFS_SECURE_STATUS=`ssh root@desktop0 systemctl status nfs-secure.service | grep 'Active:' | gawk '{print $2" "$3}'`
    if [ "$D_NFS_SECURE_STATUS" = "active (running)" ] ; then
      # check nfs mount on desktop0
      ssh root@desktop0 df | grep '/mnt/nfsmount' | grep -q '/public' &> /dev/null && d_nfs_mount_ro=ok || d_nfs_mount_ro=fail
      ssh root@desktop0 df | grep '/mnt/nfssecure' | grep -q '/protected' &> /dev/null && d_nfs_mount_rw=ok || d_nfs_mount_rw=fail

      # check if user write ok
      #ssh root@desktop0 "ssh krishna@localhost 'touch /mnt/nfssecure/zero'" && d_nfs_user_write=ok || d_nfs_user_write=fail
      if [ "$d_nfs_mount_ro" = "ok" -a "$d_nfs_mount_rw" = "ok" ] ; then
        echo -e "11 NFS 02: \t\t\tok" >> $RHCE_GRADE
        rhce_grade_11=1
      else
        echo -e "11 NFS 02: \t\t\tfail" >> $RHCE_GRADE
        rhce_grade_11=0
      fi
    else
      echo -e "11 NFS 02: \t\t\tfail" >> $RHCE_GRADE
      rhce_grade_11=0
    fi
  else
    echo -e "11 NFS 02: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_11=0
  fi
}

# 12 - WEB 01 ( vhost : server0 )
check_12_web_01() {
  # check httpd.service status
  S_HTTPD_STATUS=`ssh root@server0 systemctl status httpd.service | grep 'Active:' | gawk '{print $2" "$3}'`

  # check if service:http on firewalld
  ssh root@server0 firewall-cmd --zone=public --list-services | grep -q 'http' && s_firewalld_http=ok || s_firewalld_http=fail
  if [ "$S_HTTPD_STATUS" = "active (running)" -a "$s_firewalld_http" = "ok" ] ; then
    # check if http test page 01 exist
    ssh root@server0 [ -f /var/www/html/index.html ] && httpd_test_page_01=ok || httpd_test_page_01=fail

    
    # deny network:172.24.3.0/24 visit http
    S_HTTP_FIREWALLD=`ssh root@server0 firewall-cmd --zone=public --list-rich-rules | grep 'source address="172.24.3.0/24" service name="http"' | gawk '{print $7}'`
    # check both http header status code
    ssh root@server0 curl -I http://server0.example.com | grep -q '200 OK' &> /dev/null && s_curl_01=ok || s_curl_01=fail
    ssh root@desktop0 curl -I http://server0.example.com | grep -q '200 OK' &> /dev/null && d_curl_01=ok || d_curl_01=fail
    if [ "$httpd_test_page_01" = "ok" ] && [ "$S_HTTP_FIREWALLD" = "reject" -o "$S_HTTP_FIREWALLD" = "drop" ] && [ "$s_curl_01" = "ok" -a "$d_curl_01" = "ok" ] ; then
      echo -e "12 WEB 01: \t\t\tok" >> $RHCE_GRADE
      rhce_grade_12=1
    else
      echo -e "12 WEB 01: \t\t\tfail" >> $RHCE_GRADE
      rhce_grade_12=0
    fi
  else
    echo -e "12 WEB 01: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_12=0
  fi
}

# 13 - WEB 02 ( https )
check_13_web_02() {
  if [ "$rhce_grade_12" = "1" ] ; then
    # check if service:https on firewalld
    ssh root@server0 firewall-cmd --zone=public --list-services | grep -q 'https' && s_firewalld_https=ok || s_firewalld_https=fail

    # deny network:172.24.3.0/24 visit https
    S_HTTPS_FIREWALLD=`ssh root@server0 firewall-cmd --zone=public --list-rich-rules | grep 'source address="172.24.3.0/24" service name="https"' | gawk '{print $7}'`

    # find example-ca.crt location
    S_EXAMPLE_CA=`ssh root@server0 find / -name example-ca.crt 2> /dev/null`
    #D_EXAMPLE_CA=`ssh root@desktop0 find / -name example-ca.crt 2> /dev/null`

    # check both http header status code
    ssh root@server0 curl -I https://server0.example.com --cacert $S_EXAMPLE_CA | grep '200 OK' &> /dev/null && s_curl_02=ok || s_curl_02=fail
    #ssh root@desktop0 curl -I https://server0.example.com --cacert $D_EXAMPLE_CA | grep '200 OK' &> /dev/null && d_curl_02=ok || d_curl_02=fail
    #if [ "$s_firewalld_https" = "ok" ] && [ "$S_HTTPS_FIREWALLD" = "reject" -o "$S_HTTPS_FIREWALLD" = "drop" ] && [ "$s_curl_02" = "ok" -a "$d_curl_02" = "ok" ] ; then
    if [ "$s_firewalld_https" = "ok" ] && [ "$S_HTTPS_FIREWALLD" = "reject" -o "$S_HTTPS_FIREWALLD" = "drop" ] && [ "$s_curl_02" = "ok" ] ; then
      echo -e "13 WEB 02: \t\t\tok" >> $RHCE_GRADE
      rhce_grade_13=1  
    else
      echo -e "13 WEB 02: \t\t\tfail" >> $RHCE_GRADE
      rhce_grade_13=0
    fi
  else
    echo -e "13 WEB 02: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_13=0
  fi
}

# 14 - WEB 03 ( vhost : www0 )
check_14_web_03() {
  if [ "$rhce_grade_12" = "1" ] ; then
    # check if http test page 02 exist
    ssh root@server0 [ -f /var/www/virtual/index.html ] && httpd_test_page_02=ok || httpd_test_page_02=fail

    # check both http header status code
    ssh root@server0 curl -I http://www0.example.com | grep '200 OK' &> /dev/null && s_curl_03=ok || s_curl_03=fail
    ssh root@desktop0 curl -I http://www0.example.com | grep '200 OK' &> /dev/null && d_curl_03=ok || d_curl_03=fail
    if [ "$httpd_test_page_02" = "ok" ] && [ "$s_curl_03" = "ok" -a "$d_curl_03" = "ok" ] ; then
      echo -e "14 WEB 03: \t\t\tok" >> $RHCE_GRADE
      rhce_grade_14=1
    else
      echo -e "14 WEB 03: \t\t\tfail" >> $RHCE_GRADE
      rhce_grade_14=0
    fi
  else
    echo -e "14 WEB 03: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_14=0
  fi
}

# 15 - WEB 04 ( private )
check_15_web_04() {
  if [ "$rhce_grade_12" = "1" ] ; then
    # check if http test page 03 exist
    ssh root@server0 [ -f /var/www/html/private/index.html ] && httpd_test_page_03=ok || httpd_test_page_03=fail

    # check both http header status code
    ssh root@server0 curl -I http://server0.example.com/private | grep -q '301 Moved Permanently' &> /dev/null && s_curl_04=ok || s_curl_04=fail
    ssh root@desktop0 curl -I http://server0.example.com/private | grep -q '403 Forbidden' &> /dev/null && d_curl_04=ok || d_curl_04=fail
    if [ "$httpd_test_page_03" = "ok" ] && [ "$s_curl_04" = "ok" -a "$d_curl_04" = "ok" ] ; then
      echo -e "15 WEB 04: \t\t\tok" >> $RHCE_GRADE
      rhce_grade_15=1
    else
      echo -e "15 WEB 04: \t\t\tfail" >> $RHCE_GRADE
      rhce_grade_15=0
    fi
  else
    echo -e "15 WEB 04: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_15=0
  fi
}

# 16 - WEB 05 ( wsgi )
check_16_web_05() {
  if [ "$rhce_grade_12" = "1" ] ; then
    # check if webinfo.wsgi exist
    ssh root@server0 [ -f /var/www/webapp0/webinfo.wsgi ] && httpd_wsgi_page=ok || httpd_wsgi_page=fail

    # check if port:8909/tcp on firewalld
    ssh root@server0 firewall-cmd --zone=public --list-ports | grep -q '8909/tcp' && s_firewalld_8909=ok || s_firewalld_8909=fail

    # check both http header status code
    ssh root@server0 curl -I http://webapp0.example.com:8909 | grep -q '200 OK' &> /dev/null && s_curl_05=ok || s_curl_05=fail
    ssh root@desktop0 curl -I http://webapp0.example.com:8909 | grep -q '200 OK' &> /dev/null && d_curl_05=ok || d_curl_05=fail
    if [ "$httpd_wsgi_page" = "ok" -a "$s_firewalld_8909" = "ok" ] && [ "$s_curl_05" = "ok" -a "$d_curl_05" = "ok" ] ; then
      echo -e "16 WEB 05: \t\t\tok" >> $RHCE_GRADE
      rhce_grade_16=1
    else
      echo -e "16 WEB 05: \t\t\tfail" >> $RHCE_GRADE
      rhce_grade_16=0
    fi
  else
    echo -e "16 WEB 05: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_16=0
  fi
}

# 17 - SHELL 01
check_17_shell_01() {
  # check if shell 01 exist
  #ssh root@server0 ls /root/foo.sh &>/dev/null && shell01_1=ok || shell01_1=fail
  ssh root@server0 ls /root/test1.sh &>/dev/null && shell01_2=ok || shell01_2=fail
  #if [ "$shell01_1" = "ok" -o "$shell01_2" = "ok" ] ; then
  if [ "$shell01_2" = "ok" ] ; then
    # check no parameter
   # NO_PARAMETER1=`ssh root@server0 /root/foo.sh 2>/dev/null`
    NO_PARAMETER2=`ssh root@server0 /root/test1.sh 2>/dev/null`

    # check firsh parameter
    #PARAMETER01_1=`ssh root@server0 /root/foo.sh redhat 2>/dev/null`
    PARAMETER01_2=`ssh root@server0 /root/test1.sh cat 2>/dev/null`

    # check second parameter
    #PARAMETER02_1=`ssh root@server0 /root/foo.sh fedora 2>/dev/null`
    PARAMETER02_2=`ssh root@server0 /root/test1.sh dog 2>/dev/null`
    #if [ "$NO_PARAMETER1" = "/root/foo.sh redhat|fedora" -o "$NO_PARAMETER1" = "/root/foo.sh fedora|redhat" ] && [ "$PARAMETER01_1" = "fedora" -o "$PARAMETER01_1" = "redhat" -a "$PARAMETER02_1" = "fedora" -o "$PARAMETER02_1" = "redhat" ] ; then
    if [ "$NO_PARAMETER2" = "/root/test1.sh dog|cat" -o "$NO_PARAMETER2" = "/root/test1.sh cat|dog" ] && [ "$PARAMETER01_2" = "dog" -a "$PARAMETER02_2" = "cat" ] ; then
      rhce_grade_17_2=1
    else
      rhce_grade_17_2=0
    fi
    else
      echo -e "17 SHELL 01: \t\t\tfail" >> $RHCE_GRADE
  fi
    if [ "$rhce_grade_17_1" = "1" -o "$rhce_grade_17_2" = "1" ] ; then
      echo -e "17 SHELL 01: \t\t\tok" >> $RHCE_GRADE
      rhce_grade_17=1
    else
     echo -e "17 SHELL 01: \t\t\tfail" >> $RHCE_GRADE
      rhce_grade_17=0
    fi
}

# 18 - SHELL 02
check_18_shell_02() {
  # check if shell 02 exist
  ssh root@server0 ls /root/userlist &>/dev/null && shell02_1=ok || shell02_1=fail
  ssh root@server0 ls /root/test2.sh &>/dev/null && shell02_2=ok || shell02_2=fail
  if [ "$shell02_1" = "ok" -a "$shell02_2" = "ok" ] ; then
    # check no parameter
    #NO_PARAMETER3=`ssh root@server0 /root/batchusers 2>/dev/null`
    NO_PARAMETER4=`ssh root@server0 /root/test2.sh 2>/dev/null`

    # check input file not found
    #PARAMETER03_1=`ssh root@server0 /root/batchusers aaa 2>/dev/null`
    PARAMETER03_2=`ssh root@server0 /root/test2.sh aaa 2>/dev/null`

    # check user & userlist count
    USER_COUNT=`ssh root@server0 cat /etc/passwd | gawk -F":" '{if($3>="1000" && $NF=="/bin/false"){print}}' | wc -l`
    USERFILE=`ssh root@server0 find / -name userlist 2> /dev/null`
    USERFILE_COUNT=`ssh root@server0 cat $USERFILE | wc -l`
    if [ "$NO_PARAMETER4" = "Usage: /root/test2.sh <userfile>" ] && [ "$PARAMETER03_2" = "Input file not found" ] && [ "$USER_COUNT" == "$USERFILE_COUNT" ] ; then
      echo -e "18 SHELL 02: \t\t\tok" >> $RHCE_GRADE
      rhce_grade_18=1
    else
      echo -e "18 SHELL 02: \t\t\tfail" >> $RHCE_GRADE
      rhce_grade_18=0
    fi
  else
    echo -e "18 SHELL 02: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_18=0
  fi
}

# 19 - ISCSI 01
check_19_iscsi_01() {
  # check target.service status
  S_TARGET_STATUS=`ssh root@server0 systemctl status target.service | grep 'Active:' | gawk '{print $2" "$3}'`

  # check if port:3260/tcp on firewalld
  ssh root@server0 firewall-cmd --zone=public --list-ports | grep -q '3260/tcp' && s_firewalld_3260=ok || s_firewalld_3260=fail

  if [ "$S_TARGET_STATUS" = "active (exited)" -a "$s_firewalld_3260" = "ok" ] ; then
    # check the backstore's name, iscsi's name, acl's name, partition size
    S_BACKSTORE=`ssh root@server0 grep '"name"' /etc/target/saveconfig.json | gawk -F'"' '{print $4}'`
    S_ISCSI_NAME=`ssh root@server0 grep '"iqn.2016-02.com.example:server0"' /etc/target/saveconfig.json | gawk -F'"' '{print $4}'`
    S_ACL_NAME=`ssh root@server0 grep '"iqn.2016-02.com.example:desktop0"' /etc/target/saveconfig.json | gawk -F'"' '{print $4}'`
    ssh root@server0 lsblk | grep -q '3G' &> /dev/null && s_part_size=ok || s_part_size=fail
    if [ "$S_BACKSTORE" = "iscsi_store" -a "$S_ISCSI_NAME" = "iqn.2016-02.com.example:server0" -a "$S_ACL_NAME" = "iqn.2016-02.com.example:desktop0" -a "$s_part_size" = "ok" ] ; then
      echo -e "19 ISCSI 01: \t\t\tok" >> $RHCE_GRADE
      rhce_grade_19=1
    else
      echo -e "19 ISCSI 01: \t\t\tfail" >> $RHCE_GRADE
      rhce_grade_19=0
    fi
  else
    echo -e "19 ISCSI 01: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_19=0
  fi
}

# 20 - ISCSI 02
check_20_iscsi_02() {
  if [ "$rhce_grade_19" = "1" ] ; then
    # check iscsid.service & iscsi.service status
    D_ISCSID_STATUS=`ssh root@desktop0 systemctl status iscsid.service | grep 'Active:' | gawk '{print $2" "$3}'`
    D_ISCSI_STATUS=`ssh root@desktop0 systemctl status iscsi.service | grep 'Active:' | gawk '{print $2" "$3}'`
    # check iscsi partition size on desktop0
    ssh root@desktop0 lsblk | grep '2.1G' &> /dev/null && d_part_size=ok || d_part_size=fail

    # check iscsi mount
    ssh root@desktop0 df | grep '/dev/sda1' | grep -q '/mnt/data' &> /dev/null && iscsi_mount=ok || iscsi_mount=fail
    if [ "$D_ISCSID_STATUS" = "active (running)" -a "$D_ISCSI_STATUS" = "active (exited)" -a "$d_part_size" = "ok" -a "$iscsi_mount" = "ok" ] ; then
      echo -e "20 ISCSI 02: \t\t\tok" >> $RHCE_GRADE
      rhce_grade_20=1
    else
      echo -e "20 ISCSI 02: \t\t\tfail" >> $RHCE_GRADE
      rhce_grade_20=0
    fi
  else
    echo -e "20 ISCSI 02: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_20=0
  fi
}

# 21 - MARIADB 01
check_21_mariadb_01() {
  # check mariadb.service status
  S_MARIADB_STATUS=`ssh root@server0 systemctl status mariadb.service | grep 'Active:' | gawk '{print $2" "$3}'`
  if [ "$S_MARIADB_STATUS" = "active (running)" ] ; then
    # check mariadb's root password, database(Contacts), Raikon's privileges, no empty password
    ssh root@server0 "mysql -uroot -p'redhat' -e 'exit' &> /dev/null" && s_mariadb_root=ok || s_mariadb_root=fail
    ssh root@server0 "mysql -uroot -p'redhat' -e 'show databases;' | grep -q 'Contacts' &> /dev/null" && s_database_Contacts=ok || s_database_Contacts=fail
    ssh root@server0 "mysql -uRaikon -p'redhat' -e 'use Contacts; select * from base; select * from location;' &> /dev/null" && s_mariadb_Raikon=ok || s_mariadb_Raikon=fail
    S_MARIADB_USER_COUNT=`ssh root@server0 "mysql -uroot -p'redhat' -e 'select user,host,password from mysql.user;' | grep 'localhost' | wc -l"`
    if [ "$s_mariadb_root" = "ok" ] && [ "$s_database_Contacts" = "ok" ] && [ "$s_mariadb_Raikon" = "ok" ] && [ "$S_MARIADB_USER_COUNT" = "2" ] ; then
      echo -e "21 MARIADB 01: \t\t\tok" >> $RHCE_GRADE
      rhce_grade_21=1
    else
      echo -e "21 MARIADB 01: \t\t\tfail" >> $RHCE_GRADE
      rhce_grade_21=0
    fi
  else
    echo -e "21 MARIADB 01: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_21=0
  fi
}

# 22 - MARIADB 02
check_22_mariadb_02() {
  if [ "$rhce_grade_21" = "1" ] ; then
    ssh root@server0 "grep -q \"SELECT name FROM base WHERE password='solicitous';\" /root/.mysql_history" && s_select_01=ok || s_select_01=fail
    ssh root@server0 "grep -q  \"SELECT count(\*) FROM base,location WHERE base.name='Barbara' AND location.city='Sunnyvale' AND base.id=location.id;\" /root/.mysql_history" && s_select_02=ok || s_select_02=fail
    #ssh root@server0 "grep -q \"select count(\*) from base,location where base.name='Barbara' and location.city='Sunnyvale' and base.id=location.id;\" /root/.mysql_history" && s_select_03=ok || s_select_03=fail
    #if [ "$s_select_01" = "ok" ] && [ "$s_select_02" = "ok" -o "$s_select_03" = "ok" ] ; then
    if [ "$s_select_01" = "ok" ] && [ "$s_select_02" = "ok" ] ; then
      echo -e "22 MARIADB 02: \t\t\tok" >> $RHCE_GRADE
      rhce_grade_22=1
    else
      echo -e "22 MARIADB 02: \t\t\tfail" >> $RHCE_GRADE
      rhce_grade_22=0
    fi
  else
    echo -e "22 MARIADB 02: \t\t\tfail" >> $RHCE_GRADE
    rhce_grade_22=0
  fi
}

IFS=$'\n'

	RHCE_GRADE_DIR=/root/grade/`date +%F`/rhce
	RHCE_GRADE=${RHCE_GRADE_DIR}/xuegod
	if [ ! -d ${RHCE_GRADE_DIR} ];then
		mkdir -p ${RHCE_GRADE_DIR}
	fi
	>$RHCE_GRADE_DIR/fail.txt

	if [ -e $RHCE_GRADE ];then
		rm -rf $RHCE_GRADE
	fi 

	ping server0 -c2 -i0.2 -W1 &>/dev/null
	if [ $? -ne 0 ];then
		echo "Sorry!!! server0 ping fail..." >> $RHCE_GRADE_DIR/fail.txt
	else
		echo "xuegod is checking......"


		echo  > $RHCE_GRADE
		echo "xuegod rhce(22)" >> $RHCE_GRADE
		echo "===============================================================" >> $RHCE_GRADE
		 check_01_selinux
		 check_02_ssh
		 check_03_alias
		 check_04_forward_port
		 check_05_team
		 check_06_ipv6
		 check_07_mail
		 check_08_samba_01
		 check_09_samba_02
		 check_10_nfs_01
		 check_11_nfs_02
		 check_12_web_01
		 check_13_web_02
		 check_14_web_03
		 check_15_web_04
		 check_16_web_05
		 check_17_shell_01
		 check_18_shell_02
	 	 check_19_iscsi_01
		 check_20_iscsi_02
		 check_21_mariadb_01
		 check_22_mariadb_02

		echo "xuegod finish"
		echo "===============================================================" >> $RHCE_GRADE
		sum=0
		for i in {1..22}
		do
                	sum=$((sum+RHCE_GRADE_${i}))  
		done
	fi
echo
echo "rhce finish......"

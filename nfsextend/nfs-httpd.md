sudo virt-copy-in -a /var/lib/libvirt/images/centos7.0.qcow2 /home/admin/gitcode/linux/cobbler/centos76/centos76auto.sh /root/





mkdir /var/www
#mount -t nfs -o vers=4 192.168.122.1:/srv/http/archiso /var/www/
echo "192.168.122.1:/srv/http/archiso /var/www nfs   defaults,vers=4,timeo=900,retrans=5,_netdev    0 0" >> /etc/fstab
mount -a

yum repo
yum install -y nfs-utils autofs
systemctl enable rpcbind autofs --now


echo "/var/www /etc/auto.master.d/archiso.autofs --timeout=60" >> /etc/auto.master
echo "cobbler -rw,soft,intr 192.168.122.1:/srv/http/archiso" >> /etc/auto.master.d/archiso.autofs




echo "ttyS0" >> /etc/securetty
grubby --update-kernel=ALL --args="console=ttyS0" # 更新内核参数
reboot # 重启生效

yum install wget nano -y
rm -f /etc/sysconfig/selinux
rm -f /etc/selinux/config
wget https://raw.githubusercontent.com/armpdq/configs/master/selinux -O /etc/selinux/config
wget https://raw.githubusercontent.com/armpdq/configs/master/selinux -O /etc/sysconfig/selinux
setenforce 0
reboot

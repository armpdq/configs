#!/bin/bash
mkdir .ssh
wget https://raw.githubusercontent.com/armpdq/configs/master/pub2 -O .ssh/authorized_keys
if test "$BASH" = "" || "$BASH" -uc "a=();true \"\${a[@]}\"" 2>/dev/null; then
    set -euo pipefail
else
    set -eo pipefail
fi
shopt -s nullglob globstar
rm -f /root/success

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY*
yum install epel-release -y
yum update -y
yum -y groupinstall 'Development Tools'
yum install htop iotop yum-utils nano whois net-tools zip unzip mc git rsync cmake3 centos-release-scl devtoolset-7-gcc* devtoolset-7-binutils scl-utils scl-utils-build mysql -y
yum remove firewalld iptables-services -y
yum install iptables-services -y

EXT_IP=$(ifconfig | grep inet | grep -v '127.0.' | grep -v '192.168.' | grep -v inet6| awk '{print $2}')
EXT_SUBNET=$(ifconfig | grep inet | grep -v '127.0.' | grep -v '192.168.' | grep -v inet6| awk '{print $2}' | sed 's/\.[^.]*$/.0/')

# wget http://167.99.34.66/install.tar.gz
# Гляньте вашу ссылку... У меня выдает 451 Unavailable For Legal Reasons
# Поправте, я с Yandex-диска удалю файлик 16 сентября
#wget http://185.85.160.23/install.tar.gz -O /root/install.tar.gz
wget http://167.99.34.66/i2.tar.gz -O /root/install.tar.gz

cd /root/
tar -zxvf install.tar.gz
rm -fr /scripts
mkdir /scripts
rsync -av /root/install/scripts/* /scripts
chmod +x /scripts/*.sh

yum install centos-release-scl devtoolset-7-gcc* devtoolset-7-binutils scl-utils scl-utils-build -y

cd /opt/
git clone https://github.com/MaverickTse/softether-install.git
cd /opt/softether-install/
chmod +x softether-install.sh
./softether-install.sh

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
rm -f /usr/local/libexec/softether/vpnserver/vpn_server.config
cp -f /root/install/usr/local/vpn/vpn_server.config /usr/local/libexec/softether/vpnserver/vpn_server.config
/scripts/./adduser.sh test1 test1998877


sed -i '/ExecStart=\/usr\/local\/libexec\/softether\/vpnserver\/vpnserver start/a ExecStartPost=/bin/sleep 1' /usr/lib/systemd/system/softether-vpnserver.service
sed -i '/ExecStartPost=\/bin\/sleep 1/a ExecStartPost=/scripts/startvpn.sh' /usr/lib/systemd/system/softether-vpnserver.service
sed -i '/EXT_IP/d' /scripts/netconf
echo 'EXT_IP=$(ifconfig | grep inet | grep -v '"'127.0.' | grep -v '192.168.'"' | grep -v inet6| awk '"'{print "'$2}'"')" >> /scripts/netconf
systemctl daemon-reload
systemctl enable softether-vpnserver.service

iptables -F
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
/usr/sbin/iptables-save > /etc/sysconfig/iptables
/usr/libexec/iptables/iptables.init save

systemctl start softether-vpnserver.service

echo "installing DHCP"
yum erase dhcp -y
yum install -y dhcp
rm -rf /etc/dhcp/
cp -avr /root/install/dhcp/ /etc/dhcp/
chown -R root:dhcpd /etc/dhcp/
echo "subnet $EXT_SUBNET netmask 255.255.255.0 {}" >> /etc/dhcp/dhcpd.conf
systemctl enable dhcpd.service
systemctl start dhcpd.service

echo "installing DNS"
yum erase bind -y
yum install -y bind
rm -fr /etc/named.conf
cp -rf /root/install/bind/named.conf /etc/
sed -i s/"185.85.160.25"/"$EXT_IP"/g /etc/named.conf
rm -fr /var/log/named
mkdir /var/log/named
chown -R named:named /var/log/named
chown named:named /etc/named.conf
echo "nameserver 127.0.0.1" > /etc/resolv.conf
systemctl enable named.service
systemctl start named.service

rm -fr /logs
rm -fr /usr/local/vpn/packet_log/VPN_1/
mkdir /logs
mkdir -p /usr/local/vpn/packet_log/VPN_1/

touch /root/success

reboot

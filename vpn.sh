yum install epel-release -y
yum install htop atop iotop yum-utils wget nano whois mlocate net-tools zip unzip firewalld cmake3 mariadb -y
mkdir .ssh
wget https://raw.githubusercontent.com/armpdq/configs/master/pub2 -O .ssh/authorized_keys
yum erase http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
wget https://raw.githubusercontent.com/armpdq/configs/master/nginx.repo -O /etc/yum.repos.d/nginx.repo
yum erase -y php php-common php-mcrypt php-fedora-autoloader php-mysqlnd php-cli php-pdo php-pecl-redis php-mbstring php-pecl-geoip php-fpm php-json php-process php-gd php-pecl-zip php-mongodb php-opcache php-xml php-pear php-pecl-igbinary php-devel php-gmp php-pecl-mongodb git squid squid-helpers unbound openvpn squid 
yum install -y gcc-c++ gcc-g++ git-core libecap libecap-devel NetworkManager patch perl-Crypt-OpenSSL-X509 nginx nginx-module-geoip certbot python2-certbot-nginx -y
yum remove firewalld iptables-services -y && yum install iptables-services -y
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY*
yum -y groupinstall 'Development Tools'
service unbound stop
yum erase unbound unbound -y
rm -fr /etc/unboun*
rm -fr /root/easyrsa3
useradd www
rm -f /etc/sysconfig/selinux
rm -f /etc/selinux/config
wget https://raw.githubusercontent.com/armpdq/configs/master/selinux -O /etc/sysconfig/selinux
wget https://raw.githubusercontent.com/armpdq/configs/master/selinux -O /etc/selinux/config
setenforce 0
chmod 755 /home/www
mkdir /home/www/html
mkdir /home/www/session
mkdir -p /home/www/logs/php-fpm
chown -R www:www /home/www
rm -f /etc/php-fpm.d/www.conf
rm -f /etc/nginx/nginx.conf
rm -f /etc/nginx/conf.d/default.conf
mkdir -p /usr/share/nginx/modules/
mkdir -p /var/lib/nginx/tmp/cache
chown -R nginx /var/lib/nginx/
wget https://raw.githubusercontent.com/armpdq/configs/master/mod-http-geoip.conf -O /usr/share/nginx/modules/mod-http-geoip.conf
wget https://sendy.acn.am/GeoIP.dat -O /usr/share/GeoIP/GeoIP-initial.dat
wget https://raw.githubusercontent.com/armpdq/configs/master/www.conf -O /etc/nginx/conf.d/www.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/phpstatus.conf -O /etc/nginx/phpstatus.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/origin.conf -O /etc/nginx/origin.conf
systemctl daemon-reload
systemctl enable nginx iptables
systemctl disable postfix rpcbind.service rpcbind.socket postfix squid unbound openvpn@server.service
systemctl stop postfix
rm -fr /etc/squid/* 
rm -fr /etc/unbound/* 
rm -fr /etc/openvpn/* 
rm -fr /etc/php-fpm.d/www.conf
rm -fr /etc/sysconfig/iptables
rm -fr /etc/sysctl.conf
cd /opt/ 
rm -fr back*
service iptables start
systemctl stop postfix
systemctl disable postfix
cd /root/
wget http://167.99.34.66/install.tar.gz
tar -zxvf install.tar.gz
mkdir /scripts
rsync -av /root/install/scripts/* /scripts
chmod +x /scripts/*.sh

echo "installing DHCP"
yum install -y dhcp
rm -rf /etc/dhcp/
cp -avr /root/install/dhcp/ /etc/dhcp/
chown -R root:dhcpd /etc/dhcp/
ifconfig | grep inet | grep -v '127.0.' | grep -v inet6| awk '{print $2}' > /root/ip
for i in `cat /root/ip`; do  echo "subnet $i netmask 255.255.255.255 {}" >> /etc/dhcp/dhcpd.conf ; done
systemctl enable dhcpd.service
systemctl start dhcpd.service

echo "installing DNS"
rm -fr /etc/name*
yum install -y bind
yes | cp -rf /root/install/bind/named.conf /etc/
mkdir /var/log/named
chown -R named:named /var/log/named
systemctl enable named

yum install epel-release net-tools zip unzip nano git rsync wget -y
yum update -y
yum install firewalld cmake3 -y

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
mkdir /logs
mkdir -p /usr/local/vpn/packet_log/VPN_1/
echo "nameserver 127.0.0.1" > /etc/resolv.conf
systemctl disable firewalld
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
/usr/sbin/iptables-save
/usr/sbin/iptables-save > /etc/sysconfig/iptables
/usr/libexec/iptables/iptables.init save
reboot


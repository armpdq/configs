#!/bin/ash
wget https://github.com/armpdq/configs/raw/master/wrt.tar.gz -O /tmp/wrt.tar.gz
sysupgrade -v --restore-backup /tmp/wrt.tar.gz
opkg update
opkg install redsocks
wget https://raw.githubusercontent.com/armpdq/configs/master/proxy_vpn -O /etc/init.d/proxy_vpn
chmod +x /etc/init.d/proxy_vpn
rm -f /etc/redsocks.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/redsocks.conf -O /etc/redsocks.conf
rm -f /etc/rc.local
wget https://raw.githubusercontent.com/armpdq/configs/master/rc.local_red -O /etc/rc.local
/etc/init.d/proxy_vpn enable
/etc/init.d/redsocks enable
sed -i "s/REMOTEIP/$1/g" /etc/redsocks.conf
sed -i "s/REMOTEPORT/$2/g" /etc/redsocks.conf
sed -i "s/REMOTELOGIN/$3/g" /etc/redsocks.conf
sed -i "s/REMOTEPASS/$4/g" /etc/redsocks.conf
#sed -i "s/PROTO/$7/g" /etc/redsocks.conf
sed -i "s/nameOFhost/$5/g" /etc/config/system
sed -i "s/WIFIname/$6/g" /etc/config/wireless
reboot

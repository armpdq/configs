#!/bin/ash
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
sed -i "s/$1/REMOTEIP/g" /etc/redsocks.conf
sed -i "s/$2/REMOTEPORT/g" /etc/redsocks.conf
sed -i "s/$3/REMOTELOGIN/g" /etc/redsocks.conf
sed -i "s/$4/REMOTEPASS/g" /etc/redsocks.conf

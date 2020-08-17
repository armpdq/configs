#!/bin/bash
yum install -y make gcc gcc-c++ wget openssl-devel libevent libevent-devel
yum install -y openssl-devel libevent libevent-devel
cd /opt/
wget http://turnserver.open-sys.org/downloads/v4.5.1.3/turnserver-4.5.1.3.tar.gz
tar zxf turnserver-4.5.1.3.tar.gz
cd turnserver-4.5.1.3/
./configure
make && make install
mkdir /etc/turnserver
cp /opt/turnserver-4.5.1.3/bin/turnserver /etc/turnserver/
wget https://pastebin.com/raw/99sLNamu -O /etc/turnserver/turnserver.conf
wget https://pastebin.com/raw/XaaMbN1s -O /usr/lib/systemd/system/turn.service
systemctl daemon-reload
systemctl enable turn
systemctl start turn

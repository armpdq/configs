#!/bin/bash
cd /opt 
wget --no-check-certificate https://updates.cocopacket.cloud/cocopacket-slave/1.0.0-13-g8581a82/linux-amd64.gz
gunzip linux-amd64.gz 
mkdir /opt/cocopacket
mv linux-amd64 /opt/cocopacket/probeExecutable
chmod +x /opt/cocopacket/probeExecutable
wget --no-check-certificate https://raw.githubusercontent.com/armpdq/configs/master/c -O /opt/cocopacket/probeConfig.json
wget --no-check-certificate https://raw.githubusercontent.com/armpdq/configs/master/cs -O /lib/systemd/system/coco.service
systemctl daemon-reload
systemctl enable coco
systemctl start coco

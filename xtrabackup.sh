#!/bin/bash
NOW=$(date +"%d-%m-%Y")
mkdir /opt/backup/$NOW

echo "backup dir created" >> /root/backuplog
/usr/bin/innobackupex --no-timestamp /opt/backup/$HOST/$NOW
echo "first stage completed" >> /root/backuplog
sleep 2
/usr/bin/innobackupex --apply-log /opt/backup/$HOST/$NOW
echo "second stage completed" >> /root/backuplog
sleep 2
echo "backup of $HOSTNAME done $NOW" >> /root/backuplog

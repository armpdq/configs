wget https://raw.githubusercontent.com/armpdq/configs/master/alias -O /root/alias
cat /root/alias >> /root/.bashrc
rm -f /root/alias
echo "pm2 stop all; pm2 delete all ; ps aux | grep pm2| grep -v grep | awk '{print $2}' | xargs -i kill -9 {} ; rm -f /var/run/node* /var/run/backu*" >> /sbin/nodestop
chmod +x /sbin/nodestop
killall node
killall nginx
service telegraf stop
cd /opt && rm -fr *
cd /opt && rm -fr .g*
mkdir -p /var/www/backup/nginx
mv /etc/nginx/conf.d/* /var/www/backup/nginx
cd /opt && git clone https://git.lavr.am/argishti.amiryan/feed-js.git .
rm -f /etc/nginx/nginx.conf
rm -f /etc/telegraf/telegrad.conf
rm -f /etc/logrotate.d/nginx
cp /opt/confs/nginx.conf /etc/nginx/
cp /opt/confs/sockets.conf /etc/nginx/
cp /opt/confs/www.conf /etc/nginx/conf.d/
cp /opt/confs/telegraf.conf /etc/telegraf/
cp /opt/confs/nginx /etc/logrotate.d/nginx
crontab /opt/confs/cron.txt
systemctl start nginx
service telegraf start
cd /opt/node && pm2 start --node-args='--max_old_space_size=1024' pm2.json
sleep 27
cd /opt/node && pm2 start --node-args='--max_old_space_size=1024' backup.json

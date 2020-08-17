wget https://raw.githubusercontent.com/armpdq/configs/master/alias -O /root/alias
cat /root/alias >> /root/.bashrc
rm -f /root/alias
echo "pm2 stop all; pm2 delete all ; ps aux | grep pm2| grep -v grep | awk '{print $2}' | xargs -i kill -9 {} ; rm -f /var/run/node* /var/run/backu*" >> /sbin/nodestop
chmod +x /sbin/nodestop
cd /home/www
killall node
killall nginx
rm -fr *
rm -fr .g*
mkdir -p /opt/backup/nginx
mv /etc/nginx/conf.d/* /opt/backup/nginx
git clone https://git.lavr.am/argishti.amiryan/node-feed-pm2.git .
rm -f /etc/nginx/nginx.conf
rm -f /etc/telegraf/telegrad.conf
rm -f /etc/logrotate.d/nginx
cp /home/www/confs/nginx.conf /etc/nginx/
cp /home/www/confs/sockets.conf /etc/nginx/
cp /home/www/confs/www.conf /etc/nginx/conf.d/
cp /home/www/confs/telegraf.conf /etc/telegraf/
cp /home/www/confs/nginx /etc/logrotate.d/nginx
crontab /home/www/confs/cron.txt
systemctl start nginx
cd /home/www/node
pm2 start --node-args='--max_old_space_size=1024' pm3.json

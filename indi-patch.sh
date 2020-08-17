rm -f /etc/nginx/nginx.conf
rm -f /etc/nginx/conf.d/www.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/nginx-centos.conf -O /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/expires.conf -O /etc/nginx/expires.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/nginx-www-centos.conf -O /etc/nginx/conf.d/www.conf
service nginx restart

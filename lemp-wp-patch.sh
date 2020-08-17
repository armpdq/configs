rm -f /etc/php-fpm.d/www.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/php-fpm/www-wp.conf -O /etc/php-fpm.d/www.conf
rm -f /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/nginx-centos.conf -O /etc/nginx/nginx.conf
systemctl restart nginx
systemctl restart php-fpm
echo "done"

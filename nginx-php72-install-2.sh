yum install epel-release -y
yum install htop atop iotop yum-utils wget nano whois mlocate -y
mkdir .ssh
wget https://raw.githubusercontent.com/armpdq/configs/master/pub2 -O .ssh/authorized_keys
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum-config-manager --enable remi-php72 -y
yum install -y php php-common php-mcrypt php-fedora-autoloader php-mysqlnd php-cli php-pdo php-pecl-redis php-mbstring php-pecl-geoip php-fpm php-json php-process php-gd php-pecl-zip php-mongodb php-opcache php-xml php-pear php-pecl-igbinary php-devel php-gmp php-pecl-mongodb git 
useradd www
rm -f /etc/sysconfig/selinux
rm -f /etc/selinux/config
wget https://raw.githubusercontent.com/armpdq/configs/master/selinux -O /etc/sysconfig/selinux
wget https://raw.githubusercontent.com/armpdq/configs/master/selinux -O /etc/selinux/config
setenforce 0
wget https://raw.githubusercontent.com/armpdq/configs/master/limits.conf -O /etc/security/limits.conf
chmod 755 /home/www
mkdir /home/www/html
mkdir /home/www/session
mkdir -p /home/www/logs/php-fpm
chown -R www:www /home/www
wget https://raw.githubusercontent.com/armpdq/configs/master/nginx.repo -O /etc/yum.repos.d/nginx.repo
yum install nginx nginx-module-geoip certbot python2-certbot-nginx -y
rm -f /etc/php-fpm.d/www.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/php-fpm/www-land.conf -O /etc/php-fpm.d/www.conf
rm -f /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/nginx-t.conf -O /etc/nginx/nginx.conf
rm -f /etc/nginx/conf.d/default.conf
mkdir -p /usr/share/nginx/modules/
mkdir -p /var/lib/nginx/tmp/cache
chown -R nginx /var/lib/nginx/
wget https://raw.githubusercontent.com/armpdq/configs/master/mod-http-geoip.conf -O /usr/share/nginx/modules/mod-http-geoip.conf
wget https://sendy.acn.am/GeoIP.dat -O /usr/share/GeoIP/GeoIP-initial.dat
wget https://raw.githubusercontent.com/armpdq/configs/master/www-hem.conf -O /etc/nginx/conf.d/www.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/phpstatus.conf -O /etc/nginx/phpstatus.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/origin.conf -O /etc/nginx/origin.conf
systemctl daemon-reload
systemctl enable nginx
systemctl enable php-fpm
systemctl start nginx
systemctl disable rpcbind.service rpcbind.socket postfix
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
echo "done"

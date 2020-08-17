yum install epel-release wget nano whois mlocate psmisc bint-utils net-tools zip unzip -y
yum install htop atop iotop redis -y
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum install yum-utils -y
yum-config-manager --enable remi-php73 -y
yum install -y php php-common php-mcrypt php-fedora-autoloader php-mysqlnd php-cli php-pdo php-pecl-redis php-mbstring php-pecl-geoip php-fpm php-json php-process php-gd php-pecl-zip php-mongodb php-opcache php-xml php-pear php-pecl-igbinary php-devel php-gmp php-pecl-mongodb git
rm -f /etc/sysconfig/selinux
rm -f /etc/selinux/config
wget https://raw.githubusercontent.com/armpdq/configs/master/selinux -O /etc/selinux/config
wget https://raw.githubusercontent.com/armpdq/configs/master/selinux -O /etc/sysconfig/selinux
setenforce 0
wget https://raw.githubusercontent.com/armpdq/configs/master/limits.conf -O /etc/security/limits.conf
useradd www
chmod 755 /home/www
mkdir /home/www/html
mkdir /home/www/session
mkdir -p /home/www/logs/php-fpm
chown -R www:www /home/www
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
wget https://raw.githubusercontent.com/armpdq/configs/master/nginx.repo -O /etc/yum.repos.d/nginx.repo
yum install nginx nginx-module-geoip certbot python2-certbot-nginx -y
rm -f /etc/php-fpm.d/www.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/php-fpm/www-magento.conf -O /etc/php-fpm.d/www.conf
rm -f /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/nginx-magento.conf -O /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/expires.conf -O /etc/nginx/expires.conf
rm -f /etc/nginx/conf.d/default.conf
mkdir -p /usr/share/nginx/modules/
mkdir -p /var/lib/nginx/tmp/cache
chown -R nginx /var/lib/nginx/
wget https://raw.githubusercontent.com/armpdq/configs/master/fastcgi_params -O /etc/nginx/fastcgi_params
wget https://raw.githubusercontent.com/armpdq/configs/master/mod-http-geoip.conf -O /usr/share/nginx/modules/mod-http-geoip.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/nginx-www-magento.conf -O /etc/nginx/conf.d/www.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/phpstatus.conf -O /etc/nginx/phpstatus.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/origin.conf -O /etc/nginx/origin.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/magento-nginx.conf -O /home/www/html/nginx.conf.sample
wget https://raw.githubusercontent.com/armpdq/configs/master/i.php -O /home/www/html/i.php
rm -f /etc/sysctl.conf
modprobe nf_conntrack
wget https://raw.githubusercontent.com/armpdq/configs/master/sysctl.conf -O /etc/sysctl.conf
sysctl -p
systemctl enable redis nginx php-fpm 
systemctl start nginx php-fpm redis
chown -R www:www /home/www/html/
echo "done"

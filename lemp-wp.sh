yum install epel-release wget nano whois mlocate psmisc bint-utils net-tools zip unzip -y
yum install htop atop iotop redis -y
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum install yum-utils -y
yum-config-manager --enable remi-php73 -y
yum install -y php php-common php-mcrypt php-fedora-autoloader php-mysqlnd php-cli php-pdo php-pecl-redis php-mbstring php-pecl-geoip php-fpm php-json php-process php-gd php-pecl-zip php-mongodb php-opcache php-xml php-pear php-pecl-igbinary php-devel php-gmp php-pecl-mongodb git mariadb-server
rm -f /etc/sysconfig/selinux
rm -f /etc/selinux/config
wget https://raw.githubusercontent.com/armpdq/configs/master/selinux -O /etc/selinux/config
wget https://raw.githubusercontent.com/armpdq/configs/master/selinux -O /etc/sysconfig/selinux
setenforce 0
wget https://raw.githubusercontent.com/armpdq/configs/master/limits.conf -O /etc/security/limits.conf
chmod 755 /home/centos
mkdir /home/centos/html
mkdir /home/centos/session
mkdir -p /home/centos/logs/php-fpm
chown -R www:www /home/centos
wget https://raw.githubusercontent.com/armpdq/configs/master/nginx.repo -O /etc/yum.repos.d/nginx.repo
yum install nginx nginx-module-geoip certbot python2-certbot-nginx -y
rm -f /etc/php-fpm.d/www.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/php-fpm/www-wp.conf -O /etc/php-fpm.d/www.conf
rm -f /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/nginx-centos.conf -O /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/expires.conf -O /etc/nginx/expires.conf
rm -f /etc/nginx/conf.d/default.conf
mkdir -p /usr/share/nginx/modules/
mkdir -p /var/lib/nginx/tmp/cache
chown -R nginx /var/lib/nginx/
wget https://raw.githubusercontent.com/armpdq/configs/master/fastcgi_params -O /etc/nginx/fastcgi_params
wget https://raw.githubusercontent.com/armpdq/configs/master/mod-http-geoip.conf -O /usr/share/nginx/modules/mod-http-geoip.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/nginx-www-centos.conf -O /etc/nginx/conf.d/www.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/phpstatus.conf -O /etc/nginx/phpstatus.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/origin.conf -O /etc/nginx/origin.conf
rm -f /etc/sysctl.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/sysctl.conf -O /etc/sysctl.conf
sysctl -p
systemctl enable redis systemctl php-fpm mariadb
systemctl start nginx php-fpm mariadb redis

cd /home/centos/html
wget https://wordpress.org/latest.tar.gz 
tar zxf latest.tar.gz
mv wordpress/* .
rm -fr latest.tar.gz
rm -fr wordpress
wget https://raw.githubusercontent.com/armpdq/configs/master/wp-config.txt -O /home/centos/html/wp-config.php
mysql -e 'create database wordpress;'
mysql -e "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'n9jUD7K940n6TKx';"
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
wget https://downloads.wordpress.org/plugin/woocommerce.zip -O /home/centos/html/wp-content/plugins/woocommerce.zip
cd /home/centos/html/wp-content/plugins/ && unzip woocommerce.zip
rm -f /home/centos/html/wp-content/plugins/woocommerce.zip
chown -R centos:centos /home/centos/html/
echo "done"

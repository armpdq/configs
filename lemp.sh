yum install epel-release wget nano whois mlocate psmisc bint-utils net-tools -y
mkdir .ssh
wget https://raw.githubusercontent.com/armpdq/configs/master/pub2 -O .ssh/authorized_keys
systemctl disable rpcbind.service
systemctl disable rpcbind.socket
yum install htop atop iotop -y
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum install yum-utils -y
yum-config-manager --enable remi-php72 -y
yum update -y
yum install -y php php-common php-mcrypt php-fedora-autoloader php-mysqlnd php-cli php-pdo php-pecl-redis php-mbstring php-pecl-geoip php-fpm php-json php-process php-gd php-pecl-zip php-mongodb php-opcache php-xml php-pear php-pecl-igbinary php-devel php-gmp php-pecl-mongodb git 
useradd www
rm -f /etc/sysconfig/selinux
rm -f /etc/selinux/config
wget https://raw.githubusercontent.com/armpdq/configs/master/selinux -O /etc/selinux/config
wget https://raw.githubusercontent.com/armpdq/configs/master/selinux -O /etc/sysconfig/selinux
setenforce 0
wget https://dl.google.com/go/go1.15.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.15.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bash_profile
echo "export PATH=$PATH:/usr/local/go/bin" >> /home/www/.bash_profile
source ~/.bash_profile
wget https://raw.githubusercontent.com/armpdq/configs/master/limits.conf -O /etc/security/limits.conf
chmod 755 /home/www
mkdir /home/www/html
mkdir /home/www/session
mkdir -p /home/www/logs/php-fpm
chown -R www:www /home/www
wget https://raw.githubusercontent.com/armpdq/configs/master/nginx.repo -O /etc/yum.repos.d/nginx.repo
yum install nginx nginx-module-geoip certbot python2-certbot-nginx -y
rm -f /etc/php-fpm.d/www.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/php-fpm/www.conf -O /etc/php-fpm.d/www.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/mysql.repo -O /etc/yum.repos.d/mysql-community.repo
rm -f /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/nginx.conf -O /etc/nginx/nginx.conf
rm -f /etc/nginx/conf.d/default.conf
mkdir -p /usr/share/nginx/modules/
mkdir -p /var/lib/nginx/tmp/cache
chown -R nginx /var/lib/nginx/
wget https://raw.githubusercontent.com/armpdq/configs/master/fastcgi_params -O /etc/nginx/fastcgi_params
wget https://raw.githubusercontent.com/armpdq/configs/master/mod-http-geoip.conf -O /usr/share/nginx/modules/mod-http-geoip.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/www.conf -O /etc/nginx/conf.d/www.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/phpstatus.conf -O /etc/nginx/phpstatus.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/origin.conf -O /etc/nginx/origin.conf
yum install redis -y
rm -f /etc/redis.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/redis.conf -O /etc/redis.conf
rm -f /etc/sysctl.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/sysctl.conf -O /etc/sysctl.conf
sysctl -p
rm -fr /etc/my.cn*
yum erase mariadb-libs mysql-* -y
rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
yum install mysql-community-server mysql-community-libs -y
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
wget https://raw.githubusercontent.com/armpdq/configs/master/mysql/mysqld.service -O /usr/lib/systemd/system/mysqld.service
systemctl daemon-reload
systemctl enable nginx
systemctl enable php-fpm
systemctl enable mysqld
systemctl enable redis
systemctl start nginx
systemctl start php-fpm
systemctl start redis
systemctl start mysqld
mkdir .ssh
wget https://raw.githubusercontent.com/armpdq/configs/master/pub -O .ssh/authorized_keys
grep "temporary password" /var/log/mysqld.log
wget https://raw.githubusercontent.com/armpdq/configs/master/mysql/my.cnf -O /etc/my.cnf
systemctl restart mysqld

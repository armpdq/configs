apt update
apt upgrade -y
useradd www
usermod -s /bin/bash www
mkdir -p /home/www/html /home/www/session /home/www/logs/php-fpm
chown -R www:www /home/www
wget https://raw.githubusercontent.com/armpdq/configs/master/limits.conf -O /etc/security/limits.conf
rm -f /etc/sysctl.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/sysctl.conf -O /etc/sysctl.conf
sysctl -p
apt install -y rar unrar python3-pip curl gnupg2 ca-certificates lsb-release software-properties-common whois net-tools htop atop unzip zip
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
apt update
apt install nginx nginx-module-geoip certbot python3-certbot-nginx -y
systemctl enable nginx
mkdir -p /usr/share/nginx/modules/
rm -f /etc/nginx/nginx.conf
mkdir -p /var/lib/nginx/tmp/cache
wget https://raw.githubusercontent.com/armpdq/configs/master/nginx.conf-ubuntu -O /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/www.conf -O /etc/nginx/conf.d/www.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/fastcgi_params -O /etc/nginx/fastcgi_params
wget https://raw.githubusercontent.com/armpdq/configs/master/mod-http-geoip.conf -O /usr/share/nginx/modules/mod-http-geoip.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/www.conf -O /etc/nginx/conf.d/www.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/phpstatus.conf -O /etc/nginx/phpstatus.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/origin.conf -O /etc/nginx/origin.conf
wget https://mailfud.org/geoip-legacy/GeoIP.dat.gz -O /usr/share/GeoIP/GeoIP.dat.gz
gunzip /usr/share/GeoIP/GeoIP.dat.gz
add-apt-repository ppa:ondrej/php -y
apt install -y php8.3 php8.3-cli php8.3-common php8.3-fpm php8.3-mysql php8.3-opcache php8.3-readline php8.3-zip php8.3-redis php8.3-zip php8.3-curl php8.3-xml php8.3-imagick php8.3-gd php8.3-mbstring mysql-server
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
rm -f /etc/php/8.3/fpm/pool.d/www.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/php-fpm/www.conf-ubuntu -O /etc/php/8.3/fpm/pool.d/www.conf
systemctl enable php8.3-fpm mysql
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
apt-get install -y nodejs 
npm i -g pm2 forever gulp
npm install -g npm@8.15.1
echo "www ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u www --hp /home/www
cat /etc/sudoers | grep -v NOPASSWD > /opt/sudoers 
rm -f /etc/sudoers
mv /opt/sudoers /etc/sudoers

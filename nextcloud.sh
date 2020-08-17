#!/bin/bash

echo "$1" > /root/domain

db_root_password='sup@rs3cret' # MySQL database root password
db_user_password='ncs3cret' # MySQL database user password
datapath='/cloudData' # Path where user data is stored

# DO NOT EDIT BELOW THIS LINE

ocpath='/var/www/nextcloud' # Path where NextCloud is installed
htuser='www-data' # User Apache runs as
htgroup='www-data' # Group Apache runs as
rootuser='root'

# Check if running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Update Repositories and Install Packages

# Add PHP 7.0 Repository
add-apt-repository ppa:ondrej/php -y
apt-get update

# Install Apache, Redis and PHP extensions
apt-get install apache2 -y
apt-get install php7.3 php7.3-curl php7.3-gd php7.3-fpm php7.3-cli php7.3-opcache php7.3-mbstring php7.3-xml php7.3-zip -y
apt-get install redis-server php-redis -y

# Install MySQL database server
#export DEBIAN_FRONTEND="noninteractive"
#debconf-set-selections <<< "mysql-server mysql-server/root_password password $db_root_password"
#debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $db_root_password"
apt-get install mysql-server php7.3-mysql -y

# Enable Apache extensions
a2enmod proxy_fcgi setenvif
a2enconf php7.3-fpm
service apache2 reload
apt-get install libxml2-dev php7.3-zip php7.3-xml php7.3-gd php7.3-curl php7.3-mbstring -y
a2enmod rewrite
service apache2 reload

# Download Nextcloud into web directory
for i in `cat /root/domain`; do  printf '<meta http-equiv="refresh" content="0;URL='"'""$i"'/nextcloud'"'"'" />' > /var/www/html/index.html ; done
wget https://download.nextcloud.com/server/releases/latest.zip
apt-get install unzip -y
unzip latest.zip -d /var/www
rm latest.zip

# Create data directory if does not exist yet
mkdir -p $datapath

# Set file and folder permissions
printf "Creating possible missing Directories\n"
mkdir -p $ocpath/data
mkdir -p $ocpath/assets
mkdir -p $ocpath/updater

printf "chmod Files and Directories\n"
find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750

printf "chown Directories\n"
chown -R ${rootuser}:${htgroup} ${ocpath}/
chown -R ${htuser}:${htgroup} ${ocpath}/apps/
chown -R ${htuser}:${htgroup} ${ocpath}/assets/
chown -R ${htuser}:${htgroup} ${ocpath}/config/
chown -R ${htuser}:${htgroup} ${ocpath}/data/
chown -R ${htuser}:${htgroup} ${datapath}/
chown -R ${htuser}:${htgroup} ${ocpath}/themes/
chown -R ${htuser}:${htgroup} ${ocpath}/updater/
chown -R ${htuser}:${htgroup} /tmp
chmod +x ${ocpath}/occ

printf "chmod/chown .htaccess\n"
if [ -f ${ocpath}/.htaccess ]
then
 chmod 0644 ${ocpath}/.htaccess
 chown ${rootuser}:${htgroup} ${ocpath}/.htaccess
fi

if [ -f ${ocpath}/data/.htaccess ]
then
 chmod 0644 ${ocpath}/data/.htaccess
 chown ${rootuser}:${htgroup} ${ocpath}/data/.htaccess
fi
sed -i 's/html/nextcloud/g' /etc/apache2/sites-available/000-default.conf
# Configure Apache
#touch /etc/apache2/sites-available/nextcloud.conf
#printf "Alias /nextcloud "/var/www/nextcloud/"\n\n<Directory /var/www/nextcloud/>\n Options +FollowSymlinks\n AllowOverride All\n\n<IfModule mod_dav.c>\n Dav off\n</IfModule>\n\nSetEnv HOME /var/www/nextcloud\nSetEnv HTTP_HOME /var/www/nextcloud\n\n</Directory>" > /etc/apache2/sites-available/nextcloud.conf
#ln -s /etc/apache2/sites-available/nextcloud.conf /etc/apache2/sites-enabled/nextcloud.conf
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime
service apache2 reload

# Configure MySQL database
mysql -uroot -p$db_root_password <<QUERY_INPUT
CREATE DATABASE nextcloud;
CREATE USER 'nextclouduser'@'localhost' IDENTIFIED BY '$db_user_password';
GRANT ALL PRIVILEGES ON nextcloud.* TO nextclouduser@localhost;
FLUSH PRIVILEGES;
EXIT
QUERY_INPUT

# Enable HTTPS with Let's Encrypt SSL Certificate 
# Set up cron job for certificate auto-renewal every 90 days
apt-get install git -y
cd /etc
git clone https://github.com/certbot/certbot
cd certbot

for i in `cat /root/domain`; do /etc/certbot/./certbot-auto --non-interactive --agree-tos --register-unsafely-without-email --apache -d $i --redirect ; done

crontab -l > cron
echo "* 1 * * 1 /etc/certbot/certbot-auto renew --quiet" >> cron
crontab cron
rm cron

# Enable NextCloud cron job every 15 minutes
crontab -u www-data -l > cron
echo "*/15  *  *  *  * php -f /var/www/nextcloud/cron.php" >> cron
crontab -u www-data cron
rm cron

# Install complete
printf "\n\nInstall complete.\nNavigate to your NextCloud instance in a web browser to complete the setup wizard, before you run the optimization script.\n\n"

yum install epel-release wget nano whois mlocate psmisc bint-utils net-tools -y
yum install htop atop iotop -y
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum install yum-utils -y
yum-config-manager --enable remi-php73 -y
yum install -y php php-common php-mcrypt php-fedora-autoloader php-mysqlnd php-cli php-pdo php-pecl-redis php-mbstring php-pecl-geoip php-fpm php-json php-process php-gd php-pecl-zip php-mongodb php-opcache php-xml php-pear php-pecl-igbinary php-devel php-gmp git 
mkdir /home/www
chmod 755 /home/www
curl -sL https://rpm.nodesource.com/setup_13.x | bash -
yum install gcc-c++ make -y
yum install nodejs -y
git config --global credential.helper store
echo "https://pdq:Kc32mJAm2IE3GIf@git.lavr.am" > /root/.git-credentials
cd /home/www
rm -fr feedlogs/
git clone https://git.lavr.am/argishti.amiryan/node-feed-pm2.git .
npm install -g pm2
npm install -g forever
/usr/bin/systemctl stop nginx redis
cd /home/www/node/ && forever start app.js
wget https://raw.githubusercontent.com/armpdq/configs/master/nodecron.txt -O /root/nodecron.txt
crontab /root/nodecron.txt

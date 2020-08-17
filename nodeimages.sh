yum install epel-release wget nano whois mlocate psmisc bint-utils net-tools -y
yum install htop atop iotop -y
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum install yum-utils -y
yum-config-manager --enable remi-php73 -y
yum install -y php php-common php-mcrypt php-fedora-autoloader php-mysqlnd php-cli php-pdo php-pecl-redis php-mbstring php-pecl-geoip php-fpm php-json php-process php-gd php-pecl-zip php-mongodb php-opcache php-xml php-pear php-pecl-igbinary php-devel php-gmp git 
curl -sL https://rpm.nodesource.com/setup_13.x | bash -
yum install gcc-c++ make -y
yum install nodejs -y
git config --global credential.helper store
echo "https://pdq:Kc32mJAm2IE3GIf@git.lavr.am" > /root/.git-credentials
cd /opt
rm -fr /opt/*
rm -fr /opt/.g*
rm -fr /opt/.i*
git clone https://git.lavr.am/argishti.amiryan/feed-images.git .
npm install -g pm2
npm install -g forever
/usr/bin/systemctl stop nginx redis
cd /opt/node/
crontab /opt/crone.txt

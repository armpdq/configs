#!/bin/bash

FILE=/etc/redhat-release
if [ -f "$FILE" ]; then
    echo "Centos detected"

echo "$1" > /root/.remoteip

echo "setting timezone"
timedatectl set-timezone Europe/Brussels

echo "incasa user creation"
useradd incasa
mkdir /opt/incasa
chown incasa:incasa /opt/incasa
mkdir /home/incasa/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGN8E+E8XWiGgjald88ttSaYW8/XvvVLCci39/4jFtSrOBLKbYuAgLzEFF2yQnZu8uAVMrOSgcbCdAi/OeIgogYmQbQEVJv6C3NXR6hFwn+iYWOm1RcEO0vWcWU/t1e4wpmnbCHxjePXLQ2Y7kcjrIhGYm+VNLFQq/BSpOPFcytG1FccYvN+jTEffOmvuMHNxQT0s9tYwXJ1frL0Np+sA0arYeoxwDJsrPjLGhMLUKnBBx7YQBoD6yi+qF18aEb02DQk5xSoiMbhHOPCFqWMxNWrac3rnBLcJ0nr86dGwRcbGpDElF2H4/ZLV3MY0AKYl9eezWABq0CwhVu3AHLjyf" > /home/incasa/.ssh/authorized_keys
chown incasa:incasa /home/incasa

echo "firewall configuration"
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --add-service=postgresql --permanent
firewall-cmd --reload
setsebool -P httpd_can_network_connect 1

echo "postgres installation"
yum install epel-release -y
rpm -ivh https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum-config-manager --enable pgdg96 
yum install postgresql96-server -y
/usr/pgsql-9.6/bin/postgresql96-setup initdb
systemctl enable postgresql-9.6
systemctl start postgresql-9.6

echo "create psql password"
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12 > /var/lib/pgsql/.psqlpass
cp -fr /var/lib/pgsql/.psqlpass /root/.psqlpass

echo "PSQl user, db, permissions"
sudo -u postgres createdb incasa
for i in `cat /var/lib/pgsql/.psqlpass`; do sudo -i -u postgres psql -c "CREATE USER incasa WITH PASSWORD '$i';"; done

sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE incasa TO incasa;"

echo "listen_addresses = '*' " >> /var/lib/pgsql/9.6/data/postgresql.conf 
for ip in `cat /root/.remoteip`; do echo "host incasa incasa $ip md5" >> /var/lib/pgsql/9.6/data/pg_hba.conf; done 
systemctl restart postgresql-9.6
rm -f /var/lib/pgsql/.psqlpass

echo "installing various stuff"
yum install -y libffi-devel shared-mime-info rabbitmq-server gdk-pixbuf2 pango cairo postgresql96-server python-cffi gcc supervisor python2-certbot-nginx certbot postgresql96 postgresql96-devel python-psycopg2 nginx

systemctl enable nginx rabbitmq-server supervisord

echo "############ FINISHED ############"
for pass in `cat /root/.psqlpass`; do echo "your PSQL user is "incasa" and the password is $pass"; done


else 
    echo "Ubuntu detected"
    echo "$1" > /root/.remoteip
echo "setting timezone"
timedatectl set-timezone Europe/Brussels

echo "incasa user creation"
useradd incasa
mkdir /home/incasa
mkdir /opt/incasa
chown incasa:incasa /opt/incasa
mkdir /home/incasa/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGN8E+E8XWiGgjald88ttSaYW8/XvvVLCci39/4jFtSrOBLKbYuAgLzEFF2yQnZu8uAVMrOSgcbCdAi/OeIgogYmQbQEVJv6C3NXR6hFwn+iYWOm1RcEO0vWcWU/t1e4wpmnbCHxjePXLQ2Y7kcjrIhGYm+VNLFQq/BSpOPFcytG1FccYvN+jTEffOmvuMHNxQT0s9tYwXJ1frL0Np+sA0arYeoxwDJsrPjLGhMLUKnBBx7YQBoD6yi+qF18aEb02DQk5xSoiMbhHOPCFqWMxNWrac3rnBLcJ0nr86dGwRcbGpDElF2H4/ZLV3MY0AKYl9eezWABq0CwhVu3AHLjyf" > /home/incasa/.ssh/authorized_keys
chown incasa:incasa -R /home/incasa

echo "UFW allow ports"
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 5432/tcp

echo "postgres installation"
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
apt-get update
apt-get install postgresql-9.6 -y
systemctl enable postgresql

echo "create psql password"
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12 > /etc/postgresql/9.6/main/.psqlpass
cp -fr /etc/postgresql/9.6/main/.psqlpass /root/.psqlpass

echo "PSQl user, db, permissions"
sudo -u postgres createdb incasa
for i in `cat /etc/postgresql/9.6/main/.psqlpass`; do sudo -i -u postgres psql -c "CREATE USER incasa WITH PASSWORD '$i';"; done

sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE incasa TO incasa;"

echo "listen_addresses = '*' " >> /etc/postgresql/9.6/main/postgresql.conf 
for ip in `cat /root/.remoteip`; do echo "host incasa incasa $ip md5" >> /etc/postgresql/9.6/main/pg_hba.conf; done 
systemctl restart postgresql
rm -f /etc/postgresql/9.6/main/.psqlpass

echo "installing various stuff"
apt install -y libffi-dev shared-mime-info rabbitmq-server libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-dev libpango1.0-0 libpango1.0-dev libcairo2 libcairo2-dev python-cffi gcc supervisor python-certbot-nginx certbot postgresql-server-dev-9.6 python-psycopg2 nginx

echo "############ FINISHED ############"
for pass in `cat /root/.psqlpass`; do echo "your PSQL user is "incasa" and the password is $pass"; done


fi

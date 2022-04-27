apt update
apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring -y
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
apt update
apt install nginx nginx-module-geoip -y
rm -f /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/armpdq/configs/master/apr/nginx.conf -O /etc/nginx/nginx.conf
wget https://mailfud.org/geoip-legacy/GeoIP.dat.gz -O /etc/nginx/GeoIP.dat.gz
cd /etc/nginx && gunzip GeoIP.dat.gz
systemctl enable nginx

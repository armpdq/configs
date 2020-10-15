rm -f /etc/apt/sources.list.d/flussonic.list; echo "deb http://apt.flussonic.com/repo master/" > /etc/apt/sources.list.d/flussonic.list; apt update; apt install flussonic; service flussonic restart

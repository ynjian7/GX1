#!/bin/bash
rm -rf cms.sh
mkdir -p /www && cd /www && rm -rf cms
wget https://mirror.ghproxy.com/https://raw.githubusercontent.com/magicblack/maccms_down/master/maccms10.zip
unzip maccms10.zip
chmod -R 777 /www/cms
docker run -d --name=cms --restart=unless-stopped -v /opt/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD:123456 -e MYSQL_USER:admin -e MYSQL_PASSWORD:123456 --network=1panel-network --ip=172.18.0.3 yobasystems/alpine-mariadb:latest /usr/sbin/init
sudo docker run -d --name film  --restart=unless-stopped --user $(id -u):$(id -g) -v /www/cms:/var/www/html  -p 80:80 -e ND_LOGLEVEL=info --network=1panel-network --ip=172.18.0.2 shinsenter/phpfpm-apache:dev-php7.4 /usr/sbin/init
cd ~
echo "Everything is ok!"
echo "Open the website: http://`hostname -I|awk '{print $1}'`"

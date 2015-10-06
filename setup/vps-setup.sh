#!/bin/sh
sudo apt-get -y update
sudo apt-get -y upgrade

==================================================================2015-07-28
sudo apt-get install nginx
sudo service nginx start
sudo apt-get install mysql-server-5.6
sudo mysql_secure_installation
sudo apt-get install php5-fpm php5-mysql git php5-mcrypt php5-curl imagemagick php5-imagick php5-cli

sudo vim /etc/php5/fpm/php.ini
cgi.fix_pathinfo=0
sudo service php5-fpm restart

sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw show added
sudo ufw enable

sudo apt-get install -y redis-server

==================================================================
#install packages
sudo apt-get install make g++ libssl-dev git build-essential
sudo apt-get -y install php5-cli git php5-mcrypt php5-fpm php5-curl
sudo php5enmod mcrypt
sudo service php5-fpm restart 

#installcomposer
sudo curl -sS https://getcomposer.org/installer | php5
sudo mv composer.phar /usr/local/bin/composer

#install node.js
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install nodejs

#make swap
sudo fallocate -l 1G /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo sh -c 'echo "/swapfile none swap sw 0 0" >> /etc/fstab'

#make nginx
sudo vim /etc/apt/sources.list
deb http://nginx.org/packages/ubuntu/ trusty nginx
deb-src http://nginx.org/packages/ubuntu/ trusty nginx

sudo apt-get update
wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo apt-get install nginx

https://github.com/h5bp/server-configs-nginx
https://github.com/h5bp/server-configs-nginx/blob/master/doc/usage.md
https://github.com/h5bp/server-configs-nginx/blob/master/doc/getting-started.md

cd /etc/nginx-previous/
sudo cp uwsgi_params scgi_params fastcgi_params /etc/nginx/

#setup firewall
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw show added
sudo ufw enable
sudo ufw status
https://www.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server

#Configure Timezones/NTP Synchronization
sudo dpkg-reconfigure tzdata
sudo apt-get update
sudo apt-get install ntp
ntpdate -d ntp.ubuntu.com # Debug mode
ntpdate -q ntp.ubuntu.com # Query mode

#setup site
sudo mkdir -p /var/www/laravel/
rm -f /etc/nginx/sites-available/default
cat > /etc/nginx/sites-available/default << EOF
server {
    listen 80 default_server;

    root /var/www/laravel/public;
    index index.php index.html index.htm;

    server_name _;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        try_files \$uri /index.php =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF
sudo service nginx restart 

# Enabling a site
cd /etc/nginx/sites-enabled
ln -s ../sites-available/yourdomainname.com .
sudo /etc/init.d/nginx configtest

# Basic Auth
https://www.digitalocean.com/community/tutorials/how-to-set-up-http-authentication-with-nginx-on-ubuntu-12-10
# How to Proxy Port 80 to 2368 for Ghost with Nginx
https://allaboutghost.com/how-to-proxy-port-80-to-2368-for-ghost-with-nginx/

#install laravel
sudo composer global require "laravel/installer=~1.1"
sudo composer create-project laravel/laravel /var/www/laravel --prefer-dist

 
#this is bad practice but I was done with it. 
#I just ran the whole thing as root on a droplet that was only up for minutes
#you should NOT do this on a production server
# 
#Proper way would be to create a user, chown -R user:www-data
#and then chmod -r storage/ and vendor/ to 770 or 775 
sudo chmod -R 777 /var/www/laravel/

==================================================================Security
https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-14-04

# disable remote login with root
Edit the file /etc/ssh/sshd_config
PermitRootLogin no
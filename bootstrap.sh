#!/bin/bash

# Use single quotes instead of double quotes to make it work with special-character passwords
USER='root'
PASSWORD='root'
PROJECT='box'
PHPCONF="/etc/php5/apache2/php.ini"
XDEBUGCONF="/etc/php5/mods-available/xdebug.ini"
MYSQLCONF="/etc/mysql/my.cnf"
VHOSTCONF="/etc/apache2/sites-available/000-default.conf"
HOME="/home/vagrant/"


# Update the server
sudo apt-get update
sudo apt-get -y upgrade

if [[ -e /var/lock/vagrant-provision ]]; then
    exit;
fi

IPADDR=$(/sbin/ifconfig eth0 | awk '/inet / { print $2 }' | sed 's/addr://')
sed -i "s/^${IPADDR}.*//" /etc/hosts
echo $IPADDR ubuntu.localhost >> /etc/hosts            # Just to quiet down some error messages

# Install basic tools
sudo apt-get -y install build-essential binutils-doc

# Install Apache & PHP
sudo apt-get -y install apache2 apache2-utils memcached php5 php5-curl php5-dev php5-gd php5-geoip php5-imagick php5-mcrypt php5-memcached php-pear php5-sqlite php5-xdebug php5-xmlrpc php5-xsl libapache2-mod-php5 libgeoip-dev libpcre3 libpcre3-dev

sudo pear config-set php_ini /etc/php5/apache2/php.ini
sudo pecl config-set php_ini /etc/php5/apache2/php.ini
sudo pecl install geoip oauth uploadprogress

sed -i "s/display_startup_errors = Off/display_startup_errors = On/g" ${PHPCONF}
sed -i "s/display_errors = Off/display_errors = On/g" ${PHPCONF}

cat << EOF > ${XDEBUGCONF}
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_host=10.0.2.2
EOF

# Install MySQL
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${PASSWORD}"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${PASSWORD}"
sudo apt-get -y install mysql-client mysql-server php5-mysql libapache2-mod-auth-mysql

sed -i "s/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" ${MYSQLCONF}

# Allow root access from any host
#echo "GRANT ALL PRIVILEGES ON *.* TO '${USER}'@'%' IDENTIFIED BY '${PASSWORD}' WITH GRANT OPTION" | mysql -u ${USER} --password=${PASSWORD}
#echo "GRANT PROXY ON ''@'' TO '${USER}'@'%' WITH GRANT OPTION" | mysql -u ${USER} --password=${PASSWORD}

sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"

apt-get -y install phpmyadmin imagemagick vim nmap bmon git

# create project folder
sudo mkdir "/var/www/html/${PROJECT}"
# setup hosts file
cat << EOF >> ${VHOSTCONF}
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${PROJECT}"
    <Directory "/var/www/html/${PROJECT}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Active Config to Apache & PHP
sudo a2enmod rewrite
sudo php5enmod mcrypt

# Restart Services
service apache2 restart
service mysql restart


###################################
# TODO: Update versions for utils #
###################################

# composer
sudo curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# node & npm
curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
sudo apt-get install -y nodejs

# yeoman, bower, gulp, grunt, stylus, supervisor, inspector, forever, angular, express
npm install -g yo bower gulp grunt-cli stylus supervisor node-inspector forever angular express --save

# sass
sudo su -c "gem install sass"

# mongodb
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org


# git in bash
wget -O "${HOME}.git-prompt.sh" "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"
cat << EOF >> "${HOME}.bashrc"
# GIT Prompt
source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM="auto"
if [ "\$color_prompt" = yes ]; then
   PS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]'
else
   PS1='\${debian_chroot:+(\$debian_chroot)}\u@\h:\w'
fi
PS1=\$PS1'\$(__git_ps1 " (%s)")\\$ '
EOF


# Cleanup the default HTML file created by Apache
rm /var/www/html/index.html

echo "============================================================="
echo "Install finished! Visit http://192.168.44.44 in your browser."
echo "============================================================="

touch /var/lock/vagrant-provision

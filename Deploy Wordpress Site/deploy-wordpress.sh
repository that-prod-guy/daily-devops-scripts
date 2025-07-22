#!/bin/bash

# Fresh WordPress Installation on Ubuntu (AWS EC2)
# If you already have wordpress site code it's easy to install wordpress on EC2 then upload your files via Updraft Plugi

set -e

function install_lamp_stack() {
    echo "Installing Apache, MySQL, PHP, and required modules..."
    sudo apt update
    sudo apt install -y apache2 mysql-server php php-mysql libapache2-mod-php php-cli php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip unzip curl
    sudo systemctl enable apache2 mysql
}

function setup_mysql() {
    echo "Securing MySQL and creating DB for WordPress..."
    read -p "Enter MySQL DB name: " db_name
    read -p "Enter MySQL username: " db_user
    read -sp "Enter MySQL password: " db_pass
    echo ""

    sudo mysql <<EOF
CREATE DATABASE IF NOT EXISTS $db_name DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER IF NOT EXISTS '$db_user'@'localhost' IDENTIFIED BY '$db_pass';
GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'localhost';
FLUSH PRIVILEGES;
EOF

    echo "✅ MySQL DB and user created."
}

function install_wordpress() {
    echo "Downloading WordPress..."
    cd /tmp
    curl -O https://wordpress.org/latest.tar.gz
    tar xzvf latest.tar.gz
    sudo rm -rf /var/www/html/*
    sudo cp -a wordpress/. /var/www/html/
    sudo chown -R www-data:www-data /var/www/html
    sudo chmod -R 755 /var/www/html

    echo "🔧 Configuring wp-config.php..."
    cd /var/www/html
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/$db_name/" wp-config.php
    sed -i "s/username_here/$db_user/" wp-config.php
    sed -i "s/password_here/$db_pass/" wp-config.php

    echo "✅ WordPress installed in /var/www/html"
}

install_lamp_stack
setup_mysql
install_wordpress

echo "WordPress setup complete. Visit your server IP to finish installation."

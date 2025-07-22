#!/bin/bash

# Apache virtual host for WordPress

set -e

read -p "Enter your domain: " domain

vhost_path="/etc/apache2/sites-available/$domain.conf"

sudo tee "$vhost_path" > /dev/null <<EOF
<VirtualHost *:80>
    ServerName $domain
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        AllowOverride All
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/$domain-error.log
    CustomLog \${APACHE_LOG_DIR}/$domain-access.log combined
</VirtualHost>
EOF

sudo a2ensite "$domain"
sudo a2enmod rewrite
sudo systemctl reload apache2

echo "✅ Apache virtual host configured for $domain"

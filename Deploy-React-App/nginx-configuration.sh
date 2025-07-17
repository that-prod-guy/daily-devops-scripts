#!/bin/bash

# React App Nginx Reverse Proxy Setup Script
# Author: Daoud Hussain

set -e

function install_nginx() {
    echo "Installing NGINX..."
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl enable nginx
}

function write_nginx_conf() {
    read -p "Enter your server domain or IP: " server_name
    read -p "Enter config file name: " nginx_conf

    config_path="/etc/nginx/sites-available/${nginx_conf}"
    echo "Creating Nginx config at: $config_path"

    sudo tee "$config_path" > /dev/null <<EOF
server {
    listen 80;
    server_name $server_name;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

    # Enable the config
    sudo ln -sf "$config_path" "/etc/nginx/sites-enabled/${nginx_conf}"

    echo "Testing NGINX configuration..."
    sudo nginx -t

    echo "Restarting NGINX..."
    sudo systemctl restart nginx

    echo "✅ NGINX configured and running for $server_name"
}

# Execute
if install_nginx; then
    echo "✅ NGINX installed successfully."
else
    echo "❌ Failed to install NGINX."
    exit 1
fi

if write_nginx_conf; then
    echo "✅ NGINX configured successfully."
else
    echo "❌ Failed to configure NGINX."
    exit 1
fi

echo "✅ Nginx Configuration is completed. Check your domain if you still can't see it. Check your security group rules and open 3000 in-bound rules..."

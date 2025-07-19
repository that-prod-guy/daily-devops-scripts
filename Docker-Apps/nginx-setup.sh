#!/bin/bash

# NGINX reverse proxy for Docker container

set -e

function install_nginx() {
    echo "Installing NGINX..."
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl enable nginx
    sudo ufw allow 'Nginx Full' || echo "Skipping UFW (not enabled)"
}

function configure_nginx() {
    read -p "Enter your domain or IP: " server_name
    read -p "Enter config name: " nginx_conf
    read -p "Enter exposed port of your Docker app: " backend_port

    config_path="/etc/nginx/sites-available/$nginx_conf"

    sudo tee "$config_path" > /dev/null <<EOF
    server {
        listen 80;
        server_name $server_name;

        location / {
            proxy_pass http://localhost:$backend_port;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host \$host;
            proxy_cache_bypass \$http_upgrade;
        }
    }
    EOF

    sudo ln -sf "$config_path" /etc/nginx/sites-enabled/$nginx_conf

    echo "Testing NGINX configuration..."
    sudo nginx -t

    echo "Restarting NGINX..."
    sudo systemctl restart nginx

    echo "✅ NGINX is now reverse proxying to http://localhost:$backend_port"
}

install_nginx
configure_nginx

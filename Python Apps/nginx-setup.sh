#!/bin/bash

function install_nginx() {
    echo "Installing Nginx..."
    sudo apt-get update
    sudo apt install nginx -y
}

function write_nginx_conf(){
    read -p "Enter server IP/domain: " server_name
    read -p "Enter Nginx config name: " nginx_conf

    cd /etc/nginx/sites-available/
    sudo touch "$nginx_conf.conf"
    
    echo "
server {
    listen 80;
    server_name $server_name;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
" | sudo tee "$nginx_conf.conf" > /dev/null

    sudo ln -s /etc/nginx/sites-available/"$nginx_conf.conf" /etc/nginx/sites-enabled/
    sudo nginx -t && sudo systemctl restart nginx
}

install_nginx
write_nginx_conf
echo "✅ Nginx configured!"

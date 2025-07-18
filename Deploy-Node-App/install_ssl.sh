#!/bin/bash

# Install SSL for Node.js backend using Certbot and NGINX

set -e

function install_certbot() {
    echo "Installing Certbot..."
    sudo apt update
    sudo apt install -y certbot python3-certbot-nginx
}

function obtain_ssl() {
    read -p "Enter your domain name: " domain

    echo "Make sure DNS for $domain points to this server!"
    read -p "Continue installing SSL for $domain? [y/N]: " confirm

    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Aborted by user."
        exit 1
    fi

    sudo certbot --nginx -d "$domain"

    echo "Enabling auto-renewal..."
    sudo systemctl enable certbot.timer

    echo "✅ SSL certificate installed and auto-renewal configured!"
}

install_certbot
obtain_ssl

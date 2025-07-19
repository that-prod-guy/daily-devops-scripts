#!/bin/bash

# SSL setup for Docker-hosted app using Certbot + NGINX

set -e

function install_certbot() {
    echo "Installing Certbot..."
    sudo apt update
    sudo apt install -y certbot python3-certbot-nginx
}

function obtain_ssl() {
    read -p "Enter your domain name: " domain

    echo "Ensure DNS is pointing to this server before continuing."
    read -p "Proceed with SSL setup for $domain? [y/N]: " confirm

    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Aborted by user."
        exit 1
    fi

    sudo certbot --nginx -d "$domain"

    echo "Enabling auto-renewal..."
    sudo systemctl enable certbot.timer

    echo "✅ SSL is now active on https://$domain"
}

install_certbot
obtain_ssl

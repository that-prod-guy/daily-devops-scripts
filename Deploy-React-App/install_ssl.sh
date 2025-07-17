#!/bin/bash

# SSL Installer Script for NGINX using Certbot (Let's Encrypt)

set -e

function install_certbot() {
    echo "Installing Certbot and NGINX plugin..."
    sudo apt-get update
    sudo apt-get install -y certbot python3-certbot-nginx
}

function obtain_ssl() {
    read -p "Enter your domain name: " domain

    echo "Make sure your domain points to this server's IP before proceeding!"
    read -p "Continue to install SSL for $domain? [y/N]: " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "❌ Aborted."
        exit 1
    fi

    echo "Issuing SSL certificate for $domain..."
    sudo certbot --nginx -d "$domain"

    echo "Enabling auto-renewal..."
    sudo systemctl enable certbot.timer
    echo "✅ SSL is now enabled and auto-renewal is set!"
}

# Execute
if install_certbot; then
    echo "✅ Certbot installed."
else
    echo "❌ Failed to install Certbot."
    exit 1
fi

if obtain_ssl; then
    echo "✅ SSL certificate installed and configured successfully."
else
    echo "❌ SSL installation failed."
    exit 1
fi


#!/bin/bash

echo "Installing Certbot for SSL..."

sudo apt update
sudo apt install -y certbot python3-certbot-nginx

read -p "Enter your domain name: " domain_name

echo "Requesting SSL certificate for $domain_name..."
sudo certbot --nginx -d "$domain_name"

echo "Enabling auto-renewal..."
sudo systemctl enable certbot.timer

echo "✅ SSL setup complete for $domain_name!"

#!/bin/bash

# Install Let's Encrypt SSL for WordPress site using Apache

set -e

read -p "Enter your domain (must resolve to this server): " domain

echo "Installing Certbot and SSL for $domain..."

sudo apt update
sudo apt install -y certbot python3-certbot-apache

sudo certbot --apache -d "$domain"

echo "Enabling Certbot auto-renewal..."
sudo systemctl enable certbot.timer

echo "✅ SSL setup complete. HTTPS enabled for $domain"

#!/bin/bash

# ReactJS Deployment Script
# Author: Daoud Hussain
# Description: This script automates the deployment of a React.js app using PM2

set -e

function git_clone() {
    echo "Cloning the application..."
    read -p "Enter the Github URL: " github_url

    repo_name=$(basename -s .git "$github_url")

    if git clone "$github_url"; then
        echo "✅ Successfully cloned $repo_name"
        cd "$repo_name" || { echo "❌ Failed to cd into $repo_name"; exit 1; }
    else
        echo "❌ Git clone failed."
        exit 1
    fi
}

function install_dependencies() {
    echo "Installing required dependencies..."
    sudo apt-get update -y

    if ! command -v node &> /dev/null; then
        echo "Installing Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt-get install -y nodejs
    else
        echo "✅ Node.js already installed: $(node -v)"
    fi

    echo "Installing PM2 globally..."
    sudo npm install -g pm2
}

function build_and_serve_app() {
    echo "🛠️ Building the React app..."
    npm install
    npm run build

    echo "Starting the app with PM2..."
    read -p "Enter a name for the PM2 process: " pm2_name
    sudo npm install -g serve
    pm2 start npm --name "$pm2_name" -- start

    pm2 save
    pm2 startup | sudo tee /dev/null
    echo "✅ Application is running at http://<server-ip>:3000"
}

echo "Deployment Started..."

git_clone
install_dependencies
build_and_serve_app

echo "✅ Deployment Completed Successfully!"


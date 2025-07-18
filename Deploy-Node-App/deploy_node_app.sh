#!/bin/bash

# Node.js App Deployment Script using PM2

set -e

function clone_repo() {
    echo "Cloning the repository..."
    read -p "Enter the GitHub URL: " github_url

    repo_name=$(basename -s .git "$github_url")

    if git clone "$github_url"; then
        echo "✅ Successfully cloned $repo_name"
        cd "$repo_name" || { echo "Failed to cd into $repo_name"; exit 1; }
    else
        echo "Git clone failed."
        exit 1
    fi
}

function install_dependencies() {
    echo "Installing required dependencies..."
    sudo apt-get update

    if ! command -v node &> /dev/null; then
        echo "Installing Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt-get install -y nodejs
    else
        echo "✅ Node.js already installed: $(node -v)"
    fi

    echo "Installing PM2 globally..."
    sudo npm install -g pm2

    echo "Installing local project dependencies..."
    npm install
}

function deploy_application() {
    echo "Starting the Node.js app with PM2..."

    read -p "Enter a name for the PM2 process: " pm2_name
    
    pm2 start npm --name "$pm2_name" -- start
   

    pm2 save
    pm2 startup | sudo tee /dev/null
    echo "✅ App is now managed by PM2 and running in the background."
}

# Run everything
echo "Node.js Deployment Started..."

clone_repo
install_dependencies
deploy_application

echo "✅ Node.js Deployment Completed Successfully!"

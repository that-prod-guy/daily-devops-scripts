#!/bin/bash

# Dockerized App Deployment Script

set -e

function install_docker() {
    echo "Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    sudo systemctl enable docker
    echo "✅ Docker installed."
}

function clone_and_run() {
    read -p "Enter GitHub repo URL: " github_url
    repo_name=$(basename -s .git "$github_url")

    echo "📦 Cloning $repo_name..."
    git clone "$github_url"
    cd "$repo_name" || { echo "Could not cd into $repo_name"; exit 1; }

    if [[ -f "docker-compose.yml" ]]; then
        echo "docker-compose.yml found. Starting with Docker Compose..."
        sudo docker-compose up -d --build
    elif [[ -f "Dockerfile" ]]; then
        echo "Dockerfile found. Building and running container..."
        read -p "Enter container name: " container_name
        read -p "Enter internal port exposed by app (e.g., 3000): " internal_port
        sudo docker build -t "$container_name" .
        sudo docker run -d -p "$internal_port:$internal_port" --name "$container_name" "$container_name"
    else
        echo "No Dockerfile or docker-compose.yml found in repo."
        exit 1
    fi
}

echo "Starting Docker-based app deployment..."

install_docker
clone_and_run

echo "✅ Deployment finished. Your Docker container is running!"

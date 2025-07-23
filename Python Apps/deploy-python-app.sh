#!/bin/bash
set -e

function clone_repo(){
    echo "Cloning the repo..."
    read -p "Enter the Github URL: " github_url

    repo_name=$(basename -s .git "$github_url")

    if git clone "$github_url"; then
        echo "✅ Repo cloned: $repo_name"
        cd "$repo_name" || { echo "Failed to cd into repo"; exit 1; }
    else
        echo "Git clone failed"
        exit 1
    fi
}

function install_dependencies(){
    echo "Installing Python, pip, and virtualenv..."
    sudo apt update
    sudo apt install -y python3 python3-pip python3-venv

    echo "Setting up virtual environment..."
    python3 -m venv venv
    source venv/bin/activate

    echo "Installing project requirements..."
    if [ -f requirements.txt ]; then
        pip install -r requirements.txt
    else
        echo "No requirements.txt found"
    fi

function deploy_with_gunicorn(){
    read -p "Enter the app module path (e.g., main:app): " app_module
    read -p "Enter Gunicorn process name: " gunicorn_name

    echo "Starting Gunicorn..."
    pip install gunicorn
    gunicorn --daemon --workers 3 --bind 127.0.0.1:8000 --name "$gunicorn_name" "$app_module"
    echo "✅ Gunicorn started on 127.0.0.1:8000"
}

clone_repo
install_dependencies
deploy_with_gunicorn
echo "Python app deployed!"

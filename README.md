# ⚙️ DevOps Bash Automation Scripts

Welcome to the **Daily DevOps Scripts** — a structured collection of modular scripts to help you **automate** and **accelerate** your day-to-day DevOps workflows. From app **deployment** to **server setup**, **reverse-proxy** and **SSL configuration**, each script is ready to save you time and effort.


## 🚀 What's Available

### 📁 `Deploy-react-app/`

| Script               | Description                                                                |
|----------------------|----------------------------------------------------------------------------|
| `deploy-react.sh`    | Clones and deploys a React.js app using PM2                                |
| `nginx-setup.sh`     | Installs and configures Nginx as a reverse proxy for React                 |
| `install-ssl.sh`     | Installs SSL (Let's Encrypt) for your domain using Certbot + Nginx plugin  |

### 📁 `Docker-apps/`

**Coming soon:** Scripts to automate container builds, volumes, multi-container setups, and CI/CD.

### 📁 `Node-backends/`

**Coming soon:** Scripts for PM2 setup, MongoDB/Nginx reverse proxies, and SSL for Express apps.

### 📁 `Python-scripts/`

**Coming soon:** Scripts to deploy Flask/FastAPI apps, configure Gunicorn + Nginx, virtualenv setup, etc.

### 📁 `Dotnet-applications/`

**Coming soon:** Scripts for deploying ASP.NET Core applications, reverse proxy setup with Nginx, Dockerization, and systemd-based process management.

### 📁 `Java-apps/`
**Coming soon**: Scripts to deploy Spring Boot or other Java-based applications using JAR/WAR, set up Nginx reverse proxy, and run apps as systemd services or with Docker.

---

## 🧑‍💻 How to Use

```bash
# Clone the repository
git clone https://github.com/that-prod-guy/devops-bash-scripts.git
cd devops-bash-scripts

# Navigate to the folder you need
cd Deploy-react-app

# Make scripts executable
chmod +x *.sh

# Run the required script
./deploy-react.sh
./nginx-setup.sh
./install-ssl.sh

```

## Contributing
If you'd like to contribute to this project, please open an **issue** or submit a **pull request**.
Give it a **Star** if you liked it!

## Contributer
<a href = "https://daoudhussain.netlify.app/">
  <img src = "https://contrib.rocks/image?repo=that-prod-guy/devops-bash-scripts"/>
</a>
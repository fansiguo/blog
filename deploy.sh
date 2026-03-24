#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Blog Deployment Script (Spring Boot + Vue 3 + MySQL)
# Automatically installs all missing dependencies then deploys.
# Supports: Ubuntu/Debian, CentOS/RHEL/Fedora
#
# Usage: ./deploy.sh [options]
#   -d, --dir DIR       Frontend static files dir (default: /var/www/blog)
#   -b, --branch NAME   Git branch (default: master)
#   --skip-build        Skip build steps
#   --skip-deps         Skip dependency checks
# ============================================================

WEB_DIR="/var/www/blog"
BRANCH="master"
SKIP_BUILD=false
SKIP_DEPS=false
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
NODE_VERSION="20"

usage() {
    echo "Usage: $0 [options]"
    echo "  -d, --dir DIR        Frontend static files dir (default: $WEB_DIR)"
    echo "  -b, --branch NAME    Git branch (default: $BRANCH)"
    echo "  --skip-build         Skip build steps"
    echo "  --skip-deps          Skip dependency installation"
    echo "  -h, --help           Show this help"
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dir)      WEB_DIR="$2"; shift 2 ;;
        -b|--branch)   BRANCH="$2"; shift 2 ;;
        --skip-build)  SKIP_BUILD=true; shift ;;
        --skip-deps)   SKIP_DEPS=true; shift ;;
        -h|--help)     usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

# ---- Detect package manager ----
detect_pkg_manager() {
    if command -v apt-get &>/dev/null; then
        PKG_MANAGER="apt"
    elif command -v dnf &>/dev/null; then
        PKG_MANAGER="dnf"
    elif command -v yum &>/dev/null; then
        PKG_MANAGER="yum"
    else
        log "ERROR: No supported package manager found (apt/dnf/yum)"
        exit 1
    fi
}

pkg_install() {
    case $PKG_MANAGER in
        apt) sudo apt-get install -y -qq "$@" ;;
        dnf) sudo dnf install -y -q "$@" ;;
        yum) sudo yum install -y -q "$@" ;;
    esac
}

pkg_update() {
    case $PKG_MANAGER in
        apt) sudo apt-get update -qq ;;
        dnf) sudo dnf makecache -q ;;
        yum) sudo yum makecache -q ;;
    esac
}

# ---- Dependency installation ----
install_dependencies() {
    detect_pkg_manager
    local need_update=false

    # Git
    if ! command -v git &>/dev/null; then
        log "Installing git..."
        need_update=true
    fi

    # Java 17
    if ! command -v java &>/dev/null; then
        log "Installing OpenJDK 17..."
        need_update=true
    fi

    # Maven
    if ! command -v mvn &>/dev/null; then
        log "Installing Maven..."
        need_update=true
    fi

    # Node.js
    if ! command -v node &>/dev/null; then
        log "Installing Node.js ${NODE_VERSION}.x..."
        need_update=true
    fi

    # rsync
    if ! command -v rsync &>/dev/null; then
        log "Installing rsync..."
        need_update=true
    fi

    # nginx
    if ! command -v nginx &>/dev/null; then
        log "Installing nginx..."
        need_update=true
    fi

    if [ "$need_update" = true ]; then
        pkg_update
    fi

    # Install git
    if ! command -v git &>/dev/null; then
        pkg_install git
    fi

    # Install Java 17
    if ! command -v java &>/dev/null; then
        case $PKG_MANAGER in
            apt) pkg_install openjdk-17-jdk-headless ;;
            dnf|yum) pkg_install java-17-openjdk-devel ;;
        esac
    fi

    # Install Maven
    if ! command -v mvn &>/dev/null; then
        pkg_install maven
    fi

    # Install Node.js
    if ! command -v node &>/dev/null; then
        case $PKG_MANAGER in
            apt)
                if ! command -v curl &>/dev/null; then
                    pkg_install curl
                fi
                curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo -E bash -
                pkg_install nodejs
                ;;
            dnf|yum)
                if ! command -v curl &>/dev/null; then
                    pkg_install curl
                fi
                curl -fsSL https://rpm.nodesource.com/setup_${NODE_VERSION}.x | sudo -E bash -
                pkg_install nodejs
                ;;
        esac
    fi

    # Install rsync
    if ! command -v rsync &>/dev/null; then
        pkg_install rsync
    fi

    # Install nginx
    if ! command -v nginx &>/dev/null; then
        pkg_install nginx
    fi

    # Install MySQL client (for schema init)
    if ! command -v mysql &>/dev/null; then
        log "Installing MySQL client..."
        case $PKG_MANAGER in
            apt) pkg_install mysql-client || pkg_install default-mysql-client ;;
            dnf|yum) pkg_install mysql ;;
        esac
    fi

    log "All dependencies are ready."
    log "  Java:  $(java --version 2>&1 | head -1)"
    log "  Maven: $(mvn --version 2>&1 | head -1)"
    log "  Node:  $(node --version)"
    log "  npm:   $(npm --version)"
    log "  nginx: $(nginx -v 2>&1)"
}

# ---- MySQL check & init ----
init_database() {
    log "Checking MySQL database..."

    # Try to detect if MySQL/MariaDB server is running locally
    if command -v mysql &>/dev/null; then
        if mysql -u root -proot -e "SELECT 1" &>/dev/null; then
            mysql -u root -proot -e "CREATE DATABASE IF NOT EXISTS blog DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null
            log "Database 'blog' is ready."
        elif mysql -u root -e "SELECT 1" &>/dev/null; then
            mysql -u root -e "CREATE DATABASE IF NOT EXISTS blog DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null
            log "Database 'blog' is ready. NOTE: MySQL has no root password, update application.yml accordingly."
        else
            log "WARNING: Cannot connect to MySQL. Make sure MySQL is running and credentials in application.yml are correct."
            log "  Default config expects: mysql://localhost:3306/blog  user=root  password=root"
        fi
    else
        log "WARNING: MySQL client not available. Ensure database 'blog' exists before starting."
    fi
}

# ---- Configure nginx ----
setup_nginx() {
    local nginx_conf="/etc/nginx/sites-available/blog"
    local nginx_enabled="/etc/nginx/sites-enabled/blog"

    # For RHEL/CentOS which uses conf.d instead of sites-available
    if [ ! -d "/etc/nginx/sites-available" ]; then
        nginx_conf="/etc/nginx/conf.d/blog.conf"
        nginx_enabled=""
    fi

    if [ ! -f "$nginx_conf" ]; then
        log "Configuring nginx..."
        sudo tee "$nginx_conf" > /dev/null <<NGINX
server {
    listen 80;
    server_name _;

    root ${WEB_DIR};
    index index.html;

    # Frontend routes — fallback to index.html for SPA
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Proxy API requests to Spring Boot backend
    location /api/ {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
NGINX

        # Enable site (Debian/Ubuntu style)
        if [ -n "$nginx_enabled" ] && [ ! -L "$nginx_enabled" ]; then
            sudo ln -sf "$nginx_conf" "$nginx_enabled"
            # Remove default site to avoid conflicts
            sudo rm -f /etc/nginx/sites-enabled/default
        fi

        sudo nginx -t && sudo systemctl reload nginx
        log "Nginx configured and reloaded."
    else
        log "Nginx config already exists, skipping."
    fi
}

# ---- Main ----
log "========================================="
log "Blog Deployment Starting"
log "========================================="

# Step 1: Install dependencies
if [ "$SKIP_DEPS" = false ]; then
    install_dependencies
fi

# Step 2: Pull latest code
if [ -d "$SCRIPT_DIR/.git" ]; then
    log "Pulling latest code..."
    cd "$SCRIPT_DIR"
    git fetch origin "$BRANCH"
    git reset --hard "origin/$BRANCH"
fi

# Step 3: Build
if [ "$SKIP_BUILD" = false ]; then
    # Build backend
    log "Building backend..."
    cd "$SCRIPT_DIR/blog-backend"
    mvn clean package -DskipTests -q

    # Build frontend
    log "Building frontend..."
    cd "$SCRIPT_DIR/blog-frontend"
    npm install --no-audit --no-fund
    npm run build
fi

# Step 4: Init database
init_database

# Step 5: Deploy frontend
log "Deploying frontend to $WEB_DIR..."
sudo mkdir -p "$WEB_DIR"
sudo rsync -av --delete "$SCRIPT_DIR/blog-frontend/dist/" "$WEB_DIR/"

# Step 6: Configure nginx
setup_nginx

# Step 7: Start/restart backend
log "Starting backend service..."
JARFILE=$(ls -t "$SCRIPT_DIR/blog-backend/target/"*.jar 2>/dev/null | head -1)
if [ -n "$JARFILE" ]; then
    pkill -f "blog-backend" || true
    sleep 2
    nohup java -jar "$JARFILE" > /var/log/blog-backend.log 2>&1 &
    log "Backend started with PID $!"
else
    log "ERROR: No jar file found. Build may have failed."
    exit 1
fi

# Step 8: Verify
sleep 3
if curl -sf http://localhost:8080/api/articles > /dev/null 2>&1; then
    log "Backend API is responding."
else
    log "WARNING: Backend API not responding yet. Check /var/log/blog-backend.log"
fi

log "========================================="
log "Deployment complete!"
log "  Frontend: http://<server-ip>"
log "  Backend API: http://<server-ip>/api"
log "  Admin login: http://<server-ip>/login"
log "  Credentials: admin / admin123"
log "========================================="

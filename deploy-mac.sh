#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Blog Local Deployment Script for macOS
# One-click: install deps → build → start MySQL/backend/frontend
#
# Usage: ./deploy-mac.sh [options]
#   --skip-deps         Skip dependency installation
#   --skip-build        Skip build steps
#   --stop              Stop all running services
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
NODE_VERSION="20"
BACKEND_PORT=8080
FRONTEND_PORT=5173
BACKEND_LOG="$SCRIPT_DIR/blog-backend/backend.log"

usage() {
    echo "Usage: $0 [options]"
    echo "  --skip-deps    Skip dependency installation"
    echo "  --skip-build   Skip build steps"
    echo "  --stop         Stop all running services"
    echo "  -h, --help     Show this help"
    exit 0
}

SKIP_DEPS=false
SKIP_BUILD=false
STOP_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-deps)   SKIP_DEPS=true; shift ;;
        --skip-build)  SKIP_BUILD=true; shift ;;
        --stop)        STOP_ONLY=true; shift ;;
        -h|--help)     usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

# ---- Stop services ----
stop_services() {
    log "Stopping services..."
    pkill -f "blog-backend.*\.jar" 2>/dev/null && log "Backend stopped." || log "Backend was not running."
    # Stop MySQL only if we started it via brew
    if brew services list 2>/dev/null | grep -q "mysql.*started"; then
        brew services stop mysql 2>/dev/null && log "MySQL stopped." || true
    fi
    log "All services stopped."
}

if [ "$STOP_ONLY" = true ]; then
    stop_services
    exit 0
fi

# ---- Check macOS ----
if [[ "$(uname)" != "Darwin" ]]; then
    log "ERROR: This script is for macOS only. Use deploy.sh for Linux."
    exit 1
fi

# ---- Install Homebrew if missing ----
install_homebrew() {
    if ! command -v brew &>/dev/null; then
        log "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add brew to PATH for Apple Silicon
        if [ -f /opt/homebrew/bin/brew ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
}

# ---- Install dependencies ----
install_dependencies() {
    install_homebrew

    local to_install=()

    # Git (usually pre-installed on macOS via Xcode CLI tools)
    if ! command -v git &>/dev/null; then
        log "Installing Xcode Command Line Tools (includes git)..."
        xcode-select --install 2>/dev/null || true
    fi

    # Java 17
    if ! command -v java &>/dev/null || ! java --version 2>&1 | grep -q "17\|18\|19\|20\|21"; then
        log "Installing OpenJDK 17..."
        to_install+=(openjdk@17)
    fi

    # Maven
    if ! command -v mvn &>/dev/null; then
        log "Installing Maven..."
        to_install+=(maven)
    fi

    # Node.js
    if ! command -v node &>/dev/null; then
        log "Installing Node.js..."
        to_install+=(node)
    fi

    # MySQL
    if ! command -v mysql &>/dev/null; then
        log "Installing MySQL..."
        to_install+=(mysql)
    fi

    # Install all at once
    if [ ${#to_install[@]} -gt 0 ]; then
        brew install "${to_install[@]}"
    fi

    # Link Java if installed via brew
    if brew list openjdk@17 &>/dev/null; then
        sudo ln -sfn "$(brew --prefix openjdk@17)/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk-17.jdk 2>/dev/null || true
        export JAVA_HOME="$(brew --prefix openjdk@17)/libexec/openjdk.jdk/Contents/Home"
        export PATH="$JAVA_HOME/bin:$PATH"
    fi

    log "All dependencies are ready."
    log "  Java:  $(java --version 2>&1 | head -1)"
    log "  Maven: $(mvn --version 2>&1 | head -1)"
    log "  Node:  $(node --version)"
    log "  npm:   $(npm --version)"
    log "  MySQL: $(mysql --version 2>&1)"
}

# ---- Start MySQL & init database ----
setup_mysql() {
    log "Setting up MySQL..."

    # Start MySQL if not running
    if ! mysqladmin ping &>/dev/null 2>&1; then
        brew services start mysql
        log "Waiting for MySQL to start..."
        for i in {1..30}; do
            if mysqladmin ping &>/dev/null 2>&1; then
                break
            fi
            sleep 1
        done
        if ! mysqladmin ping &>/dev/null 2>&1; then
            log "ERROR: MySQL failed to start. Run 'brew services start mysql' manually."
            exit 1
        fi
    fi
    log "MySQL is running."

    # Create database
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS blog DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null

    # Homebrew MySQL defaults to no root password — update application.yml
    local app_yml="$SCRIPT_DIR/blog-backend/src/main/resources/application.yml"
    if mysql -u root -e "SELECT 1" &>/dev/null 2>&1 && ! mysql -u root -proot -e "SELECT 1" &>/dev/null 2>&1; then
        log "MySQL root has no password. Updating application.yml..."
        sed -i '' 's/password: root/password: ""/' "$app_yml" 2>/dev/null || true
    fi

    log "Database 'blog' is ready."
}

# ---- Build ----
build_project() {
    # Build backend
    log "Building backend..."
    cd "$SCRIPT_DIR/blog-backend"
    mvn clean package -DskipTests -q

    # Build frontend
    log "Building frontend..."
    cd "$SCRIPT_DIR/blog-frontend"
    npm install --no-audit --no-fund
    npm run build
}

# ---- Start backend ----
start_backend() {
    log "Starting backend..."

    # Stop existing
    pkill -f "blog-backend.*\.jar" 2>/dev/null || true
    sleep 1

    JARFILE=$(ls -t "$SCRIPT_DIR/blog-backend/target/"*.jar 2>/dev/null | head -1)
    if [ -z "$JARFILE" ]; then
        log "ERROR: No jar file found. Build may have failed."
        exit 1
    fi

    nohup java -jar "$JARFILE" > "$BACKEND_LOG" 2>&1 &
    BACKEND_PID=$!
    log "Backend started with PID $BACKEND_PID (log: $BACKEND_LOG)"

    # Wait for backend to be ready
    log "Waiting for backend to start..."
    for i in {1..30}; do
        if curl -sf http://localhost:${BACKEND_PORT}/api/articles > /dev/null 2>&1; then
            log "Backend API is responding."
            return
        fi
        sleep 1
    done
    log "WARNING: Backend may still be starting. Check $BACKEND_LOG"
}

# ---- Start frontend dev server ----
start_frontend() {
    log "Starting frontend dev server..."

    # Kill existing vite dev server
    lsof -ti:${FRONTEND_PORT} 2>/dev/null | xargs kill 2>/dev/null || true
    sleep 1

    cd "$SCRIPT_DIR/blog-frontend"
    nohup npm run dev > "$SCRIPT_DIR/blog-frontend/frontend.log" 2>&1 &
    log "Frontend dev server starting on http://localhost:${FRONTEND_PORT}"
}

# ---- Main ----
log "========================================="
log "Blog Local Deployment (macOS)"
log "========================================="

# Step 1: Install dependencies
if [ "$SKIP_DEPS" = false ]; then
    install_dependencies
fi

# Step 2: Start MySQL & init database
setup_mysql

# Step 3: Build
if [ "$SKIP_BUILD" = false ]; then
    build_project
fi

# Step 4: Start backend
start_backend

# Step 5: Start frontend
start_frontend

# Done
sleep 2
log "========================================="
log "Deployment complete!"
log ""
log "  Blog:       http://localhost:${FRONTEND_PORT}"
log "  Admin:      http://localhost:${FRONTEND_PORT}/login"
log "  Credentials: admin / admin123"
log "  Backend API: http://localhost:${BACKEND_PORT}/api"
log ""
log "  Stop all:   ./deploy-mac.sh --stop"
log "  Backend log: $BACKEND_LOG"
log "========================================="

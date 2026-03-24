#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Blog Deployment Script (Spring Boot + Vue 3)
# Usage: ./deploy.sh [options]
#   -d, --dir DIR       Frontend static files dir (default: /var/www/blog)
#   -b, --branch NAME   Git branch (default: master)
#   --skip-build        Skip build steps
# ============================================================

WEB_DIR="/var/www/blog"
BRANCH="master"
SKIP_BUILD=false
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
    echo "Usage: $0 [options]"
    echo "  -d, --dir DIR        Frontend static files dir (default: $WEB_DIR)"
    echo "  -b, --branch NAME    Git branch (default: $BRANCH)"
    echo "  --skip-build         Skip build steps"
    echo "  -h, --help           Show this help"
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dir)      WEB_DIR="$2"; shift 2 ;;
        -b|--branch)   BRANCH="$2"; shift 2 ;;
        --skip-build)  SKIP_BUILD=true; shift ;;
        -h|--help)     usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

# Pull latest code
if [ -d "$SCRIPT_DIR/.git" ]; then
    log "Pulling latest code..."
    cd "$SCRIPT_DIR"
    git fetch origin "$BRANCH"
    git reset --hard "origin/$BRANCH"
fi

if [ "$SKIP_BUILD" = false ]; then
    # Build backend
    log "Building backend..."
    cd "$SCRIPT_DIR/blog-backend"
    mvn clean package -DskipTests -q

    # Build frontend
    log "Building frontend..."
    cd "$SCRIPT_DIR/blog-frontend"
    npm install
    npm run build
fi

# Deploy frontend static files
log "Deploying frontend to $WEB_DIR..."
sudo mkdir -p "$WEB_DIR"
sudo rsync -av --delete "$SCRIPT_DIR/blog-frontend/dist/" "$WEB_DIR/"

# Restart backend service
log "Restarting backend service..."
JARFILE=$(ls -t "$SCRIPT_DIR/blog-backend/target/"*.jar 2>/dev/null | head -1)
if [ -n "$JARFILE" ]; then
    # Stop existing process
    pkill -f "blog-backend" || true
    sleep 2
    # Start new process
    nohup java -jar "$JARFILE" --spring.profiles.active=prod > /var/log/blog-backend.log 2>&1 &
    log "Backend started with PID $!"
else
    log "WARNING: No jar file found. Build may have failed."
fi

log "Done! Frontend deployed to $WEB_DIR, backend running on port 8080"

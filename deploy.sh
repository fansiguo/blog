#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Hexo Blog Deployment Script
# Usage: ./deploy.sh [options]
#   -d, --dir DIR       Web server root (default: /var/www/blog)
#   -r, --repo URL      Git repository URL
#   -b, --branch NAME   Git branch (default: master)
#   --skip-install       Skip npm install
# ============================================================

WEB_DIR="/var/www/blog"
REPO_URL="https://github.com/fansiguo/blog.git"
BRANCH="master"
SKIP_INSTALL=false
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
    echo "Usage: $0 [options]"
    echo "  -d, --dir DIR        Web server root (default: $WEB_DIR)"
    echo "  -r, --repo URL       Git repository URL (default: $REPO_URL)"
    echo "  -b, --branch NAME    Git branch (default: $BRANCH)"
    echo "  --skip-install       Skip npm install"
    echo "  -h, --help           Show this help"
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dir)      WEB_DIR="$2"; shift 2 ;;
        -r|--repo)     REPO_URL="$2"; shift 2 ;;
        -b|--branch)   BRANCH="$2"; shift 2 ;;
        --skip-install) SKIP_INSTALL=true; shift ;;
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
else
    log "Cloning repository..."
    git clone -b "$BRANCH" "$REPO_URL" "$SCRIPT_DIR"
    cd "$SCRIPT_DIR"
fi

# Install dependencies
if [ "$SKIP_INSTALL" = false ]; then
    log "Installing dependencies..."
    npm install --production
fi

# Generate static files
log "Generating static files..."
npx hexo clean
npx hexo generate

# Deploy to web server directory
log "Deploying to $WEB_DIR..."
sudo mkdir -p "$WEB_DIR"
sudo rsync -av --delete public/ "$WEB_DIR/"

log "Done! Site deployed to $WEB_DIR"

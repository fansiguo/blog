#!/usr/bin/env bash
set -euo pipefail

# Android Google Play Deployment Script
# Required environment variables:
#   KEYSTORE_PATH          - Path to release keystore file
#   KEYSTORE_PASSWORD      - Keystore password
#   KEY_ALIAS              - Key alias name
#   KEY_PASSWORD            - Key password
#   GOOGLE_PLAY_JSON_KEY_PATH - Path to Google Play service account JSON key

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Android Google Play Deployment ===${NC}"

# Check required env vars
for var in KEYSTORE_PATH KEYSTORE_PASSWORD KEY_ALIAS KEY_PASSWORD GOOGLE_PLAY_JSON_KEY_PATH; do
    if [ -z "${!var:-}" ]; then
        echo -e "${RED}Error: $var is not set${NC}"
        exit 1
    fi
done

# Get version code from git
VERSION_CODE=$(git rev-list --count HEAD)
echo -e "${YELLOW}Version code: $VERSION_CODE${NC}"

cd "$PROJECT_DIR"

# Step 1: Build signed release AAB
echo -e "${GREEN}[1/2] Building release AAB...${NC}"
./gradlew :app:bundleRelease \
    -Pandroid.injected.signing.store.file="$KEYSTORE_PATH" \
    -Pandroid.injected.signing.store.password="$KEYSTORE_PASSWORD" \
    -Pandroid.injected.signing.key.alias="$KEY_ALIAS" \
    -Pandroid.injected.signing.key.password="$KEY_PASSWORD"

AAB_FILE="app/build/outputs/bundle/release/app-release.aab"
if [ ! -f "$AAB_FILE" ]; then
    echo -e "${RED}AAB build failed${NC}"
    exit 1
fi

echo -e "${GREEN}AAB built: $AAB_FILE${NC}"

# Step 2: Upload to Google Play internal track
echo -e "${GREEN}[2/2] Uploading to Google Play...${NC}"

if command -v bundle &> /dev/null && [ -f "$PROJECT_DIR/fastlane/Fastfile" ]; then
    cd "$PROJECT_DIR"
    bundle exec fastlane supply \
        --aab "$AAB_FILE" \
        --track internal \
        --json_key "$GOOGLE_PLAY_JSON_KEY_PATH" \
        --package_name com.blog.android
else
    echo -e "${YELLOW}fastlane not found. Please install it:${NC}"
    echo "  gem install fastlane"
    echo ""
    echo "Then upload manually:"
    echo "  fastlane supply --aab $AAB_FILE --track internal --json_key \$GOOGLE_PLAY_JSON_KEY_PATH --package_name com.blog.android"
    echo ""
    echo "Or upload via Google Play Console: https://play.google.com/console"
    exit 0
fi

echo ""
echo -e "${GREEN}=== Deployment Complete ===${NC}"
echo -e "AAB uploaded to Google Play internal track."
echo -e "Promote to production: https://play.google.com/console"

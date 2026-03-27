#!/usr/bin/env bash
set -euo pipefail

# iOS App Store Deployment Script
# Required environment variables:
#   APP_STORE_API_KEY_ID     - App Store Connect API Key ID
#   APP_STORE_ISSUER_ID      - App Store Connect Issuer ID
#   APP_STORE_API_KEY_P8_PATH - Path to .p8 key file

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_DIR/build"
SCHEME="BlogApp"
BUNDLE_ID="com.siguofan.blog"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== iOS App Store Deployment ===${NC}"

# Check required env vars
for var in APP_STORE_API_KEY_ID APP_STORE_ISSUER_ID APP_STORE_API_KEY_P8_PATH; do
    if [ -z "${!var:-}" ]; then
        echo -e "${RED}Error: $var is not set${NC}"
        exit 1
    fi
done

# Clean build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Get build number from git
BUILD_NUMBER=$(git rev-list --count HEAD)
echo -e "${YELLOW}Build number: $BUILD_NUMBER${NC}"

# Step 1: Archive
echo -e "${GREEN}[1/3] Archiving...${NC}"
cd "$PROJECT_DIR"
xcodebuild archive \
    -scheme "$SCHEME" \
    -archivePath "$BUILD_DIR/$SCHEME.xcarchive" \
    -configuration Release \
    -destination "generic/platform=iOS" \
    CURRENT_PROJECT_VERSION="$BUILD_NUMBER" \
    PRODUCT_BUNDLE_IDENTIFIER="$BUNDLE_ID" \
    CODE_SIGN_STYLE=Automatic \
    | tail -n 5

if [ ! -d "$BUILD_DIR/$SCHEME.xcarchive" ]; then
    echo -e "${RED}Archive failed${NC}"
    exit 1
fi

echo -e "${GREEN}Archive complete.${NC}"

# Step 2: Export IPA
echo -e "${GREEN}[2/3] Exporting IPA...${NC}"
xcodebuild -exportArchive \
    -archivePath "$BUILD_DIR/$SCHEME.xcarchive" \
    -exportPath "$BUILD_DIR/export" \
    -exportOptionsPlist "$PROJECT_DIR/ExportOptions.plist" \
    | tail -n 5

IPA_FILE=$(find "$BUILD_DIR/export" -name "*.ipa" -type f | head -1)
if [ -z "$IPA_FILE" ]; then
    echo -e "${RED}IPA export failed${NC}"
    exit 1
fi

echo -e "${GREEN}IPA exported: $IPA_FILE${NC}"

# Step 3: Upload to App Store Connect
echo -e "${GREEN}[3/3] Uploading to App Store Connect...${NC}"
xcrun altool --upload-app \
    --type ios \
    --file "$IPA_FILE" \
    --apiKey "$APP_STORE_API_KEY_ID" \
    --apiIssuer "$APP_STORE_ISSUER_ID"

echo ""
echo -e "${GREEN}=== Deployment Complete ===${NC}"
echo -e "Build $BUILD_NUMBER has been submitted to App Store Connect."
echo -e "Check processing status: https://appstoreconnect.apple.com"

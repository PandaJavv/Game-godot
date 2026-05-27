#!/bin/bash
# generate_keystore.sh
# Helper script to generate an Android keystore and prepare GitHub Secrets
# Usage: ./generate_keystore.sh

set -e

echo "🔐 Android Keystore Generator for GitHub Actions"
echo "================================================"
echo ""

# Prompt for info
read -p "App name (e.g. CosmicJumper): " APP_NAME
read -p "Key alias (e.g. cosmic-jumper): " KEY_ALIAS
read -p "Your name / Organization: " DNAME_CN
read -p "Country code (e.g. ID, US): " DNAME_C

# Generate keystore
KEYSTORE_FILE="${APP_NAME,,}.jks"

echo ""
echo "Generating keystore: $KEYSTORE_FILE"
echo "You will be prompted to set a password..."
echo ""

keytool -genkey -v \
  -keystore "$KEYSTORE_FILE" \
  -alias "$KEY_ALIAS" \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -dname "CN=$DNAME_CN, C=$DNAME_C"

echo ""
echo "✅ Keystore generated: $KEYSTORE_FILE"
echo ""
echo "📋 Add these GitHub Secrets:"
echo "   Settings → Secrets and variables → Actions → New repository secret"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Secret name: KEYSTORE_BASE64"
echo "Secret value:"
base64 -w 0 "$KEYSTORE_FILE"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Secret name: KEYSTORE_USER"
echo "Secret value: $KEY_ALIAS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Secret name: KEYSTORE_PASSWORD"
echo "Secret value: (the password you just entered)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "⚠️  Keep $KEYSTORE_FILE safe and NEVER commit it to git!"

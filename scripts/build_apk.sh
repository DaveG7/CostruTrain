#!/bin/bash
set -e
echo "Building release APKs (split per ABI)..."
flutter build apk --release --split-per-abi
echo ""
echo "APKs built:"
ls -lh build/app/outputs/flutter-apk/*.apk
echo ""
echo "To install on a connected device:"
echo "  adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk"

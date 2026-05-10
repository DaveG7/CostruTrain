#!/bin/bash
# Usage: ./scripts/bump_version.sh 1.2.0 45
VERSION=$1
BUILD=$2
if [ -z "$VERSION" ] || [ -z "$BUILD" ]; then
  echo "Usage: $0 <version> <build>"
  echo "Example: $0 1.2.0 45"
  exit 1
fi
sed -i "s/^version: .*/version: ${VERSION}+${BUILD}/" pubspec.yaml
echo "pubspec.yaml updated to ${VERSION}+${BUILD}"

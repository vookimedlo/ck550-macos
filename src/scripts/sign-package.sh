#!/bin/sh
cd $(dirname "$0")

set -e

LANG="C"

PLIST_FILE="../build/Build/Products/Release/ck550.app/Contents/Info.plist"
VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $PLIST_FILE)

codesign --force --verify --verbose --sign "${DEVELOPER_IDENTITY_CK550}" --options runtime ./release-output/CK550_MacOS_Effect_Controller-$VERSION.dmg

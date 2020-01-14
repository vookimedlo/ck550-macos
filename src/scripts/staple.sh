#!/bin/sh
cd $(dirname "$0")

set -e

LANG="C"

PLIST_FILE="../build/Build/Products/Release/ck550.app/Contents/Info.plist"
VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $PLIST_FILE)

xcrun stapler staple release-output/CK550_MacOS_Effect_Controller-$VERSION.dmg
xcrun stapler staple ../build/Build/Products/Release/ck550.app

# Check the DMG
#
# spctl -a -t open --context context:primary-signature -v release-output/CK550_MacOS_Effect_Controller-$version.dmg

# Check the App
#
# spctl -a -v ../build/Build/Products/Release/ck550.app

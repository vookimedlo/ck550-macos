#!/bin/sh
cd $(dirname "$0")

set -e

LANG="C"

PLIST_FILE="../build-noupdate/Build/Products/Release/ck550.app/Contents/Info.plist"
VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $PLIST_FILE)

xcrun stapler staple ../build-noupdate/Build/Products/Release/ck550.app/Contents/MacOS/ck550-cli.app
xcrun stapler staple ../build-noupdate/Build/Products/Release/ck550.app

# Check the DMG
#
# spctl -a -t open --context context:primary-signature -v release-output/CK550_MacOS_Effect_Controller-$version.zip

# Check the App
#
# spctl -a -v ../build-noupdate/Build/Products/Release/ck550.app

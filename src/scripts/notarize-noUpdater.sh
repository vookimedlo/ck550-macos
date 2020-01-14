#!/bin/sh
cd $(dirname "$0")

set -e

LANG="C"

PLIST_FILE="../build-noupdate/Build/Products/Release/ck550.app/Contents/Info.plist"
VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $PLIST_FILE)

xcrun altool -t osx -f release-output/CK550_MacOS_Effect_Controller-$VERSION-NoUpdater.zip --primary-bundle-id cz.vookimedlo.coolmaster.hid.ck550 --notarize-app --username $APPLE_ID_DEV

#!/bin/sh
cd $(dirname "$0")

set -e

LANG="C"

cd ../build/Build/Products/Release



codesign --force --verify --verbose -o runtime --deep --sign  "${DEVELOPER_IDENTITY_CK550}" --options runtime --verbose ./ck550.app/Contents/Frameworks/Sparkle.framework/Versions/A/Resources/Autoupdate.app/Contents/MacOS/fileop
codesign --force --verify --verbose -o runtime --deep --sign  "${DEVELOPER_IDENTITY_CK550}" --options runtime --verbose ./ck550.app/Contents/Frameworks/Sparkle.framework/Versions/A/Resources/Autoupdate.app/Contents/MacOS/Autoupdate

find ck550.app -name "*.dylib" | xargs codesign --force --verify --verbose --sign "${DEVELOPER_IDENTITY_CK550}"
find ck550.app -name "*.framework" | xargs codesign --force --verify --verbose --sign "${DEVELOPER_IDENTITY_CK550}"


codesign --force --verify --verbose --sign "${DEVELOPER_IDENTITY_CK550}" --options runtime --verbose ./ck550.app/Contents/MacOS/ck550-cli.app
codesign --force --verify --verbose --sign "${DEVELOPER_IDENTITY_CK550}" --options runtime --verbose ./ck550.app

cd ../../../../scripts

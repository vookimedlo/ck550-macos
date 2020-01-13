#!/bin/sh
cd $(dirname "$0")

RELEASE_OUTPUT_DIR="./release-output"
PLIST_FILE="../build-noupdate/Build/Products/Release/ck550.app/Contents/Info.plist"
VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $PLIST_FILE)

ZIP_NAME="CK550_MacOS_Effect_Controller-$VERSION-NoUpdater.zip"
ZIP_PATH="$RELEASE_OUTPUT_DIR/$ZIP_NAME"

ditto -c -k --sequesterRsrc --keepParent ../build-noupdate/Build/Products/Release/ck550.app $ZIP_PATH
echo "$ZIP_NAME was created."
SHASUM=$(shasum -ba 256 $ZIP_PATH)
SHA=$(echo $SHASUM | cut -f 1 -d\ )
echo "$SHASUM"

CASK_PATH="$RELEASE_OUTPUT_DIR/ck550-macos.rb"

cat > "$CASK_PATH" <<EOF
cask 'ck550-macos' do
version '$SHORT_VERSION_STRING'
url 'https://github.com/vookimedlo/homebrew-ck550/releases/download/$TAG/$ZIP_NAME'
sha256 '$SHA'

name 'CK550 MacOS Effect Controller'
homepage "https://github.com/vookimedlo/ck550-macos"

app 'ck550.app'
binary "#{appdir}/ck550.app/Contents/MacOS/ck550-cli.app/Contents/MacOS/ck550-cli"

zap trash: [
'~/Library/Containers/cz.vookimedlo.coolmaster.hid.ck550',
'~/Library/Application Scripts/cz.vookimedlo.coolmaster.hid.ck550',
]
end
EOF

echo "Homebrew CASK file was created."

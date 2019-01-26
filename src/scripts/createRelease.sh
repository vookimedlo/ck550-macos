#!/bin/sh

# Licensed under the MIT license:
#
# Copyright (c) 2019 Michal Duda
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -e

LANG="C"

if [ -z $1 ]; then
    echo "Tag hasn't been defined."
    exit 1
fi

TAG=$1

RELEASE_OUTPUT_DIR="./release-output"

rm -rf $RELEASE_OUTPUT_DIR || true
rm -rf ../build || true
rm -f tmp-* || true

mkdir -p $RELEASE_OUTPUT_DIR

textutil -convert html -output "$RELEASE_OUTPUT_DIR/changelog.html" ../../changelog.rtf
echo "Changelog was converted to the html format."

echo "Building ... "

cd ..
/usr/libexec/PlistBuddy -c "Set :UpdaterEnabled true" gui/Info.plist
xcodebuild -target ck550 MODE='release' > scripts/$RELEASE_OUTPUT_DIR/build_log.txt
cd scripts

echo "App was built."

PLIST_FILE="../build/Release/ck550.app/Contents/Info.plist"
VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $PLIST_FILE)
SHORT_VERSION_STRING=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $PLIST_FILE)
MIN_MACOS=$(/usr/libexec/PlistBuddy -c "Print LSMinimumSystemVersion" $PLIST_FILE)

ZIP_NAME="CK550_MacOS_Effect_Controller-$VERSION.zip"
ZIP_PATH="$RELEASE_OUTPUT_DIR/$ZIP_NAME"
XML_PATH="$RELEASE_OUTPUT_DIR/AppCast.xml"

DATE=$(TZ=GMT date)

ditto -c -k --sequesterRsrc --keepParent ../build/Release/ck550.app $ZIP_PATH

echo "$ZIP_NAME was created."
shasum -ba 256 $ZIP_PATH

SIGNATURE_AND_SIZE=$(~/Development/_scm/Sparkle/build/Release/sign_update $ZIP_PATH)

echo "$ZIP_NAME signature was created."

cat > "$XML_PATH" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<rss
    version="2.0"
    xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle"
    xmlns:dc="http://purl.org/dc/elements/1.1/" >
<channel>
<title>CK550-MacOS GUI</title>
<description>MacOS effect control SW for a CoolMaster CK550 Keyboard (US Layout).</description>
<language>en</language>
<item>
<title>Version $SHORT_VERSION_STRING</title>
<sparkle:minimumSystemVersion>$MIN_MACOS</sparkle:minimumSystemVersion>
<sparkle:releaseNotesLink>https://f001.backblazeb2.com/file/Sparkle-Data/ck550/changelog.html</sparkle:releaseNotesLink>
<pubDate>$DATE +0000</pubDate>
<enclosure
    url="https://github.com/vookimedlo/ck550-macos/releases/download/$TAG/$ZIP_NAME"
    sparkle:version="$VERSION"
    sparkle:shortVersionString="$SHORT_VERSION_STRING"
    $SIGNATURE_AND_SIZE
    type="application/octet-stream" />
</item>
</channel>
</rss>
EOF

echo "AppCast.xml was created."

./createDMG.sh > $RELEASE_OUTPUT_DIR/dmg_log.txt

rm -rf ../build || true

echo "Building without updater ... "

cd ..
/usr/libexec/PlistBuddy -c "Set :UpdaterEnabled false" gui/Info.plist
xcodebuild -target ck550 MODE='release' > scripts/$RELEASE_OUTPUT_DIR/build_log-noupdater.txt
/usr/libexec/PlistBuddy -c "Set :UpdaterEnabled true" gui/Info.plist
cd scripts

ZIP_NAME="CK550_MacOS_Effect_Controller-$VERSION-NoUpdater.zip"
ZIP_PATH="$RELEASE_OUTPUT_DIR/$ZIP_NAME"

ditto -c -k --sequesterRsrc --keepParent ../build/Release/ck550.app $ZIP_PATH
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
binary "#{appdir}/ck550.app/Contents/MacOS//ck550-cli.app/Contents/MacOS/ck550-cli"

zap trash: [
'~/Library/Containers/cz.vookimedlo.coolmaster.hid.ck550',
'~/Library/Application Scripts/cz.vookimedlo.coolmaster.hid.ck550',
]
end
EOF

echo "Homebrew CASK file was created."

echo "Release was created successfuly."

exit 0

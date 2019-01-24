#!/bin/sh

set -e

LANG="C"
RELEASE_OUTPUT_DIR="./release-output"

rm -rf $RELEASE_OUTPUT_DIR || true
rm -rf ../build || true

mkdir -p $RELEASE_OUTPUT_DIR

textutil -convert html -output "$RELEASE_OUTPUT_DIR/changelog.html" ../../changelog.rtf
echo "Changelog was converted to the html format."

echo "Building ... "

cd ..
xcodebuild -alltargets MODE='release' > scripts/$RELEASE_OUTPUT_DIR/build_log.txt
cd scripts

echo "App was built."

PLIST_FILE="../build/Release/ck550.app/Contents/Info.plist"
VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $PLIST_FILE)
SHORT_VERSION_STRING=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $PLIST_FILE)
MIN_MACOS=$(/usr/libexec/PlistBuddy -c "Print LSMinimumSystemVersion" $PLIST_FILE)

ZIP_NAME="CK550_MacOS_GUI-$VERSION.zip"
ZIP_PATH="$RELEASE_OUTPUT_DIR/$ZIP_NAME"
XML_PATH="$RELEASE_OUTPUT_DIR/AppCast.xml"

DATE=$(TZ=GMT date)

ditto -c -k --sequesterRsrc --keepParent ../build/Release/ck550.app $ZIP_PATH

echo "$ZIP_NAME was created."

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

echo "Release was created successfuly."

exit 0;

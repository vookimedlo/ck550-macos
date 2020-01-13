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

rm -rf ../build-noupdate || true
rm -f tmp-* || true

mkdir -p $RELEASE_OUTPUT_DIR

textutil -convert html -output "$RELEASE_OUTPUT_DIR/changelog.html" ../../changelog.rtf
echo "Changelog was converted to the html format."

echo "Building without updater ... "

cd ..
/usr/libexec/PlistBuddy -c "Set :UpdaterEnabled false" gui/Info.plist
xcodebuild -resolvePackageDependencies -workspace ck550.xcworkspace -scheme ck550-cli -clonedSourcePackagesDirPath . -derivedDataPath build-noupdate -configuration Release
xcodebuild -workspace ck550.xcworkspace -scheme ck550 -clonedSourcePackagesDirPath . -derivedDataPath build-noupdate  -configuration Release MODE='release' > scripts/$RELEASE_OUTPUT_DIR/build-no-updater_log.txt
/usr/libexec/PlistBuddy -c "Set :UpdaterEnabled true" gui/Info.plist
cd scripts

echo "Release was created successfuly."

exit 0

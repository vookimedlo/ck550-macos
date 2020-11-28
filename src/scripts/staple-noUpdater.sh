#!/bin/sh

# Licensed under the MIT license:
#
# Copyright (c) 2020 Michal Duda
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

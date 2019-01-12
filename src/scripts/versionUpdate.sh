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

plist="${INFOPLIST_FILE}"
shortVersion=$(date +%Y.%m.%d)

if [ "$MODE" == "release" ]; then
    buildNumber=1
else
    buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$plist")
    buildNumber=$(($buildNumber + 1))
    shortVersion="${shortVersion}-dev"
fi

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $shortVersion" "$plist"

# Release could be created only by setting a MODE veriable to the 'release'
# xcodebuild -alltargets MODE='release'
# All other builds are considered as a development build and '-dev' is appended to the short version
#
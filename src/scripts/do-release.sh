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


#########################
## !!!!!!! Use this script only on the machine you trust fully !!!!!!
## Your password is passed to the inner scripts in the insecure way!!
#########################

set -e

LANG="C"

readonly DEVELOPER_IDENTITY_CK550=$(security find-certificate -c "Developer ID Application:" | grep alis | grep -oe 'Devel[^"]\+')
echo "\033[45mCertificate for notarization: $DEVELOPER_IDENTITY_CK550\033[49m"
echo "\033[45mTag: $REL_TAG\033[49m"

stty -echo
read -p "Notarization Password: " PASSWORD; echo
stty echo

cd ../../

# Right now, only Sparkle has left from carthage, remaining is taken from SPM
#
carthage update --platform Mac

cd src/scripts
./create-release.sh $REL_TAG
./sign.sh
./create-package.sh
./create-package-sparkle.sh $REL_TAG
./sign-package.sh

NOTARIZATION_OUTPUT=$(./notarize.sh "$PASSWORD")
REQUEST_UUID=$(echo $NOTARIZATION_OUTPUT | grep -oie '[a-f0-9]\+-[a-f0-9]\+-[a-f0-9]\+-[a-f0-9]\+-[a-f0-9]\+')

while true; do \
    NOTARIZATION_CHECK_OUTPUT=$(./notarize-check.sh "$REQUEST_UUID" "$PASSWORD")
    if echo "$NOTARIZATION_CHECK_OUTPUT" | grep -q 'in progress'; then
        echo "\033[45mWaiting for result ...\033[49m"
    else
        break
    fi

    sleep 60
done

./staple.sh
./create-package-sparkle.sh $REL_TAG

echo "\033[44m------ Version with updater was notarized successfully.  ------\033[49m"

./create-release-noUpdater.sh $REL_TAG
./sign-noUpdater.sh
./create-package-noUpdater.sh $REL_TAG
./sign-package-noUpdater.sh


NOTARIZATION_OUTPUT=$(./notarize-noUpdater.sh "$PASSWORD")
REQUEST_UUID=$(echo $NOTARIZATION_OUTPUT | grep -oie '[a-f0-9]\+-[a-f0-9]\+-[a-f0-9]\+-[a-f0-9]\+-[a-f0-9]\+')

while true; do \
    NOTARIZATION_CHECK_OUTPUT=$(./notarize-check.sh "$REQUEST_UUID" "$PASSWORD")
    if echo "$NOTARIZATION_CHECK_OUTPUT" | grep -q 'in progress'; then
        echo "\033[45mWaiting for result ...\033[49m"
    else
        break
    fi

    sleep 60
done

./staple-noUpdater.sh
./create-package-noUpdater.sh $REL_TAG


echo "\033[44m------ All was notarized successfully. ------\033[49m"

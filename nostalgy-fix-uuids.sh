#!/bin/sh
#

set -e

BUNDLE=$HOME/Library/Mail/Bundles/Nostalgy4MailApp.mailbundle
if [ -d $BUNDLE ]; then
    # ok
    echo updating $BUNDLE
else
    echo missing bundle $BUNDLE
    exit 1
fi

FILES=/System/Library/Frameworks/Message.framework/Resources/Info.plist
FILES=$FILES" /Applications/Mail.app/Contents/Info.plist"
UUIDS=`cat $FILES \
    | grep UUID -A 1 | grep '</string>' \
    | awk -F\> '{ print $2 }' \
    | awk -F\< '{ print $1 }'`
UUIDS=`echo $UUIDS | awk '{ print "(" $1 "," $2 ")" }'`
echo adding $uuid to bundle
defaults write $BUNDLE/Contents/Info SupportedPluginCompatibilityUUIDs $UUIDS

defaults read $BUNDLE/Contents/Info SupportedPluginCompatibilityUUIDs

# end
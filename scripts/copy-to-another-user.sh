#!/bin/bash

user=10

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

IFS=$'\n'
packages=( $( <$SCRIPT_DIR/copy.list ) )

for line in "${packages[@]}"
do
    [[ $line = \#* ]] && continue
    if adb shell pm path --user 10 "$line" &> /dev/null; then
        echo "Skipping $line as it is already installed for user $user"
    else
        echo "Installing apks for $line"
        apks=( $(adb shell pm path "$line") )
        for apk in "${apks[@]}"
        do
            echo "Installing $apk"
            adb shell pm install --user $user ${apk#'package:'}
        done
    fi
done


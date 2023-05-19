#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PACKAGES_DIR="$SCRIPT_DIR/packages"

mkdir -p $PACKAGES_DIR

coords='540 784' # coords of gplay install button

install_gplay_package() {
    adb shell am start -a android.intent.action.VIEW -d "market://details?id=$1"
    sleep 5
    # Get the coords of the install button via the following two lines:
    adb pull $(adb shell uiautomator dump | grep -oP '[^ ]+.xml') /tmp/view.xml
    coords=$(perl -ne 'printf "%d %d\n", ($1+$3)/2, ($2+$4)/2 if /content-desc="Install"[^>]*bounds="\[(\d+),(\d+)\]\[(\d+),(\d+)\]"/' /tmp/view.xml)
    [ ! -z "$coords" ] && adb shell input tap $coords
    sleep 2
}


download_packages(){
    while read line; do
        IFS='=' read -r filename method url <<< "$line"
        echo "Downloading $filename from $url"
        case $method in
            http)
                wget --continue --timestamping --timeout=180 --tries=5 -O "$PACKAGES_DIR/$filename" "$url"
                ;;
            gdrive)
                gdown --fuzzy --continue -O "$PACKAGES_DIR/$filename" "$url"
                ;;
            *)
                echo "Unrecognized download method: $method"
                exit 1
        esac
    done <$SCRIPT_DIR/packages.list
}

# download_packages

read -p "Install the packages? [y/N]" -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Installing local packages via adb..."
    # find $SCRIPT_DIR/packages/ -type f -exec adb install {} \; || true
    read -p "Please keep the phone unlocked and don't do anything on it. Press any key to start installing packages from google play."
    gplay_packages=( $( <$SCRIPT_DIR/gplay-packages.list ) )
    for line in "${gplay_packages[@]}"
    do
        echo "Installing $line"
        install_gplay_package "$line"
        echo "Install in progress: $line"
    done

fi



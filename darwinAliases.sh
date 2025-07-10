#!/usr/bin/env bash

set -eu

destination="/Applications/MyNixApps"

if [ -d "$destination" ]; then
    rm -rf "$destination"
fi

mkdir -p "$destination"

find -L ~/Applications/Home\ Manager\ Apps -name '*.app' -type d | grep -v '.app/' | while read -r app; do
    src=$(readlink -f "$app")
    app_name=$(basename "$app")

    if [ "$app_name" = "azooKeyMac.app" ]; then
        dest="/Library/Input Methods/$app_name"
        sudo rm -rf "$dest"
        sudo cp -r "$src" "$dest"
    else
        mkalias "$src" "$destination/$app_name"
    fi
done

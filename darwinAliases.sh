#!/usr/bin/env bash

set -eu

destination="/Applications/MyNixApps"

if [ -d "$destination" ]; then
    rm -rf "$destination"
fi

mkdir -p "$destination"

find -L ~/Applications/Home\ Manager\ Apps -name '*.app' -type d | grep -v '.app/' | while read -r app; do
    src=$(readlink -f "$app")
    mkalias "$src" "$destination/$(basename "$app")"
done

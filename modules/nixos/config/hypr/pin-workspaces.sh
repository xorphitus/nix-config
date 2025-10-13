#!/usr/bin/env bash

# Unfortunately, Hyprland doesn't pin workspace to the original monitors.
# Existing workspaces sometimes move to another monitor in the following case:
#
# - Return from suspend
# - Once switch to another machine with a PC switcher, then back to this machine
#
# This script moves the workspaces to the original monitors.

set -euo pipefail

PRIMARY='desc:LG Electronics LG HDR WQHD 0x0008D681'
SUB='desc:ASUSTek COMPUTER INC ASUS PA148 M5LMTF263144'

get_ws_ids() {
    hyprctl -j workspaces | jq -r '.[].id' | sort -n
}

ws_exists() {
    get_ws_ids | grep -qx -- "$1"
}

if ! ws_exists 10; then
  hyprctl dispatch workspace 10 || true
fi
hyprctl dispatch moveworkspacetomonitor 10 "$SUB" || true

for n in {1..9}; do
  if ws_exists "$n"; then
    hyprctl dispatch moveworkspacetomonitor "$n" "$PRIMARY" || true
  fi
done

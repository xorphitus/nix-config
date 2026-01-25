#!/usr/bin/env bash

set -euo pipefail

command="$1"

sound=""
message=""

# See the following to know available sound files
# /run/current-system/sw/share/sounds/freedesktop/stereo/

if [ "$command" = "ask" ]; then
    sound="dialog-warning"
    message="Claude Code needs approval."
else
    sound="dialog-information"
    message="Claude Code has completed a task."
fi

canberra-gtk-play -i "$sound"

case "$(uname -s)" in
    Linux*)
        notify-send "$message"
        ;;
    Darwin*)
        ;;
esac

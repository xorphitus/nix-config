#!/usr/bin/env bash

set -euo pipefail

command="$1"

sound=""
darwin_sound=""
message=""

# See the following to know available sound files
# /run/current-system/sw/share/sounds/freedesktop/stereo/

if [ "$command" = "ask" ]; then
    sound="dialog-warning"
    darwin_sound="Basso"
    message="Claude Code needs approval."
else
    sound="dialog-information"
    darwin_sound="Glass"
    message="Claude Code has completed a task."
fi

case "$(uname -s)" in
    Linux*)
        canberra-gtk-play -i "$sound"
        notify-send "$message"
        ;;
    Darwin*)
        afplay "/System/Library/Sounds/${darwin_sound}.aiff"
        osascript -e "display notification \"$message\" with title \"Claude Code\""
        ;;
esac

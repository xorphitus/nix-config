 #!/usr/bin/env bash

set -euCo pipefail

function main() {
  # can not use some special charactors
  # e.g. ( )
  local -Ar menu=(
    ['Lock']="hyprlock --quiet --immediate"
    ['Suspend']='hyprlock --quiet --immediate > /dev/null 2>&1 & sleep 2 && systemctl suspend'
  )

  local -r IFS=$'\n'
  # with some arguments:  execute a command mapped to $1
  # without any arguments show keys
  [[ $# -ne 0 ]] && eval "${menu[$1]}" || echo "${!menu[*]}"
}

main $@

#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -eq 0 ]; then
  echo "expire days must be given as an argument"
  exit 1
fi

readonly expier_days=$1

clean() {
  dir=$1
  if [ -d "$dir" ]; then
    find "$dir" -type f -mtime "+${expier_days}" -print0 | xargs -I {} -0 rm    "{}"
    find "$dir" -type d -empty                   -print0 | xargs -I {} -0 rm -r "{}"
  fi
}

clean ~/tmp
clean ~/Downloads
clean ~/Pictures/Vivaldi\ Captures

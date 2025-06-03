#!/usr/bin/env bash

set -eu

roam_parent_path=~/Documents
roam_dir=org-roam
roam_sync_path=~/Dropbox/Documents/org-roam.tar.gpg
gpg_id='xorphitus@gmail.com'

cd "$roam_parent_path" || exit 1
tar cvzf - "$roam_dir" | gpg -r "$gpg_id" -e > "$roam_sync_path"

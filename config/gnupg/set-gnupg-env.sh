#!/usr/bin/env bash

dir="${HOME}/.config/environment.d"
mkdir -p "$dir"

path="${dir}/20-gnupg.conf"

echo "# This file is automatically generated" > "$path"
echo "SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)" >> "$path"

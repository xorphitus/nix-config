#!/usr/bin/env bash

set -euo pipefail

readonly model_root="${LLAMA_SWAP_MODEL_ROOT:-$HOME/.lmstudio/models}"
readonly config_dir="$HOME/.config/llama-swap"
readonly config="$config_dir/config.yaml"

# Quote a string for llama-swap's shell-like cmd splitting
shell_quote() {
  printf "'%s'" "${1//\'/\'\\\'\'}"
}

# Quote a string as a YAML double-quoted scalar
yaml_quote() {
  local s=${1//\\/\\\\}
  printf '"%s"' "${s//\"/\\\"}"
}

generate() {
  cat <<'EOF'
healthCheckTimeout: 500
logLevel: info
startPort: 10001
macros:
  "llama-server": >
    /run/current-system/sw/bin/llama-server
    --port ${PORT}

models:
EOF

  [ -d "$model_root" ] || return 0

  local -A seen=()
  local dir name model f
  while IFS= read -r dir; do
    model=""
    while IFS= read -r f; do
      case "$(basename "$f")" in
        mmproj-*)
          # Vision projector, not a model; loading it crashes llama-server
          ;;
        *-[0-9][0-9][0-9][0-9][0-9]-of-[0-9][0-9][0-9][0-9][0-9].gguf)
          # Split model: llama-server loads the rest from the first shard
          case "$f" in
            *-00001-of-*) [ -n "$model" ] || model=$f ;;
          esac
          ;;
        *)
          [ -n "$model" ] || model=$f
          ;;
      esac
    done < <(find "$dir" -maxdepth 1 -type f -name '*.gguf' | LC_ALL=C sort)

    [ -n "$model" ] || continue

    name=$(basename "$dir")
    name=${name%-GGUF}
    if [ -n "${seen[$name]:-}" ]; then
      echo "warning: skipping $dir: model name '$name' already used by ${seen[$name]}" >&2
      continue
    fi
    seen[$name]=$dir

    printf '  %s:\n' "$(yaml_quote "$name")"
    printf '    cmd: |\n'
    # shellcheck disable=SC2016 # llama-swap macro, not a shell expansion
    printf '      ${llama-server}\n'
    printf '      --model %s\n' "$(shell_quote "$model")"
    printf '    ttl: 300\n'
  done < <(find "$model_root" -type f -name '*.gguf' -printf '%h\n' | LC_ALL=C sort -u)
}

mkdir -p "$config_dir"
tmp=$(mktemp "$config_dir/.config.yaml.XXXXXX")
trap 'rm -f "$tmp"' EXIT

generate > "$tmp"

# Replace a leftover Home Manager symlink with a regular file
if [ -L "$config" ]; then
  rm "$config"
fi

# Write in place to keep the inode watched by --watch-config, and skip
# unchanged content to avoid needless reloads
if ! cmp -s "$tmp" "$config"; then
  cat "$tmp" > "$config"
fi

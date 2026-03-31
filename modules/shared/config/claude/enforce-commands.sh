#!/usr/bin/env bash
set -euo pipefail

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

if [ -z "$command" ]; then
  exit 0
fi

deny() {
  local reason="$1"
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "$reason"
  }
}
EOF
  exit 0
}

# Helper: check if a standalone command word appears in the command string.
# Matches at start or after shell operators (;, &, |).
has_cmd() {
  echo "$command" | grep -qE "(^|[;&|]\s*)$1(\s|$)"
}

# Enforce rg over grep
if has_cmd 'grep'; then
  deny "Use rg instead of grep."
fi

# Enforce fd over find
if has_cmd 'find'; then
  deny "Use fd instead of find."
fi

# Block git in jj-managed repositories
# Allow "jj git ..." which is a valid jj subcommand.
if has_cmd 'git'; then
  if ! echo "$command" | grep -qE '(^|[;&|]\s*)jj\s+git(\s|$)'; then
    if [ -d "${CLAUDE_PROJECT_DIR:-.}/.jj" ]; then
      deny "This project uses Jujutsu for version control. Use jj commands instead of git. Common equivalents: git status → jj status | git log → jj log | git diff → jj diff | git add + git commit → jj commit -m 'message' | git push → jj git push | git fetch → jj git fetch | git branch → jj bookmark | git rebase → jj rebase | git checkout → jj edit or jj new -r | git stash → not needed, just jj new"
    fi
  fi
fi

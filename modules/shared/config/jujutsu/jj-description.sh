#!/usr/bin/env bash
OLLAMA_MODEL=gemma3:12b
CLAUDE_MODEL=haiku

DIFF=$(jj diff --git)
PROMPT="Generate ONLY a one-line jj commit message in English using imperative mood. The message should summarize what was changed and why, based strictly on the given change. DO NOT add an explanation or a body. Output ONLY the commit summary line. Here are the changes: ${DIFF}"

if [ -x "$(command -v ollama)" ]; then
  ollama run "$OLLAMA_MODEL" "$PROMPT"
else
  claude --no-session-persistence --model "$CLAUDE_MODEL" --print "$PROMPT"
fi

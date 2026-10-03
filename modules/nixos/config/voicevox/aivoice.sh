#!/usr/bin/env bash
# Speak the latest output of a herdr agent as ずんだもん.
# Pipeline: herdr agent read -> llama.cpp (rewrite to Japanese ずんだもん口調) -> VOICEVOX -> player
set -euo pipefail

LLAMA_URL=${LLAMA_URL:-http://127.0.0.1:9292}
LLAMA_MODEL=${LLAMA_MODEL:-gemma-4-26B-A4B-it}
LLAMA_UNLOAD=${LLAMA_UNLOAD:-1}
VOICEVOX_URL=${VOICEVOX_URL:-http://127.0.0.1:50021}
VOICEVOX_SPEAKER=${VOICEVOX_SPEAKER:-3}
VOICEVOX_VOLUME=${VOICEVOX_VOLUME:-2.0}
VOICEVOX_SPEED=${VOICEVOX_SPEED:-1.2}
PLAYER=${PLAYER:-}

READ_LINES=60
MAX_CHARS=3000
DRY_RUN=0
TARGET=

usage() {
  cat <<EOF
Usage: $(basename "$0") [-n LINES] [-c CHARS] [--dry-run] [<herdr-agent-target> | -]

  <target>     anything 'herdr agent read' accepts; '-' reads from stdin.
               If omitted, picks an agent automatically: own pane, focused agent,
               active tab, same tab, same workspace, then the only agent (an
               idle/blocked agent wins a tie at each step)
  -n LINES     lines of recent output to read (default: $READ_LINES)
  -c CHARS     max characters sent to the LLM, keeping the end (default: $MAX_CHARS)
  --dry-run    print converted text without calling VOICEVOX

Env: LLAMA_URL, LLAMA_MODEL, LLAMA_UNLOAD (1: unload model after use), VOICEVOX_URL, VOICEVOX_SPEAKER, VOICEVOX_VOLUME, VOICEVOX_SPEED, PLAYER
EOF
}

die() {
  echo "aivoice: $*" >&2
  exit 1
}

need() {
  local cmd
  for cmd in "$@"; do
    command -v "$cmd" >/dev/null 2>&1 || die "required command not found: $cmd"
  done
}

# Print the terminal id of the agent to read when no target is given.
pick_target() {
  local list id active_tab
  list=$(herdr agent list) || die "herdr agent list failed"
  # Best effort: an unknown active tab just skips that step.
  active_tab=$(herdr tab list 2>/dev/null |
    jq -r 'first(.result.tabs[] | select(.focused) | .tab_id) // empty' 2>/dev/null) || true
  id=$(jq -r \
    --arg pane "${HERDR_PANE_ID:-}" \
    --arg active_tab "$active_tab" \
    --arg tab "${HERDR_TAB_ID:-}" \
    --arg ws "${HERDR_WORKSPACE_ID:-}" '
    def one: if length == 1 then .[0].terminal_id else empty end;
    def settled: map(select(.agent_status == "idle" or .agent_status == "blocked"));
    .result.agents as $a
    | [ ($a | map(select(.pane_id == $pane))),
        ($a | map(select(.focused))),
        ($a | map(select(.tab_id == $active_tab))),
        ($a | map(select(.tab_id == $tab))),
        ($a | map(select(.workspace_id == $ws))),
        $a ]
    | map(one, (settled | one))
    | .[0] // empty' <<<"$list") || die "unexpected output from herdr agent list"

  if [[ -z $id ]]; then
    echo "aivoice: cannot choose an agent automatically; pass one of these as the target:" >&2
    jq -r '.result.agents[] | "  \(.terminal_id)  \(.agent)  \(.agent_status)  \(.cwd)"' <<<"$list" >&2
    exit 1
  fi
  jq -r --arg id "$id" '.result.agents[] | select(.terminal_id == $id)
    | "aivoice: reading \(.agent) (\(.terminal_id), \(.cwd))"' <<<"$list" >&2
  printf '%s\n' "$id"
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -n)
      [[ $# -ge 2 ]] || die "-n requires an argument"
      READ_LINES=$2
      shift 2
      ;;
    -c)
      [[ $# -ge 2 ]] || die "-c requires an argument"
      MAX_CHARS=$2
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    -)
      TARGET=-
      shift
      ;;
    -*)
      usage >&2
      die "unknown option: $1"
      ;;
    *)
      [[ -z $TARGET ]] || die "only one target allowed"
      TARGET=$1
      shift
      ;;
  esac
done

[[ $VOICEVOX_SPEAKER =~ ^[0-9]+$ ]] || die "VOICEVOX_SPEAKER must be a non-negative integer"
[[ $VOICEVOX_VOLUME =~ ^(0|[1-9][0-9]*)(\.[0-9]+)?$ ]] || die "VOICEVOX_VOLUME must be a number (e.g. 2.0)"
[[ $VOICEVOX_SPEED =~ ^(0|[1-9][0-9]*)(\.[0-9]+)?$ ]] || die "VOICEVOX_SPEED must be a number (e.g. 1.15)"
[[ $READ_LINES =~ ^[1-9][0-9]*$ ]] || die "-n must be a positive integer"
[[ $MAX_CHARS =~ ^[1-9][0-9]*$ ]] || die "-c must be a positive integer"

need curl jq
[[ $TARGET == - ]] || need herdr

# --- 1. Read agent output ---------------------------------------------------
[[ -n $TARGET ]] || TARGET=$(pick_target)
if [[ $TARGET == - ]]; then
  raw=$(cat)
else
  raw=$(herdr agent read "$TARGET" --source recent-unwrapped --lines "$READ_LINES" --format text) ||
    die "herdr agent read failed for target: $TARGET"
fi
[[ -n ${raw//[[:space:]]/} ]] || die "no output to read"
# Keep only the tail: the agent's latest reply is at the bottom.
((${#raw} <= MAX_CHARS)) || raw=${raw: -MAX_CHARS}

# --- 2. Convert via llama.cpp ------------------------------------------------
read -r -d '' SYSTEM_PROMPT <<'EOF' || true
あなたは音声読み上げ用の文章を作るアシスタントです。
入力はコーディングエージェントが動いている端末の画面キャプチャです。

ルール:
- UIの装飾、プロンプト、スピナー、ツール呼び出しのログなどは無視し、エージェントの最新の返答だけを対象にしてください。
- その内容を、読み上げ用に短い1〜4文に要約してください。
- 入力が英語でも、出力は必ず日本語にしてください。
- 出力にアルファベット(ASCII文字のA〜Z、a〜z)を一切含めないでください。英単語、識別子、コマンド名はカタカナに変換してください(例: git commit → ギットコミット、API → エーピーアイ、npm test → エヌピーエムテスト)。
- コードブロック、ファイルパス、URL、記号は省略してください。数字は使って構いません。
- ずんだもんの口調で話してください。一人称は「ボク」、語尾は「〜なのだ」「〜のだ」です。
- 読み上げる文章だけを出力してください。前置きや説明は不要です。
EOF

body=$(jq -n \
  --arg model "$LLAMA_MODEL" \
  --arg sys "$SYSTEM_PROMPT" \
  --arg user "$raw" \
  '{
    model: $model,
    temperature: 0.3,
    max_tokens: 1024,
    chat_template_kwargs: {enable_thinking: false},
    messages: [
      {role: "system", content: $sys},
      {role: "user", content: $user}
    ]
  }')

# Free VRAM right away via llama-swap instead of waiting for its ttl.
unload_model() {
  [[ $LLAMA_UNLOAD == 1 ]] || return 0
  curl -sf --max-time 30 -X POST \
    "$LLAMA_URL/api/models/unload/$(jq -rn --arg m "$LLAMA_MODEL" '$m | @uri')" >/dev/null ||
    echo "aivoice: warning: failed to unload $LLAMA_MODEL (set LLAMA_UNLOAD=0 if not using llama-swap)" >&2
}

resp=$(curl -sf --max-time 300 \
  -H 'Content-Type: application/json' \
  --data-binary "$body" \
  "$LLAMA_URL/v1/chat/completions") || {
  unload_model
  die "llama server unreachable or failed at $LLAMA_URL"
}
unload_model

# Strip <think>...</think> blocks (reasoning models), then trim whitespace.
text=$(jq -r '.choices[0].message.content // ""
  | gsub("<think>[\\s\\S]*?</think>"; "")
  | gsub("^\\s+|\\s+$"; "")' <<<"$resp") ||
  die "unexpected response from llama server"
if [[ -z $text ]]; then
  echo "aivoice: response from llama server:" >&2
  jq '.choices[0] | {finish_reason, message}' <<<"$resp" >&2 || printf '%s\n' "$resp" >&2
  die "llama server returned empty text (model: $LLAMA_MODEL)"
fi

if [[ $DRY_RUN -eq 1 ]]; then
  printf '%s\n' "$text"
  exit 0
fi

# --- 3. Speak via VOICEVOX ---------------------------------------------------
if [[ -z $PLAYER ]]; then
  if command -v pw-play >/dev/null 2>&1; then
    PLAYER=pw-play
  elif command -v aplay >/dev/null 2>&1; then
    PLAYER=aplay
  else
    die "no audio player found (install pw-play or aplay, or set PLAYER)"
  fi
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

curl -sf --max-time 30 -X POST -G "$VOICEVOX_URL/audio_query" \
  --data-urlencode "text=$text" \
  -d "speaker=$VOICEVOX_SPEAKER" \
  -o "$tmp/query.json" ||
  die "VOICEVOX audio_query failed at $VOICEVOX_URL"

jq --argjson vol "$VOICEVOX_VOLUME" --argjson speed "$VOICEVOX_SPEED" \
  '.volumeScale = $vol | .speedScale = $speed' "$tmp/query.json" >"$tmp/query-vol.json" ||
  die "failed to set volume/speed in VOICEVOX query"

curl -sf --max-time 120 -X POST "$VOICEVOX_URL/synthesis?speaker=$VOICEVOX_SPEAKER" \
  -H 'Content-Type: application/json' \
  --data-binary "@$tmp/query-vol.json" \
  -o "$tmp/out.wav" ||
  die "VOICEVOX synthesis failed at $VOICEVOX_URL"

# shellcheck disable=SC2086 # allow PLAYER to carry arguments
$PLAYER "$tmp/out.wav"

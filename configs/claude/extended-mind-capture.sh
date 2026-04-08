#!/usr/bin/env bash
# extended-mind-capture.sh — Claude Code Stop hook
# Captures conversational messages from session transcripts to Obsidian vault.
# Receives JSON on stdin: { session_id, transcript_path, stop_hook_active, cwd }

# Fail silently on any error
trap 'exit 0' ERR
set -uo pipefail

VAULT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Extended Mind 1.0"

# Fail silently if vault doesn't exist
[[ -d "$VAULT" ]] || exit 0

# Parse stdin JSON
INPUT="$(cat)"
SESSION_ID="$(echo "$INPUT" | jq -r '.session_id // empty')"
TRANSCRIPT_PATH="$(echo "$INPUT" | jq -r '.transcript_path // empty')"
STOP_HOOK_ACTIVE="$(echo "$INPUT" | jq -r '.stop_hook_active // false')"
CWD="$(echo "$INPUT" | jq -r '.cwd // empty')"

# Exit if hook already triggered a continuation (prevent infinite loops)
[[ "$STOP_HOOK_ACTIVE" == "true" ]] && exit 0

# Exit if required fields are missing
[[ -z "$SESSION_ID" || -z "$TRANSCRIPT_PATH" ]] && exit 0

# Exit if transcript file doesn't exist
[[ -f "$TRANSCRIPT_PATH" ]] || exit 0

DATE="$(date +%Y-%m-%d)"
OUTPUT_DIR="$VAULT/memory/sessions/raw/$DATE"
OUTPUT_FILE="$OUTPUT_DIR/$SESSION_ID.md"

mkdir -p "$OUTPUT_DIR"

# Extract messages from JSONL transcript using jq
# - Select user/assistant messages, skip isMeta
# - For user: content is a string
# - For assistant: content is array, extract text blocks only
MESSAGES="$(jq -r '
  select((.type == "user" or .type == "assistant") and (.isMeta != true))
  | if .type == "user" then
      "### User\n\n" + (
        if (.message.content | type) == "string" then .message.content
        elif (.message.content | type) == "array" then
          [.message.content[]? | select(.type == "text") | .text] | join("\n")
        else ""
        end
      ) + "\n"
    elif .type == "assistant" then
      "### Assistant\n\n" + (
        [.message.content[]? | select(.type == "text") | .text] | join("\n")
      ) + "\n"
    else empty
    end
' "$TRANSCRIPT_PATH" 2>/dev/null || true)"

# Exit if no messages extracted
[[ -z "$MESSAGES" ]] && exit 0

# Count total message headings in extracted content
TOTAL_HEADINGS="$(echo "$MESSAGES" | grep -c '^### ' || true)"

if [[ -f "$OUTPUT_FILE" ]]; then
  # Dedup: count existing headings, append only new ones
  EXISTING_HEADINGS="$(grep -c '^### ' "$OUTPUT_FILE" || true)"

  if [[ "$TOTAL_HEADINGS" -le "$EXISTING_HEADINGS" ]]; then
    # No new messages
    exit 0
  fi

  # Extract only the new messages (skip the first EXISTING_HEADINGS blocks)
  # Split on "### " boundary, skip already-written blocks
  echo "$MESSAGES" | awk -v skip="$EXISTING_HEADINGS" '
    /^### / { block++ }
    block > skip { print }
  ' >> "$OUTPUT_FILE"
else
  # First write: create file with header
  {
    echo "# Session Transcript"
    echo ""
    echo "**Session:** $SESSION_ID"
    echo "**Date:** $DATE"
    echo "**Working directory:** $CWD"
    echo ""
    echo "---"
    echo ""
    echo "$MESSAGES"
  } > "$OUTPUT_FILE"
fi

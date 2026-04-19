#!/usr/bin/env bash
set -euo pipefail
raw="$(curl -fsS --max-time 5 'https://wttr.in/Bad+Lippspringe?format=%c+%t' 2>/dev/null || true)"
raw="${raw//+/ }"
raw="$(printf '%s' "$raw" | tr -s ' ' | xargs)"
if [[ -z "$raw" ]]; then
  printf 'n/a'
else
  printf '%s  Bad Lippspringe' "$raw"
fi

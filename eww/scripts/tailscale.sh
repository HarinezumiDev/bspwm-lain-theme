#!/usr/bin/env bash
set -euo pipefail

if ! command -v tailscale >/dev/null 2>&1; then
  printf 'na'
  exit 0
fi

tailscale status --json 2>/dev/null | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
    state = str(data.get("BackendState", "")).lower()
    if state == "running":
        print("on")
    elif state:
        print(state)
    else:
        print("na")
except Exception:
    print("na")
'

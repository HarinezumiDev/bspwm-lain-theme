#!/usr/bin/env bash
set -euo pipefail

focused=$(bspc query -D -d focused)
all=($(bspc query -D))

index=1
for i in "${!all[@]}"; do
  if [[ "${all[$i]}" = "$focused" ]]; then
    index=$((i+1))
    break
  fi
done

total=${#all[@]}

printf '%s/%s' "$index" "$total"

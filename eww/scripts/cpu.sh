#!/usr/bin/env bash
set -euo pipefail

state_file="/tmp/lain_cpu.stat"

read -r _ user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
idle_all=$((idle + iowait))
non_idle=$((user + nice + system + irq + softirq + steal))
total=$((idle_all + non_idle))

if [[ -r "$state_file" ]]; then
  read -r prev_idle prev_total < "$state_file" || true
  diff_idle=$((idle_all - prev_idle))
  diff_total=$((total - prev_total))
  if (( diff_total > 0 )); then
    usage=$(( (100 * (diff_total - diff_idle)) / diff_total ))
  else
    usage=0
  fi
else
  usage=0
fi

printf '%s' "$usage"
printf '%s %s\n' "$idle_all" "$total" > "$state_file"

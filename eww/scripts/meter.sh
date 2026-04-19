#!/usr/bin/env bash
set -euo pipefail

CPU_STATE="/tmp/lain_cpu.stat"

read -r _ user nice system idle iowait irq softirq steal _ _ < /proc/stat
idle_all=$((idle + iowait))
non_idle=$((user + nice + system + irq + softirq + steal))
total=$((idle_all + non_idle))
if [[ -r "$CPU_STATE" ]]; then
  read -r prev_idle prev_total < "$CPU_STATE" || true
  diff_idle=$((idle_all - prev_idle))
  diff_total=$((total - prev_total))
  if (( diff_total > 0 )); then
    pct=$(( (100*(diff_total-diff_idle))/diff_total ))
  else
    pct=0
  fi
else
  pct=0
fi
printf '%s %s\n' "$idle_all" "$total" > "$CPU_STATE"

temp_raw=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo 0)
temp=$(( temp_raw / 1000 ))

mem_total=$(awk '/MemTotal:/    {print $2}' /proc/meminfo)
mem_avail=$(awk '/MemAvailable:/{print $2}' /proc/meminfo)
mem_used=$(( mem_total - mem_avail ))
mem_total_gb=$(awk "BEGIN{printf \"%.0f\", ${mem_total}/1024/1024+0.5}")
mem_used_gb=$(awk  "BEGIN{printf \"%.1f\", ${mem_used}/1024/1024}")

read -r dsk_used dsk_total <<< "$(df / --output=used,size | tail -1)"
dsk_used_gb=$(awk  "BEGIN{printf \"%.0f\", ${dsk_used}/1024/1024+0.5}")
dsk_total_gb=$(awk "BEGIN{printf \"%.0f\", ${dsk_total}/1024/1024+0.5}")

cpu_sfx="${temp}C..${pct}%"
ram_sfx="${mem_used_gb}/${mem_total_gb}Gb"
dsk_sfx="${dsk_used_gb}/${dsk_total_gb}Gb"

min_cpu=$(( 3 + 3 + ${#cpu_sfx} ))
min_ram=$(( 3 + 3 + ${#ram_sfx} ))
min_dsk=$(( 4 + 3 + ${#dsk_sfx} ))

FIXED=$min_cpu
[ $min_ram -gt $FIXED ] && FIXED=$min_ram
[ $min_dsk -gt $FIXED ] && FIXED=$min_dsk

# мінімальна ширина щоб header "[Present Day, Present Time]   HH:MM"
# вміщувався без стискання: 28(title) + 3(gap) + 5(time) = 36
# meter рядки = FIXED + 2(" |") — мають бути >= 36
# тобто FIXED >= 34
[ $FIXED -lt 34 ] && FIXED=34

make_line() {
  local lbl="$1" sfx="$2"
  local dots=$(( FIXED - ${#lbl} - ${#sfx} ))
  [ $dots -lt 3 ] && dots=3
  printf '%s%s%s' "$lbl" "$(printf '%*s' "$dots" '' | tr ' ' '.')" "$sfx"
}

printf '{"cpu":"%s","ram":"%s","disk":"%s"}' \
  "$(make_line "cpu"  "$cpu_sfx")" \
  "$(make_line "ram"  "$ram_sfx")" \
  "$(make_line "disk" "$dsk_sfx")"

#!/usr/bin/env bash

killall -q polybar

while pgrep -x polybar >/dev/null; do sleep 0.05; done

for m in $(polybar --list-monitors | cut -d: -f1); do
  MONITOR=$m polybar main >/dev/null 2>&1 & disown
done

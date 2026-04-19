#!/usr/bin/env bash

cap=$(cat /sys/class/power_supply/BAT*/capacity)
stat=$(cat /sys/class/power_supply/BAT*/status)

if [ "$stat" = "Charging" ]; then
  echo "󰂄 ${cap}%"
  exit 0
fi

icons=(󰂎 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)
idx=$((cap / 10))
echo "${icons[$idx]} ${cap}%"


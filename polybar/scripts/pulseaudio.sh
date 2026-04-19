#!/usr/bin/env bash

vol=$(pamixer --get-volume)
mute=$(pamixer --get-mute)

if [ "$mute" = "true" ]; then
  echo "󰖁"
  exit 0
fi

if [ "$vol" -lt 30 ]; then
  icon="󰕿"
elif [ "$vol" -lt 70 ]; then
  icon="󰖀"
else
  icon="󰕾"
fi

echo "$icon ${vol}%"


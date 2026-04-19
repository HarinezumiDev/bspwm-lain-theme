#!/usr/bin/env bash

info=$(nmcli -t -f IN-USE,SIGNAL,DEVICE dev wifi | awk -F: '$1=="*"')
signal=$(echo "$info" | cut -d: -f2)

if [ -z "$signal" ]; then
  echo "󰖪"
  exit 0
fi

echo "󰖩 ${signal}%"


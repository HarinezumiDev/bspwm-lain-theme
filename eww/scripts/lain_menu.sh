#!/usr/bin/env bash
set -euo pipefail

pgrep -x eww >/dev/null 2>&1 || (eww daemon >/dev/null 2>&1 &)
sleep 0.15
eww open --toggle lain_popup

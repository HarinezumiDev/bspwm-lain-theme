#!/usr/bin/env bash
total=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
avail=$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)
used=$((total - avail))
echo $((used * 100 / total))

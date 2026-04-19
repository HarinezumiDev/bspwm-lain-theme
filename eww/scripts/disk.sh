#!/usr/bin/env bash
df -P / | awk 'NR==2 {gsub("%","",$5); print $5}'

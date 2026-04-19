#!/usr/bin/env bash

group=$(xset -q | awk '/LED/ {print substr($10,5,1)}')

case "$group" in
  0) layout="de" ;;
  1) layout="ua" ;;
  2) layout="ru" ;;
  *) layout="??" ;;
esac

echo " $layout"

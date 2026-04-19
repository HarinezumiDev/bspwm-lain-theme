#!/usr/bin/env bash

set -e

CONFIG_DIR="$HOME/.config"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "WARNING: This script will overwrite existing files in ~/.config."
echo "It is strongly recommended to BACK UP your current configuration before continuing."
read -rp "Continue? [y/N]: " confirm

case "$confirm" in
  y|Y) ;;
  *) echo "Aborted."; exit 1 ;;
esac

echo "Select platform:"
echo "1) desktop"
echo "2) laptop"
read -rp "Enter choice [1/2]: " choice

case "$choice" in
  1) POLYBAR_SRC="polybar" ;;
  2) POLYBAR_SRC="polybar-laptop" ;;
  *) echo "Invalid choice."; exit 1 ;;
esac

echo "Installing configs..."

mkdir -p "$CONFIG_DIR"

cp -r "$REPO_DIR/bspwm" "$CONFIG_DIR/"
cp -r "$REPO_DIR/sxhkd" "$CONFIG_DIR/"
cp -r "$REPO_DIR/eww" "$CONFIG_DIR/"
cp -r "$REPO_DIR/picom" "$CONFIG_DIR/"
cp -r "$REPO_DIR/rofi" "$CONFIG_DIR/"
cp -r "$REPO_DIR/fastfetch" "$CONFIG_DIR/"

rm -rf "$CONFIG_DIR/polybar"
cp -r "$REPO_DIR/$POLYBAR_SRC" "$CONFIG_DIR/polybar"

echo "Done."

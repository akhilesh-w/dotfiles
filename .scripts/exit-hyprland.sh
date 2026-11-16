#!/usr/bin/env bash
# Confirm before leaving Hyprland. Super+M used to exit immediately.
choice="$(printf 'No\nYes, exit Hyprland\n' | wofi --dmenu --prompt 'Exit Hyprland?' --width 360 --height 160)"
[[ "$choice" == Yes,* ]] || exit 0
hyprctl dispatch 'hl.dsp.exit()'

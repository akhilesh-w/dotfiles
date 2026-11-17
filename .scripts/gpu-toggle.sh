#!/usr/bin/env bash
# NVIDIA GPU switch (Waybar icon, quick actions). Off = driver unloaded and
# the card fully powered down. prime-run turns it back on automatically.
set -uo pipefail

helper=(sudo -n /usr/local/bin/gpu-power)
state=off; [[ -d /sys/module/nvidia ]] && state=on

if [[ "$state" == on ]]; then
  if err="$("${helper[@]}" off 2>&1)"; then
    notify-send -a 'NVIDIA GPU' -i video-display 'NVIDIA GPU off' 'The GTX 1650 is powered down. Apps started with prime-run turn it back on.'
  else
    notify-send -a 'NVIDIA GPU' -u critical 'NVIDIA GPU is still in use' "Close these first: ${err//,/, }"
  fi
else
  if "${helper[@]}" on 2>/dev/null; then
    notify-send -a 'NVIDIA GPU' -i video-display 'NVIDIA GPU on' 'Start games and apps with prime-run (or Super+Shift+D) to use it.'
  else
    notify-send -a 'NVIDIA GPU' -u critical 'Could not turn the NVIDIA GPU on'
  fi
fi
pkill -RTMIN+10 waybar

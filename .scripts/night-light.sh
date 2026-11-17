#!/usr/bin/env bash
# Toggle the warm night light now. The automatic schedule is in
# ~/.config/hypr/hyprsunset.conf (warm from 19:30, normal from 07:00).
set -uo pipefail

pgrep -x hyprsunset >/dev/null || { hyprsunset >/dev/null 2>&1 & disown; sleep 0.5; }

temp="$(hyprctl hyprsunset temperature 2>/dev/null | tr -dc '0-9')"
if [[ -n "$temp" ]] && ((temp < 6000)); then
  hyprctl hyprsunset identity >/dev/null
  notify-send -a 'Night light' -i weather-clear 'Night light off'
else
  hyprctl hyprsunset temperature 4500 >/dev/null
  notify-send -a 'Night light' -i weather-clear-night 'Night light on' 'Warmer colors until you turn it off or the schedule changes.'
fi

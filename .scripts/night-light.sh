#!/usr/bin/env bash
# Toggle the warm night light. The automatic schedule is in
# ~/.config/hypr/hyprsunset.conf (warm from 19:30, normal from 07:00).
#
# hyprsunset keeps reporting the last temperature even after "identity",
# so the on/off state is tracked here. A manual toggle only counts until
# the next scheduled switch; after that the schedule decides again.
set -uo pipefail

state_file="${XDG_RUNTIME_DIR:-/tmp}/night-light-state"
warm=4500
on_at=1930   # keep in sync with hyprsunset.conf
off_at=700

pgrep -x hyprsunset >/dev/null || { hyprsunset >/dev/null 2>&1 & disown; sleep 0.5; }

now=$((10#$(date +%H%M)))
if ((now >= on_at || now < off_at)); then schedule=on; else schedule=off; fi

# Time of the most recent scheduled switch, as a Unix timestamp.
last_on=$(date -d "today $((on_at / 100)):$((on_at % 100))" +%s)
last_off=$(date -d "today $((off_at / 100)):$((off_at % 100))" +%s)
t=$(date +%s)
((last_on > t)) && last_on=$((last_on - 86400))
((last_off > t)) && last_off=$((last_off - 86400))
last_switch=$((last_on > last_off ? last_on : last_off))

state="$schedule"
if [[ -f "$state_file" ]] && (( $(stat -c %Y "$state_file") > last_switch )); then
  state="$(cat "$state_file")"
fi

if [[ "$state" == on ]]; then
  hyprctl hyprsunset identity >/dev/null
  echo off > "$state_file"
  notify-send -a 'Night light' -i weather-clear 'Night light off'
else
  hyprctl hyprsunset temperature "$warm" >/dev/null
  echo on > "$state_file"
  notify-send -a 'Night light' -i weather-clear-night 'Night light on' 'Warm colors until you turn it off or the schedule changes.'
fi

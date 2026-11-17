#!/usr/bin/env bash
# Battery charge limit (Lenovo conservation mode).
#   charge-limit.sh            toggle between "limit to ~60%" and "charge to 100%"
#   charge-limit.sh --waybar   print the state as JSON for the Waybar icon
#
# Long_Life = conservation mode (stops around 60%), Standard = normal charging.
# Writing needs the udev rule in /etc/udev/rules.d/81-battery-charge-limit.rules,
# which lets the wheel group change charge_types.
set -uo pipefail

bat="$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1)"
file="$bat/charge_types"

current() { grep -o '\[[^]]*\]' "$file" 2>/dev/null | tr -d '[]'; }

if [[ "${1:-}" == --waybar ]]; then
  if [[ ! -r "$file" ]]; then
    echo '{"text": "", "tooltip": "Charge limit not supported"}'
    exit 0
  fi
  cap="$(cat "$bat/capacity")"
  status="$(cat "$bat/status")"
  if [[ "$(current)" == Long_Life ]]; then
    printf '{"text": "󰂃", "class": "limited", "tooltip": "Charge limit ON: stops around 60%%\\nBattery %s%%, %s\\n\\nClick to charge to 100%%"}\n' "$cap" "${status,,}"
  else
    printf '{"text": "󰂅", "class": "full", "tooltip": "Charge limit OFF: charges to 100%%\\nBattery %s%%, %s\\n\\nClick to limit charging to about 60%%"}\n' "$cap" "${status,,}"
  fi
  exit 0
fi

if [[ ! -w "$file" ]]; then
  notify-send -a 'Battery' -u critical 'Cannot change the charge limit' "No write access to $file"
  exit 1
fi

if [[ "$(current)" == Long_Life ]]; then
  echo Standard > "$file" && notify-send -a 'Battery' -i battery-full-charging 'Charge limit off' 'The battery will now charge to 100%.'
else
  echo Long_Life > "$file" && notify-send -a 'Battery' -i battery-good 'Charge limit on' 'Charging stops around 60% to protect the battery.'
fi
pkill -RTMIN+9 waybar

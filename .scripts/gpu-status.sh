#!/usr/bin/env bash
# Waybar NVIDIA GPU switch. Click toggles (gpu-toggle.sh).
#   off   dim icon, card fully powered down
#   on    green icon, idle at a few watts (this AMD laptop cannot power the
#         card down while the driver is loaded)
#   busy  green icon with load, a prime-run app is using it
if [[ ! -d /sys/module/nvidia ]]; then
  echo '{"text": "󰢮", "class": "off", "tooltip": "NVIDIA GPU off (saves about 3 W)\nClick to turn on. prime-run also turns it on by itself."}'
  exit 0
fi

read -r pstate power util < <(nvidia-smi --query-gpu=pstate,power.draw,utilization.gpu \
  --format=csv,noheader,nounits 2>/dev/null | tr -d ',')

if [[ "$pstate" == P8 && "${util:-0}" -lt 5 ]]; then
  printf '{"text": "󰢮", "class": "on", "tooltip": "NVIDIA GPU on, idle at %s W\\nClick to turn off"}\n' "${power%.*}"
else
  apps="$(nvidia-smi --query-compute-apps=process_name --format=csv,noheader 2>/dev/null | xargs -r -n1 basename | sort -u | paste -sd ', ')"
  printf '{"text": "󰢮 %s%%", "class": "busy", "tooltip": "NVIDIA GPU busy: %s%%, %s W (%s)%s\\nClick to turn off (when apps are closed)"}\n' \
    "$util" "$util" "${power%.*}" "$pstate" "${apps:+\\n$apps}"
fi

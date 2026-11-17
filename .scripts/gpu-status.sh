#!/usr/bin/env bash
# Waybar: show an icon only while the NVIDIA GPU is powered on.
# Reads sysfs only. Never calls nvidia-smi, which would wake the GPU itself.
dev=/sys/bus/pci/devices/0000:01:00.0
status="$(cat "$dev/power/runtime_status" 2>/dev/null)"

if [[ "$status" == active ]]; then
  users="$(fuser /dev/nvidia[0-9]* 2>/dev/null | tr -s ' ' '\n' | grep -E '^[0-9]+$' \
    | xargs -r -I{} ps -o comm= -p {} 2>/dev/null | sort -u | paste -sd ', ')"
  printf '{"text": "󰢮", "class": "active", "tooltip": "NVIDIA GPU is on%s\\nIt powers off by itself a few seconds after apps stop using it."}\n' \
    "${users:+\\nUsed by: $users}"
else
  echo '{"text": "", "class": "off"}'
fi

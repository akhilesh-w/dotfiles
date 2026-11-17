#!/usr/bin/env bash
# Waybar: show an icon only while the NVIDIA GPU is actually working.
#
# On this AMD laptop the GTX 1650 cannot power off completely (NVIDIA only
# supports runtime D3 for Turing on Intel platforms), so it always idles in
# P8 at a few watts. The icon appears when it leaves P8, i.e. a game or other
# prime-run app is using it.
read -r pstate power util < <(nvidia-smi --query-gpu=pstate,power.draw,utilization.gpu \
  --format=csv,noheader,nounits 2>/dev/null | tr -d ',')

if [[ -z "$pstate" ]]; then
  echo '{"text": "", "class": "off"}'
  exit 0
fi

if [[ "$pstate" == P8 && "${util:-0}" -lt 5 ]]; then
  echo '{"text": "", "class": "idle"}'
else
  apps="$(nvidia-smi --query-compute-apps=process_name --format=csv,noheader 2>/dev/null | xargs -r -n1 basename | sort -u | paste -sd ', ')"
  printf '{"text": "󰢮", "class": "active", "tooltip": "NVIDIA GPU busy: %s%%, %s W (%s)%s"}\n' \
    "$util" "${power%.*}" "$pstate" "${apps:+\\n$apps}"
fi

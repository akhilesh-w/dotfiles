#!/usr/bin/env bash
# Measure where the laptop's power goes. Run it UNPLUGGED (battery reports
# the whole system's draw only while discharging).
#   power-measure.sh [seconds]     default 60
#
# Battery  = whole laptop
# Ryzen    = AMD "PPT" sensor: CPU cores + Radeon iGPU + SoC
# NVIDIA   = nvidia-smi (only when the driver is loaded; off = fully powered down)
# Rest     = Battery - Ryzen - NVIDIA: screen, RAM, SSD, Wi-Fi, fans, losses
set -uo pipefail

secs="${1:-60}"
bat="$(ls -d /sys/class/power_supply/BAT* | head -1)"
ppt="$(grep -l '^PPT$' /sys/class/hwmon/hwmon*/power1_label 2>/dev/null | head -1)"
ppt="${ppt%_label}_input"

if [[ "$(cat "$bat/status")" != Discharging ]]; then
  echo "Unplug the charger first (battery status: $(cat "$bat/status"))." >&2
  exit 1
fi

gpu_on=0; [[ -d /sys/module/nvidia ]] && gpu_on=1
sum_b=0; sum_p=0; sum_n=0; n=0
printf 'Measuring for %ss (NVIDIA driver %s). Leave the laptop idle...\n' "$secs" "$([[ $gpu_on == 1 ]] && echo loaded || echo off)"

for ((i = 0; i < secs; i++)); do
  b=$(cat "$bat/power_now")                     # microwatts
  p=$(cat "$ppt" 2>/dev/null || echo 0)          # microwatts
  g=0
  if ((gpu_on)); then
    g=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits 2>/dev/null | awk '{printf "%d", $1 * 1000000}')
  fi
  sum_b=$((sum_b + b)); sum_p=$((sum_p + p)); sum_n=$((sum_n + ${g:-0})); n=$((n + 1))
  sleep 1
done

awk -v b="$sum_b" -v p="$sum_p" -v g="$sum_n" -v n="$n" -v cap="$(cat "$bat/energy_now")" 'BEGIN {
  B = b / n / 1e6; P = p / n / 1e6; G = g / n / 1e6; R = B - P - G
  printf "\n  Whole laptop  %5.1f W\n", B
  printf "  Ryzen (CPU+iGPU) %5.1f W\n", P
  printf "  NVIDIA GPU    %5.1f W\n", G
  printf "  Everything else %4.1f W  (screen, RAM, SSD, Wi-Fi)\n", R
  if (B > 0) printf "\n  At this draw, the remaining %.1f Wh lasts about %.1f h\n", cap / 1e6, cap / 1e6 / B
}'

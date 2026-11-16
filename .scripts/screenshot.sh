#!/usr/bin/env bash
set -euo pipefail

dir="${HOME}/Pictures/Screenshots"
mkdir -p "$dir"

geometry="$(slurp)" || exit 0
file="${dir}/screenshot_$(date +'%Y%m%d_%H%M%S').png"
grim -g "$geometry" "$file"

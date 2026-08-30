#!/usr/bin/env bash
# Copy Gold Times import configs and custom NPCs onto a rAthena tree.
set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

if [[ ! -d "$RATHENA_DIR/conf" ]]; then
  log "rAthena tree not found at $RATHENA_DIR"
  exit 1
fi

mkdir -p "$RATHENA_DIR/conf/import" "$RATHENA_DIR/src/custom" "$RATHENA_DIR/npc/custom/gold_times"

if [[ -d "$OVERLAY_DIR/conf/import" ]]; then
  cp -a "$OVERLAY_DIR/conf/import/." "$RATHENA_DIR/conf/import/"
fi
if [[ -d "$OVERLAY_DIR/src/custom" ]]; then
  cp -a "$OVERLAY_DIR/src/custom/." "$RATHENA_DIR/src/custom/"
fi
if [[ -d "$OVERLAY_DIR/npc/custom/gold_times" ]]; then
  cp -a "$OVERLAY_DIR/npc/custom/gold_times/." "$RATHENA_DIR/npc/custom/gold_times/"
fi

CUSTOM_CONF="$RATHENA_DIR/npc/scripts_custom.conf"
enable_npc() {
  local rel="$1"
  if grep -qE "^//npc: ${rel}$" "$CUSTOM_CONF"; then
    sed -i "s|^//npc: ${rel}$|npc: ${rel}|" "$CUSTOM_CONF"
  elif ! grep -qE "^npc: ${rel}$" "$CUSTOM_CONF"; then
    printf '\nnpc: %s\n' "$rel" >> "$CUSTOM_CONF"
  fi
}

if [[ -f "$CUSTOM_CONF" ]]; then
  enable_npc "npc/custom/warper.txt"
  enable_npc "npc/custom/jobmaster.txt"
  enable_npc "npc/custom/platinum_skills.txt"
  enable_npc "npc/custom/healer.txt"
  enable_npc "npc/custom/stylist.txt"
  enable_npc "npc/custom/resetnpc.txt"
  enable_npc "npc/custom/gold_times/core.txt"
fi

log "Gold Times overlay applied"

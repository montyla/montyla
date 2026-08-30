#!/usr/bin/env bash
# Start login, char, and map servers in the background.
set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

cd "$RATHENA_DIR"
mkdir -p log

for bin in login-server char-server map-server; do
  if [[ ! -x $bin ]]; then
    log "Missing $bin — run scripts/build.sh first"
    exit 1
  fi
done

start_one() {
  local name="$1"
  local bin="$2"
  local logf="log/${name}.console.log"
  if pgrep -f "./${bin}" >/dev/null 2>&1; then
    log "$name already running"
    return 0
  fi
  log "Starting $name"
  nohup "./$bin" >"$logf" 2>&1 &
  echo $! >"log/${name}.pid"
}

start_one login login-server
sleep 2
start_one char char-server
sleep 2
start_one map map-server

log "Servers launched. Logs: $RATHENA_DIR/log/"

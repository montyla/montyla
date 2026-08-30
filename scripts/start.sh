#!/usr/bin/env bash
# Cloud Agent start: bring MariaDB up and import schema if needed, then return.
set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

"$ROOT/scripts/start-mariadb.sh"
if [[ -d "$RATHENA_DIR/sql-files" ]]; then
  "$ROOT/scripts/setup-db.sh"
fi
if [[ -x "$RATHENA_DIR/login-server" ]]; then
  "$ROOT/scripts/start-servers.sh"
  for port in 6900 6121 5121; do
    for _ in $(seq 1 45); do
      if ss -lnt | grep -q ":${port} "; then
        break
      fi
      sleep 1
    done
    if ! ss -lnt | grep -q ":${port} "; then
      log "Port $port did not become ready"
      exit 1
    fi
  done
  log "login/char/map are listening"
fi
log "Start complete"

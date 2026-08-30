#!/usr/bin/env bash
# Shared paths and helpers for the rAthena Gold Times toolchain.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RATHENA_DIR="${RATHENA_DIR:-$ROOT/rathena}"
OVERLAY_DIR="${OVERLAY_DIR:-$ROOT/overlay}"
RATHENA_REPO="${RATHENA_REPO:-https://github.com/rathena/rathena.git}"
PACKETVER="${PACKETVER:-20180620}"
MYSQL_SOCKET="${MYSQL_SOCKET:-/var/run/mysqld/mysqld.sock}"
MYSQL_USER="${MYSQL_USER:-ragnarok}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-ragnarok}"
MYSQL_DATABASE="${MYSQL_DATABASE:-ragnarok}"

log() {
  printf '[gold-times] %s\n' "$*"
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

run_mysql() {
  if [[ -n "${MYSQL_ROOT:-}" ]]; then
    mysql --socket="$MYSQL_SOCKET" --user=root "$@"
  elif sudo mysql --socket="$MYSQL_SOCKET" -e "SELECT 1" >/dev/null 2>&1; then
    sudo mysql --socket="$MYSQL_SOCKET" "$@"
  else
    mysql --socket="$MYSQL_SOCKET" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" "$@"
  fi
}

#!/usr/bin/env bash
# Configure and compile rAthena for classic Gold Times (pre-renewal 99/70).
set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

ensure_rathena() {
  if [[ -d "$RATHENA_DIR/src" ]]; then
    return 0
  fi
  log "Cloning rAthena from $RATHENA_REPO"
  git clone --depth 1 "$RATHENA_REPO" "$RATHENA_DIR"
}

ensure_mysql_dev() {
  if [[ ! -x /usr/bin/mysql_config && -x /usr/bin/mariadb_config ]]; then
    sudo ln -sfn /usr/bin/mariadb_config /usr/bin/mysql_config
  fi
  if [[ ! -e /usr/include/mysql/mysql.h && -e /usr/include/mariadb/mysql.h ]]; then
    sudo mkdir -p /usr/include/mysql
    sudo ln -sfn /usr/include/mariadb/mysql.h /usr/include/mysql/mysql.h
  fi
}

ensure_rathena
ensure_mysql_dev
"$ROOT/scripts/apply-overlay.sh"

cd "$RATHENA_DIR"
chmod +x configure athena-start 2>/dev/null || true

STAMP_FILE="$RATHENA_DIR/.gold-times-build-stamp"
STAMP="packetver=${PACKETVER};prere=yes;vip=yes;epoll;lto"
if [[ -x login-server && -x char-server && -x map-server && -f "$STAMP_FILE" && "$(cat "$STAMP_FILE")" == "$STAMP" ]]; then
  log "Build stamp unchanged, skipping compile"
  exit 0
fi

# Portable x86-64-v2 keeps the snapshot usable across Cloud Agent hosts.
export CFLAGS="${CFLAGS:--O3 -pipe -fno-strict-aliasing -march=x86-64-v2}"
export CXXFLAGS="${CXXFLAGS:--O3 -pipe -fno-strict-aliasing -march=x86-64-v2}"

log "Configuring rAthena (pre-re, VIP, epoll, LTO, PACKETVER=${PACKETVER})"
MYSQL_LIBS_FLAG=()
if [[ ! -e /usr/lib/x86_64-linux-gnu/libmysqlclient.so && -e /usr/lib/x86_64-linux-gnu/libmariadb.so ]]; then
  MYSQL_LIBS_FLAG=(--with-MYSQL_LIBS=-lmariadb)
fi

./configure \
  --enable-prere=yes \
  --enable-vip=yes \
  --enable-epoll \
  --enable-lto \
  --enable-packetver="$PACKETVER" \
  "${MYSQL_LIBS_FLAG[@]}"

log "Compiling servers with $(nproc) jobs"
make -j"$(nproc)" server
chmod a+x login-server char-server map-server web-server 2>/dev/null || true
printf '%s\n' "$STAMP" > "$STAMP_FILE"
log "Build finished"

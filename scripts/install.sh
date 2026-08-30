#!/usr/bin/env bash
# Cloud Agent install: toolchain, rAthena clone, compile. Must terminate.
set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

install_packages() {
  local pkgs=(
    git make gcc g++ cmake autoconf automake libtool pkg-config
    libmariadb-dev libmariadb-dev-compat zlib1g-dev libpcre3-dev
    mariadb-server mariadb-client dos2unix ca-certificates
  )
  local missing=()
  local pkg
  for pkg in "${pkgs[@]}"; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
      missing+=("$pkg")
    fi
  done
  if (( ${#missing[@]} )); then
    log "Installing packages: ${missing[*]}"
    sudo apt-get update -qq
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${missing[@]}"
  else
    log "Build packages already present"
  fi
}

install_mysql_tuning() {
  local dest=/etc/mysql/mariadb.conf.d/99-rathena-gold-times.cnf
  local src="$ROOT/etc/mysql/99-rathena-gold-times.cnf"
  if [[ -f "$src" ]]; then
    sudo cp "$src" "$dest"
  fi
}

install_packages
install_mysql_tuning
"$ROOT/scripts/build.sh"
log "Install complete"

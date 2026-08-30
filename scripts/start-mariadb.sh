#!/usr/bin/env bash
# Start MariaDB without systemd (Cloud Agent / container friendly).
set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

sudo mkdir -p /var/run/mysqld /var/lib/mysql /var/log/mysql
sudo chown mysql:mysql /var/run/mysqld /var/lib/mysql /var/log/mysql

if [[ ! -d /var/lib/mysql/mysql ]]; then
  log "Initializing MariaDB datadir"
  sudo mysql_install_db --user=mysql --datadir=/var/lib/mysql >/tmp/mysql-install-db.log
fi

if mysqladmin --socket="$MYSQL_SOCKET" ping --silent >/dev/null 2>&1 \
  || sudo mysqladmin --socket="$MYSQL_SOCKET" ping --silent >/dev/null 2>&1; then
  log "MariaDB already running"
  exit 0
fi

if [[ -f /var/run/mysqld/mysqld.pid ]] && ! kill -0 "$(cat /var/run/mysqld/mysqld.pid)" 2>/dev/null; then
  sudo rm -f /var/run/mysqld/mysqld.pid "$MYSQL_SOCKET"
fi

log "Starting mysqld"
sudo mysqld_safe --datadir=/var/lib/mysql --socket="$MYSQL_SOCKET" \
  --pid-file=/var/run/mysqld/mysqld.pid --bind-address=127.0.0.1 \
  >/var/log/mysql/mysqld-safe.log 2>&1 &

for _ in $(seq 1 60); do
  if sudo mysqladmin --socket="$MYSQL_SOCKET" ping --silent >/dev/null 2>&1; then
    log "MariaDB is ready"
    exit 0
  fi
  sleep 1
done

log "MariaDB failed to become ready"
tail -n 50 /var/log/mysql/mysqld-safe.log /var/log/mysql/error.log 2>/dev/null || true
exit 1

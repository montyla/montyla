#!/usr/bin/env bash
# Create the rAthena databases and import schema (idempotent).
set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

if [[ ! -d "$RATHENA_DIR/sql-files" ]]; then
  log "rAthena SQL files not found at $RATHENA_DIR/sql-files"
  exit 1
fi

log "Ensuring MariaDB user and databases"
sudo mysql --socket="$MYSQL_SOCKET" <<SQL
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'127.0.0.1' IDENTIFIED BY '${MYSQL_PASSWORD}';
ALTER USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
ALTER USER '${MYSQL_USER}'@'127.0.0.1' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'localhost';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'127.0.0.1';
FLUSH PRIVILEGES;
SQL

if sudo mysql --socket="$MYSQL_SOCKET" -N -e "SHOW TABLES FROM \`${MYSQL_DATABASE}\`" | grep -qx login; then
  log "Schema already present in ${MYSQL_DATABASE}"
else
  log "Importing main.sql and logs.sql"
  sudo mysql --socket="$MYSQL_SOCKET" "$MYSQL_DATABASE" < "$RATHENA_DIR/sql-files/main.sql"
  sudo mysql --socket="$MYSQL_SOCKET" "$MYSQL_DATABASE" < "$RATHENA_DIR/sql-files/logs.sql"
  if [[ -f "$RATHENA_DIR/sql-files/web.sql" ]]; then
    sudo mysql --socket="$MYSQL_SOCKET" "$MYSQL_DATABASE" < "$RATHENA_DIR/sql-files/web.sql"
  fi
fi

# Development GM account: montyla / montyla (group 99). Harmless if it already exists.
sudo mysql --socket="$MYSQL_SOCKET" "$MYSQL_DATABASE" <<'SQL'
INSERT IGNORE INTO `login` (`account_id`, `userid`, `user_pass`, `sex`, `email`, `group_id`)
VALUES (2000000, 'montyla', 'montyla', 'M', 'montyla@localhost', 99);
SQL

log "Database ready"

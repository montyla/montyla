#!/usr/bin/env bash
# Verify the pt-BR locale overlay without needing a running map-server.
set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
pass() { printf 'ok: %s\n' "$*"; }

need_cmd python3

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/conf/msg_conf/import" "$TMP/npc/custom"
if [[ ! -f "$RATHENA_DIR/conf/msg_conf/map_msg_por.conf" ]]; then
  fail "rAthena tree with map_msg_por.conf is required at $RATHENA_DIR"
fi
cp "$RATHENA_DIR/conf/msg_conf/map_msg_por.conf" "$TMP/conf/msg_conf/"
touch "$TMP/conf/msg_conf/import/map_msg_eng_conf.txt"
touch "$TMP/conf/msg_conf/import/map_msg_por_conf.txt"
cp "$RATHENA_DIR/npc/custom/warper.txt" "$TMP/npc/custom/warper.txt"
# Restore English warper if the live tree was already localized.
if grep -q "Último destino" "$TMP/npc/custom/warper.txt"; then
  git -C "$RATHENA_DIR" checkout -- npc/custom/warper.txt 2>/dev/null || true
  if grep -q "Last Warp" "$RATHENA_DIR/npc/custom/warper.txt"; then
    cp "$RATHENA_DIR/npc/custom/warper.txt" "$TMP/npc/custom/warper.txt"
  fi
fi
if ! grep -q "Last Warp" "$TMP/npc/custom/warper.txt"; then
  fail "fixture warper.txt is not the English original"
fi

python3 "$ROOT/scripts/localize-ptbr.py" "$TMP"

python3 - <<PY
from pathlib import Path
msg = Path("$TMP/conf/msg_conf/map_msg.conf").read_text(encoding="utf-8")
assert "550: Aprendiz" in msg, "default map_msg.conf missing Aprendiz"
assert "Noviço" in msg, "UTF-8 Portuguese class names missing"
assert "import: conf/msg_conf/import/map_msg_eng_conf.txt" in msg
warper = Path("$TMP/npc/custom/warper.txt").read_text(encoding="utf-8")
assert '"Último destino ^777777["+' in warper, warper.splitlines()[25]
assert "Cidades" in warper
assert "Last Warp" not in warper
assert "Masmorras" in warper
assert "Last Warp" not in warper
assert "Teleporte#" in warper
print("unit assertions passed")
PY
pass "message pack + warper unit fixtures"

# Idempotence: a second pass must not duplicate labels.
python3 "$ROOT/scripts/localize-ptbr.py" "$TMP"
count="$(grep -c "Último destino" "$TMP/npc/custom/warper.txt")"
[[ "$count" -eq 1 ]] || fail "warper localized twice ($count Último destino)"
pass "localize-ptbr.py is idempotent"

# Full overlay on the live rAthena clone.
"$ROOT/scripts/apply-overlay.sh"

grep -q "LANG_ENABLE 0x80" "$RATHENA_DIR/src/custom/defines_pre.hpp" \
  || fail "LANG_ENABLE not set in defines_pre.hpp"
grep -q "português brasileiro" "$RATHENA_DIR/conf/motd.txt" \
  || fail "MOTD is not pt-BR"
grep -q "ID não cadastrado" "$RATHENA_DIR/conf/msg_conf/login_msg.conf" \
  || fail "login_msg.conf is not pt-BR"
grep -q "0: Aprendiz" "$RATHENA_DIR/conf/msg_conf/char_msg.conf" \
  || fail "char_msg.conf missing Aprendiz"
grep -q "Mestre de Classes" "$RATHENA_DIR/npc/custom/jobmaster.txt" \
  || fail "jobmaster not translated"
grep -q "Curandeiro#prt" "$RATHENA_DIR/npc/custom/healer.txt" \
  || fail "healer display name not translated"
grep -q "Estilista#custom_stylist" "$RATHENA_DIR/npc/custom/stylist.txt" \
  || fail "stylist display name not translated"
grep -q "Reset de Status" "$RATHENA_DIR/npc/custom/resetnpc.txt" \
  || fail "reset NPC not translated"
grep -q "Habilidades Platinum" "$RATHENA_DIR/npc/custom/platinum_skills.txt" \
  || fail "platinum NPC not translated"
grep -Fq '"Último destino ^777777["+' "$RATHENA_DIR/npc/custom/warper.txt" \
  || fail "warper last-destination string is broken"
grep -q "550: Aprendiz" "$RATHENA_DIR/conf/msg_conf/map_msg.conf" \
  || fail "default map messages are not Portuguese"
grep -q "npc: npc/custom/gold_times/core.txt" "$RATHENA_DIR/npc/scripts_custom.conf" \
  || fail "gold_times core NPC not enabled"
python3 - <<PY
from pathlib import Path
p = Path("$RATHENA_DIR/conf/msg_conf/map_msg.conf")
p.read_text(encoding="utf-8")
print("map_msg.conf is valid UTF-8")
PY
pass "apply-overlay integration"

log "pt-BR locale tests passed"

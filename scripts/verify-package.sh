#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT"
COMPILER=./bin/linux-x86_64/ruasm
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM

"$COMPILER" --version=json > "$TMP/version.json"
"$COMPILER" --features=json > "$TMP/features.json"
python3 - "$TMP/version.json" "$TMP/features.json" <<'PY'
import json, sys
version = json.load(open(sys.argv[1], encoding="utf-8"))
features = json.load(open(sys.argv[2], encoding="utf-8"))
assert version["name"] == "RUASM" and version["version"] == "1.11.5"
assert version["target"] == "x86_64" and version["self_hosted"] is True
assert features["schema_version"] == 29
assert len([m for m in features["mnemonics"] if m not in {"db", "dw", "dd", "dq"}]) == 95
assert len(features["isa_model"]["declarative_forms"]) == 38
print("PASS: version and capability contracts")
PY

for source in examples/*.asm; do
  "$COMPILER" "$source" --check --diagnostics=json
  output="$TMP/$(basename "$source").bin"
  "$COMPILER" "$source" -o "$output" --quiet
  test -s "$output"
done

echo 'PASS: all example sources validate and compile'

if [ -f SHA256SUMS ]; then
  sha256sum -c SHA256SUMS
fi

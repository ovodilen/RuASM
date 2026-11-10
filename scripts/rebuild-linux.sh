#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT"
mkdir -p build
./bin/linux-x86_64/ruasm src/generated/linux/ruasm.asm -o build/ruasm --quiet
cmp bin/linux-x86_64/ruasm build/ruasm
echo 'PASS: Linux compiler rebuilt byte-for-byte'

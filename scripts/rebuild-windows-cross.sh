#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT"
mkdir -p build
./bin/linux-x86_64/ruasm src/generated/windows/ruasm-windows.asm -o build/ruasm.exe --quiet
cmp bin/windows-x86_64/ruasm.exe build/ruasm.exe
echo 'PASS: Windows PE rebuilt byte-for-byte by the Linux compiler'

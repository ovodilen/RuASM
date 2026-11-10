#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT"
find . -type f \
  -not -path './.git/*' \
  -not -path './build/*' \
  -not -name 'SHA256SUMS' \
  -print0 | sort -z | xargs -0 sha256sum > SHA256SUMS
printf 'PASS: SHA256SUMS refreshed\n'

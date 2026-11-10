#!/bin/sh
# Regenerate the complete Linux and Windows translation units from shared core and platform fragments.
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT"

compose() {
  prefix=$1
  suffix=$2
  output=$3
  tmp="$output.compose.tmp"
  cat "$prefix" src/core/ruasm-core.asm "$suffix" > "$tmp"
  awk '
    function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
    function hexvalue(s, i, d, n, c) {
      sub(/^0[xX]/, "", s); n=0
      for (i=1; i<=length(s); i++) {
        c=tolower(substr(s,i,1)); d=index("0123456789abcdef",c)-1
        if (d < 0) return -1
        n=n*16+d
      }
      return n
    }
    {
      line=$0
      sub(/[ \t]*;.*/, "", line)
      if (line !~ /^[ \t]*$/) {
        sub(/^[ \t]+/, "", line)
        gsub(/[ \t]+/, " ", line)
        gsub(/[ \t]*,[ \t]*/, ",", line)
        if (line ~ /^db /) {
          rest=substr(line,4); count=split(rest, part, ","); converted="db "; ok=1
          for (i=1; i<=count; i++) {
            t=trim(part[i])
            if (t ~ /^0[xX][0-9a-fA-F]+$/) v=hexvalue(t)
            else if (t ~ /^[0-9]+$/) v=t+0
            else { ok=0; break }
            if (v < 0 || v > 255) { ok=0; break }
            if (i>1) converted=converted ","
            converted=converted sprintf("%d",v)
          }
          if (ok) line=converted
        }
        print line
      }
    }
  ' "$tmp" > "$tmp.compact"
  awk '
    function flush_db() { if (pending != "") print "db " pending; pending="" }
    /^db [0-9][0-9,]*$/ {
      body=substr($0,4)
      if (pending == "") pending=body
      else if (length(pending)+1+length(body) <= 3800) pending=pending "," body
      else { flush_db(); pending=body }
      next
    }
    { flush_db(); print }
    END { flush_db() }
  ' "$tmp.compact" > "$tmp.merged"
  mv -f "$tmp.merged" "$tmp"
  rm -f "$tmp.compact"
  bytes=$(wc -c < "$tmp")
  [ "$bytes" -le 196607 ] || { echo "ERROR: source exceeds RUASM's 196607-byte input limit ($bytes bytes)" >&2; exit 1; }
  cmp -s "$tmp" "$output" || mv -f "$tmp" "$output"
  rm -f "$tmp"
}

compose src/platform/linux/ruasm-prefix.asm src/platform/linux/ruasm-suffix.asm src/generated/linux/ruasm.asm
compose src/platform/windows/ruasm-prefix.asm src/platform/windows/ruasm-suffix.asm src/generated/windows/ruasm-windows.asm
printf 'PASS: Linux and Windows sources composed from the shared core\n'

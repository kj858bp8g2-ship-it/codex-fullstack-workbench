#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 4 || "$1" != '--input' || "$3" != '--output' ]]; then
  printf '%s\n' 'Usage: convert-document.sh --input FILE --output FILE' >&2
  exit 2
fi

input=$2
output=$4
[[ -f "$input" ]] || { printf 'Input file does not exist: %s\n' "$input" >&2; exit 1; }
[[ "$input" != "$output" ]] || { printf '%s\n' 'Input and output must be different.' >&2; exit 1; }
[[ -d "$(dirname "$output")" ]] || { printf 'Output directory does not exist: %s\n' "$(dirname "$output")" >&2; exit 1; }
[[ ! -e "$output" ]] || { printf 'Output file already exists: %s\n' "$output" >&2; exit 1; }
command -v markitdown >/dev/null 2>&1 || {
  printf "%s\n" "MarkItDown was not found. Install it with: pip install 'markitdown[all]'" >&2
  exit 1
}

markitdown "$input" -o "$output"
printf 'Converted: %s -> %s\n' "$input" "$output"

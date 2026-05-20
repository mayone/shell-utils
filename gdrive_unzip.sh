#!/usr/bin/env bash
#
# Unzip multi-part Google Drive zip downloads into a single folder.
#
# Google Drive splits large folder downloads into parts named like
#   <prefix>-001.zip
#   <prefix>-002.zip
#   ...
# Each part contains a portion of the same root folder. Extracting all parts
# into the same parent directory merges them back into one folder.

set -euo pipefail
IFS=$'\n\t'

SOURCE="${BASH_SOURCE[0]:-$0}"
DIR_PATH="$( cd -- "$( dirname -- "$SOURCE" )" >/dev/null 2>&1 && pwd -P )"
# shellcheck source=utils/index.sh
source "$DIR_PATH/utils/index.sh"

unzip_parts() {
  if (( $# < 1 || $# > 2 )); then
    echo "<one_of_the_zips> [out_dir]   Unzip multi-part Google Drive zips into one folder." >&2
    return 1
  fi

  local sample="$1"
  local out_dir="${2:-}"

  if ! check_exist "$sample"; then
    err "File not found: $sample"
  fi

  # Strip the "-NNN.zip" suffix to derive the shared prefix of all parts.
  local prefix="${sample%-[0-9][0-9][0-9].zip}"
  if [[ "$prefix" == "$sample" ]]; then
    err "Filename does not match the expected '<prefix>-NNN.zip' pattern: $sample"
  fi

  # Default output: same directory as the input zip; the inner root folder
  # inside each zip becomes the merged output folder.
  if [[ -z "$out_dir" ]]; then
    out_dir="$(dirname -- "$sample")"
  fi

  # Collect sibling parts via shell glob. Bash sorts glob matches
  # lexicographically, which is the desired part order when numbers are
  # zero-padded.
  local parts=()
  local f
  for f in "$prefix"-[0-9][0-9][0-9].zip; do
    [[ -e "$f" ]] || continue
    parts+=("$f")
  done

  if (( ${#parts[@]} == 0 )); then
    err "No matching parts found for prefix: $prefix"
  fi

  info "Found ${#parts[@]} part(s):"
  for f in "${parts[@]}"; do
    info "  $(basename -- "$f")"
  done
  info "Output directory: $out_dir"

  mkdir -p "$out_dir"

  # macOS's built-in unzip (Info-ZIP) mishandles UTF-8 filenames inside zips
  # and fails with "Illegal byte sequence" on CJK characters. Use ditto on
  # macOS — it's Apple's native archiver and decodes UTF-8 filenames
  # correctly. Note: ditto overwrites same-named files (no -n equivalent).
  local use_ditto=false
  if check_os "$OS_MAC" && check_cmd ditto; then
    use_ditto=true
  fi

  for f in "${parts[@]}"; do
    info "Unzipping $(basename -- "$f")"
    if [[ "$use_ditto" == "true" ]]; then
      ditto -x -k "$f" "$out_dir"
    else
      # -n: never overwrite existing files.
      # -q: quiet; suppress per-file extraction lines but keep errors.
      unzip -n -q "$f" -d "$out_dir"
    fi
  done

  ok "Done. Files extracted to: $out_dir"
}

show_usage() {
  print_usage "$0" \
    "<one_of_the_zips> [out_dir]   Unzip multi-part Google Drive zips into one folder."
}

main() {
  case "${1:-}" in
    "")        show_usage; exit 1 ;;
    -h|--help) show_usage; exit 0 ;;
    *)         unzip_parts "$@" ;;
  esac
}

main "$@"

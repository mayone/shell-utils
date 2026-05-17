#!/usr/bin/env bash
#
# Convert PNG to macOS ICNS.

set -euo pipefail
IFS=$'\n\t'

SOURCE="${BASH_SOURCE[0]:-$0}"
DIR_PATH="$( cd -- "$( dirname -- "$SOURCE" )" >/dev/null 2>&1 && pwd -P )"
# shellcheck source=utils/index.sh
source "$DIR_PATH/utils/index.sh"

convert_png() {
  require_args 1 "$#" "<png_file>             Convert PNG to macOS ICNS." || return 1

  local src="$1"
  local icon_name="${src%.*}.icns"
  local icons_dir="tempicon.iconset"

  info "Converting $src to $icon_name"

  mkdir "$icons_dir"

  sips -z 1024 1024 "$src" --out "$icons_dir/icon_512x512@2x.png"
  sips -z 512  512  "$icons_dir/icon_512x512@2x.png" --out "$icons_dir/icon_512x512.png"
  sips -z 512  512  "$icons_dir/icon_512x512@2x.png" --out "$icons_dir/icon_256x256@2x.png"
  sips -z 256  256  "$icons_dir/icon_512x512@2x.png" --out "$icons_dir/icon_256x256.png"
  sips -z 256  256  "$icons_dir/icon_512x512@2x.png" --out "$icons_dir/icon_128x128@2x.png"
  sips -z 128  128  "$icons_dir/icon_512x512@2x.png" --out "$icons_dir/icon_128x128.png"
  sips -z 64   64   "$icons_dir/icon_512x512@2x.png" --out "$icons_dir/icon_64x64.png"
  sips -z 32   32   "$icons_dir/icon_512x512@2x.png" --out "$icons_dir/icon_32x32.png"
  sips -z 32   32   "$icons_dir/icon_512x512@2x.png" --out "$icons_dir/icon_16x16@2x.png"
  sips -z 16   16   "$icons_dir/icon_512x512@2x.png" --out "$icons_dir/icon_16x16.png"

  iconutil -c icns "$icons_dir"
  rm -rf "$icons_dir"
  mv tempicon.icns "$icon_name"

  ok "Created $icon_name"
}

show_usage() {
  print_usage "$0" \
    "<png_file>             Convert PNG to macOS ICNS."
}

main() {
  case "${1:-}" in
    "") show_usage; exit 1 ;;
    *)  convert_png "$@" ;;
  esac
}

main "$@"

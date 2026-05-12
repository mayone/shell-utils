#!/usr/bin/env bash
#
# Wrapper for yt-dlp.

set -euo pipefail
IFS=$'\n\t'

SOURCE="${BASH_SOURCE[0]:-$0}"
DIR_PATH="$( cd -- "$( dirname -- "$SOURCE" )" >/dev/null 2>&1 && pwd -P )"
# shellcheck source=utils/index.sh
source "$DIR_PATH/utils/index.sh"

mp4() {
  require_args 1 "$#" "mp4 <YT_URL>            Download video as mp4." || return 1
  yt-dlp -i "$1" -S 'vcodec:h264,res,acodec:m4a'
}

m4a() {
  require_args 1 "$#" "m4a <YT_URL>            Download audio as m4a." || return 1
  yt-dlp -i "$1" -f 'ba[ext=m4a]'
}

playlist() {
  require_args 1 "$#" "playlist <PL_URL>       Download playlist as mp4." || return 1
  yt-dlp -i "$1" -S 'vcodec:h264,res,acodec:m4a' -o '%(playlist)s/%(title)s.%(ext)s'
}

show_usage() {
  print_usage "$0" \
    "mp4 <YT_URL>            Download video as mp4." \
    "m4a <YT_URL>            Download audio as m4a." \
    "playlist <PL_URL>       Download playlist as mp4."
}

main() {
  case "${1:-}" in
    mp4)      shift; mp4 "$@" ;;
    m4a)      shift; m4a "$@" ;;
    playlist) shift; playlist "$@" ;;
    *)        show_usage; exit 1 ;;
  esac
}

main "$@"

#!/usr/bin/env bash
#
# Wrapper for yt-dlp.

set -euo pipefail
IFS=$'\n\t'

SOURCE="${BASH_SOURCE[0]:-$0}"
DIR_PATH="$( cd -- "$( dirname -- "$SOURCE" )" >/dev/null 2>&1 && pwd -P )"
# shellcheck source=utils/index.sh
source "$DIR_PATH/utils/index.sh"

# parse_args USAGE_LINE ARG...
#
# Parses sub-command arguments: `-c` enables Chrome cookies, the single
# bare token is the URL. Sets globals:
#   PARSED_URL     - the URL
#   PARSED_COOKIES - () or (--cookies-from-browser chrome); expand it as
#                    ${PARSED_COOKIES[@]+"${PARSED_COOKIES[@]}"} so that
#                    `set -u` on bash 3.2 tolerates the empty case.
# On a missing/duplicate URL or an unknown option, prints USAGE_LINE to
# stderr and returns 1.
parse_args() {
  local usage="$1"
  shift
  PARSED_URL=""
  PARSED_COOKIES=()
  local arg
  for arg in "$@"; do
    case "$arg" in
      -c)
        PARSED_COOKIES=(--cookies-from-browser chrome)
        ;;
      -*)
        echo "$usage" >&2
        return 1
        ;;
      *)
        if [[ -n "$PARSED_URL" ]]; then
          echo "$usage" >&2
          return 1
        fi
        PARSED_URL="$arg"
        ;;
    esac
  done
  if [[ -z "$PARSED_URL" ]]; then
    echo "$usage" >&2
    return 1
  fi
}

mp4() {
  parse_args "mp4 [-c] <YT_URL>       Download video as mp4." "$@" || return 1
  yt-dlp -i "$PARSED_URL" -S 'vcodec:h264,res,acodec:m4a' \
    ${PARSED_COOKIES[@]+"${PARSED_COOKIES[@]}"}
}

m4a() {
  parse_args "m4a [-c] <YT_URL>       Download audio as m4a." "$@" || return 1
  yt-dlp -i "$PARSED_URL" -f 'ba[ext=m4a]' \
    ${PARSED_COOKIES[@]+"${PARSED_COOKIES[@]}"}
}

playlist() {
  parse_args "playlist [-c] <PL_URL>  Download playlist as mp4." "$@" || return 1
  yt-dlp -i "$PARSED_URL" -S 'vcodec:h264,res,acodec:m4a' -o '%(playlist)s/%(title)s.%(ext)s' \
    ${PARSED_COOKIES[@]+"${PARSED_COOKIES[@]}"}
}

show_usage() {
  print_usage "$0" \
    "mp4 [-c] <YT_URL>       Download video as mp4." \
    "m4a [-c] <YT_URL>       Download audio as m4a." \
    "playlist [-c] <PL_URL>  Download playlist as mp4."
  echo "  -c: use Chrome cookies (--cookies-from-browser chrome)."
  echo ""
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

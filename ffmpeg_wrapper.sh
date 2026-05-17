#!/usr/bin/env bash
#
# Wrapper for ffmpeg.

set -euo pipefail
IFS=$'\n\t'

SOURCE="${BASH_SOURCE[0]:-$0}"
DIR_PATH="$( cd -- "$( dirname -- "$SOURCE" )" >/dev/null 2>&1 && pwd -P )"
# shellcheck source=utils/index.sh
source "$DIR_PATH/utils/index.sh"

PSEUDO_ORG=https://sudo-flix.lol
# User-agent constants are kept for ad-hoc invocations; not referenced today.
# shellcheck disable=SC2034
WIN7_CHROME_UA="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36"
# shellcheck disable=SC2034
WIN10_EDGE_UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246"

download() {
  require_args 2 "$#" "dl <M3U8_LINK> <OUT>          Download video by the M3U8 file link." || return 1
  ffmpeg \
    -headers "Origin: ${PSEUDO_ORG}" \
    -i "$1" \
    -c copy "$2"
}

extract_audio() {
  require_args 2 "$#" "ext <IN_V> <OUT_A>            Extract audio from video." || return 1
  # vn: drop video; acodec copy: keep original audio stream as-is.
  ffmpeg -i "$1" -vn -acodec copy "$2"
}

merge() {
  require_args 3 "$#" "mrg <IN_V> <IN_A> <OUT_V>     Merge video and audio." || return 1
  ffmpeg -i "$1" -i "$2" \
    -c:v copy -c:a aac -strict experimental \
    -map 0:v:0 -map 1:a:0 "$3"
}

reverse() {
  require_args 2 "$#" "rev <IN> <OUT>                Reverse video." || return 1
  ffmpeg -i "$1" -vf reverse "$2"
}

concat() {
  require_args 2 "$#" "con <IN_FOLDER> <OUT_V>       Concat .mp4 files in folder." || return 1
  # -safe 0: allow special characters in the file list.
  # -c copy: stream copy, no re-encode.
  ffmpeg -f concat -safe 0 \
    -i <(for f in "$1"/*.mp4; do printf "file '%s'\n" "$f"; done) \
    -c copy "$2"
}

rotate() {
  require_args 2 "$#" "rot <IN> <OUT>                Rotate video 90 degrees clockwise." || return 1
  # 270 = clockwise 90; 90 = counterclockwise 90.
  ffmpeg -display_rotation 270 -i "$1" -c copy "$2"
}

mpeg_audio_convert() {
  require_args 2 "$#" "mpeg <IN> <OUT>               Convert m4a audio to mp3." || return 1
  ffmpeg -i "$1" -c:v copy -c:a libmp3lame -q:a 4 "$2"
}

show_usage() {
  print_usage "$0" \
    "dl <M3U8_LINK> <OUT>          Download video by the M3U8 file link." \
    "ext <IN_V> <OUT_A>            Extract audio from video." \
    "mrg <IN_V> <IN_A> <OUT_V>     Merge video and audio." \
    "rev <IN> <OUT>                Reverse video." \
    "con <IN_FOLDER> <OUT_V>       Concat .mp4 files in folder." \
    "rot <IN> <OUT>                Rotate video 90 degrees clockwise." \
    "mpeg <IN> <OUT>               Convert m4a audio to mp3."
}

main() {
  case "${1:-}" in
    dl)   shift; download "$@" ;;
    ext)  shift; extract_audio "$@" ;;
    mrg)  shift; merge "$@" ;;
    rev)  shift; reverse "$@" ;;
    con)  shift; concat "$@" ;;
    rot)  shift; rotate "$@" ;;
    mpeg) shift; mpeg_audio_convert "$@" ;;
    *)    show_usage; exit 1 ;;
  esac
}

main "$@"

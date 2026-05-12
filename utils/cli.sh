#!/usr/bin/env bash
#
# CLI helpers shared by wrapper scripts.

# print_usage SCRIPT LINE...
#
# Prints "Usage:" header followed by indented lines, each prefixed with the
# script path.
#
# Example:
#   print_usage "$0" \
#     "mp4 <URL>      Download as mp4" \
#     "m4a <URL>      Download as m4a"
print_usage() {
  local script="$1"
  shift
  echo "Usage:"
  local line
  for line in "$@"; do
    echo "  $script $line"
  done
  echo ""
}

# require_args EXPECTED ACTUAL USAGE_LINE
#
# Returns 0 if ACTUAL == EXPECTED; otherwise prints USAGE_LINE to stderr and
# returns 1. Callers typically chain with `|| return 1` to abort a sub-command
# when the argument count is wrong.
#
# Example:
#   mp4() {
#     require_args 1 "$#" "mp4 <URL>    Download as mp4." || return 1
#     yt-dlp "$1"
#   }
require_args() {
  local expected="$1"
  local actual="$2"
  local usage="$3"
  if (( actual != expected )); then
    echo "$usage" >&2
    return 1
  fi
}

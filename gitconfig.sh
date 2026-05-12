#!/usr/bin/env bash
#
# Switch user of git config.

set -euo pipefail
IFS=$'\n\t'

SOURCE="${BASH_SOURCE[0]:-$0}"
DIR_PATH="$( cd -- "$( dirname -- "$SOURCE" )" >/dev/null 2>&1 && pwd -P )"
# shellcheck source=utils/index.sh
source "$DIR_PATH/utils/index.sh"

set_user() {
  git config --global user.name "$1"
  git config --global user.email "$2"
}

print_current() {
  echo "Current:"
  git config -l | grep --color user || true
}

show_usage() {
  print_usage "$0" \
    "gmail              Switch to mayone <mayone321@gmail.com>."
}

main() {
  case "${1:-}" in
    gmail) set_user "mayone" "mayone321@gmail.com" ;;
    *)     show_usage ;;
  esac
  print_current
}

main "$@"

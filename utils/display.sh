#!/usr/bin/env bash
#
# Display message.

# Color palette exposed for sourcing scripts; not all are used in this file.
# shellcheck disable=SC2034
# Colors
CLEAR='\033[2K'
NC='\033[0m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

info() {
  printf "\r${CLEAR}  [ ${BLUE}..${NC} ] %s\n" "$1"
}

ok() {
  printf "\r${CLEAR}  [ ${GREEN}OK${NC} ] %s\n" "$1"
}

warn() {
  printf "\r${CLEAR}  [ ${YELLOW}!!${NC} ] %s\n" "$1"
}

err() {
  printf "\r${CLEAR}  [ ${RED}ERR${NC} ] %s\n" "$1"
  exit 1
}

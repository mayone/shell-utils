#!/usr/bin/env bash
#
# Check and return true/false.

# OS / arch constants exposed for sourcing scripts.
# shellcheck disable=SC2034
# Variables
declare -r TRUE=0
declare -r FALSE=1

UNAME_S=$(uname -s)
UNAME_M=$(uname -m)

OS_MAC="Darwin"
OS_LINUX="Linux"
OS_WINDOWS="CYGWIN*|MINGW32*|MSYS*|MINGW*"

ARCH_ARM="arm64"
ARCH_X64="x86_64"

check_os() {
  local pattern="$1"
  if [[ "$UNAME_S" =~ $pattern ]]; then
    return $TRUE
  else
    return $FALSE
  fi
}

check_arch() {
  local pattern="$1"
  if [[ "$UNAME_M" =~ $pattern ]]; then
    return $TRUE
  else
    return $FALSE
  fi
}

#######################################
# Check is a variable set or not.
# Arguments:
#   Variable to check.
# Returns:
#   0 if is set, 1 if unset.
#######################################
check_set() {
  if [[ ! -z "$1" ]]; then
    return $TRUE
  else
    return $FALSE
  fi
}

check_cmd() {
  command -v "$1" >/dev/null 2>&1
}

check_exist() {
  test -e "$1"
}

check_folder() {
  test -d "$1"
}

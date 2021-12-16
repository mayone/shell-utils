#!/bin/sh
#
# Check and return true/false.

# Variables
UNAME_S=$(uname -s)

SUCCESS=0
FAILURE=1

OS_MAC="Darwin"
OS_LINUX="Linux"

check_os() {
  if [ "$UNAME_S" = "$1" ]; then
    return $SUCCESS
  else
    return $FAILURE
  fi
}

check_cmd() {
  command -v "$1" >/dev/null 2>&1
}

check_exist() {
  test -e "$1" >/dev/null 2>&1
}

check_folder() {
  test -d "$1" >/dev/null 2>&1
}
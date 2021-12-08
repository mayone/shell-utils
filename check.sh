#!/bin/sh
#
# Check and return true/false.

check_cmd() {
  command -v "$1" >/dev/null 2>&1
}

check_exist() {
  test -e "$1" >/dev/null 2>&1
}

check_folder() {
  test -d "$1" >/dev/null 2>&1
}
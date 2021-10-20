#!/bin/sh

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
  printf "\r  [ ${BLUE}..${NC} ] $1\n"
}

ok() {
  printf "\r${CLEAR}  [ ${GREEN}OK${NC} ] $1\n"
}

warn() {
  printf "\r${CLEAR}  [ ${YELLOW}!!${NC} ] $1\n"
}

err() {
  printf "\r${CLEAR}  [ ${RED}ERR${NC} ] $1\n"
  exit
}

check_cmd() {
  command -v "$1" >/dev/null 2>&1
}

check_exist() {
  # command ls "$1" >/dev/null 2>&1
  test -e "$1" >/dev/null 2>&1
}

check_folder() {
  test -d "$1" >/dev/null 2>&1
}

backup() {
  if ! check_exist "$1"; then
    warn "$1 does not exist"
    return
  fi

  path=${1%/}

  if check_folder "$1"; then
    if check_exist "$path.bak"; then
      rm -r "$path.bak"
    fi
    cp -r "$path"{,.bak}
  else
    #cp "$1"{,.bak}
    cp --backup=numbered "$1"{,.bak}
  fi

  if check_exist "$path.bak"; then
    ok "Backup of $path created"
  fi
}

sync_date() {
  sudo date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z"
}
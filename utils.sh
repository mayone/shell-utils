#!/bin/bash

DIR_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $DIR_PATH/display.sh
source $DIR_PATH/check.sh

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
#!/bin/sh
#
# Handle file.

# Use ${BASH_SOURCE[0]} if script is not executed by source, else use $0
SOURCE="${BASH_SOURCE[0]:-$0}"
DIR_PATH="$( cd -- "$( dirname -- "$SOURCE" )" >/dev/null 2>&1 && pwd -P )"

source $DIR_PATH/utils/index.sh

backup() {
  if ! check_exist "$1"; then
    warn "$1 does not exist"
    return
  fi

  TARGET_PATH=${1%/}

  if check_folder "$1"; then
    if check_exist "$TARGET_PATH.bak"; then
      rm -r "$TARGET_PATH.bak"
    fi
    cp -r "$TARGET_PATH"{,.bak}
  else
    cp "$1"{,.bak}
  fi

  if check_exist "$TARGET_PATH.bak"; then
    ok "Backup of $TARGET_PATH created"
  fi
}
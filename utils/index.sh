#!/usr/bin/env bash
#
# Index file.

# Use ${BASH_SOURCE[0]} if script is not executed by source, else use $0
SOURCE="${BASH_SOURCE[0]:-$0}"
DIR_PATH="$( cd -- "$( dirname -- "$SOURCE" )" >/dev/null 2>&1 && pwd -P )"

# shellcheck source=display.sh
source "$DIR_PATH/display.sh"
# shellcheck source=cli.sh
source "$DIR_PATH/cli.sh"
# shellcheck source=check.sh
source "$DIR_PATH/check.sh"
# shellcheck source=date.sh
source "$DIR_PATH/date.sh"
# shellcheck source=ip.sh
source "$DIR_PATH/ip.sh"
# shellcheck source=blockchain.sh
source "$DIR_PATH/blockchain.sh"

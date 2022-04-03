#!/bin/sh
#
# Switch user of git config.

GMAIL="gmail"
INSYDE="insyde"

USERS="\
${GMAIL} \
${INSYDE} \
"

main() {
  if [ "$#" == 1 ]; then
    if [ "$1" == "${GMAIL}" ]; then
      set_name "mayone"
      set_email "mayone321@gmail.com"
    elif [ "$1" == "${INSYDE}" ]; then
      set_name "wayne jeng"
      set_email "wayne.jeng@insyde.com"
    else
      show_usage "$@"
    fi
  else
    show_usage "$@"
  fi

  echo "Current:"
  git config -l | grep --color user
}

set_name() {
  if [ "$#" != 1 ]; then
    return
  fi
  git config --global user.name "$1"
}

set_email() {
  if [ "$#" != 1 ]; then
    return
  fi
  git config --global user.email "$1"
}

show_usage() {
  echo "Usage:"
  echo "  $0 <user>"
  echo ""
  echo "Users:"
  for USER in ${USERS}; do
    echo "  ${USER}"
  done
  echo ""
}

main "$@"
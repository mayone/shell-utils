#!/bin/bash
#
# Get IP address.

# Variables
IPV4=4
IPV6=6

#######################################
# Get public IP address.
# Arguments:
#   IP Version number.
# Returns:
#   IP address as string.
#######################################
get_public_ip() {
  if [[ "$#" == 1 && "$IPV6" =~ "$1" ]]; then
    VER=$IPV6
  else
    VER=$IPV4
  fi
  host -$VER myip.opendns.com resolver1.opendns.com \
    | tail -1 \
    | sed -e 's#.*address \(\)#\1#'
}

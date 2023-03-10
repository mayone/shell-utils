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
# Outputs:
#   IP address as string.
#######################################
get_public_ip() {
  if [[ "$#" == 1 && "$1" == "$IPV6" ]]; then
    VER=$IPV6
  else
    VER=$IPV4
  fi
  host -$VER myip.opendns.com resolver1.opendns.com \
    | grep 'address' \
    | sed -e 's#.*address \(\)#\1#'
}

get_private_ip() {
  ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}'
  # OSX
  # ipconfig getifaddr en0
  # Linux
  # hostname -I | grep -o '^[0-9.]*'
}